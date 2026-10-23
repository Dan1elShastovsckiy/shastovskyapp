#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this setup script as root." >&2
  exit 1
fi

receiver_source="${1:?Usage: bootstrap.sh RECEIVER_SCRIPT PUBLIC_KEY_FILE}"
public_key_file="${2:?Usage: bootstrap.sh RECEIVER_SCRIPT PUBLIC_KEY_FILE}"
deploy_user="shastovsky-deploy"
site_root="/var/www/shastovsky"
web_root="/var/www/html"
nginx_vhost="/etc/nginx/sites-enabled/shastovsky.com"

test -d "$web_root"
test -f "$receiver_source"
test -f "$public_key_file"
ssh-keygen -lf "$public_key_file" >/dev/null

if ! getent passwd "$deploy_user" >/dev/null; then
  useradd --system --create-home --home-dir "/home/$deploy_user" --shell /bin/sh "$deploy_user"
fi
deploy_home="$(getent passwd "$deploy_user" | cut -d: -f6)"
if [[ "$deploy_home" != "/home/$deploy_user" ]]; then
  echo "Unexpected home directory for $deploy_user: $deploy_home" >&2
  exit 1
fi
install -d -o "$deploy_user" -g "$deploy_user" -m 700 "$deploy_home/.ssh"

read -r key_type key_data key_comment < "$public_key_file"
if [[ "$key_type" != "ssh-ed25519" || -z "$key_data" ]]; then
  echo "Expected one Ed25519 public key." >&2
  exit 1
fi
printf 'restrict,command="/usr/local/sbin/shastovsky-deploy" %s %s %s\n' \
  "$key_type" "$key_data" "$key_comment" > "$deploy_home/.ssh/authorized_keys"
chown "$deploy_user:$deploy_user" "$deploy_home/.ssh/authorized_keys"
chmod 600 "$deploy_home/.ssh/authorized_keys"
# Keep PAM from treating the key-only account as locked; discard the random
# password immediately so password authentication cannot be used in practice.
random_password="$(openssl rand -hex 32)"
random_hash="$(openssl passwd -6 "$random_password")"
printf '%s:%s\n' "$deploy_user" "$random_hash" | chpasswd --encrypted
unset random_password random_hash

install -o root -g root -m 755 "$receiver_source" /usr/local/sbin/shastovsky-deploy
printf '%s ALL=(root) NOPASSWD: /usr/local/sbin/shastovsky-deploy\n' "$deploy_user" \
  > /etc/sudoers.d/shastovsky-deploy
chmod 440 /etc/sudoers.d/shastovsky-deploy
visudo -cf /etc/sudoers.d/shastovsky-deploy

install -d -o root -g root -m 755 "$site_root" "$site_root/releases"
if [[ ! -e "$site_root/current" ]]; then
  release_name="baseline-$(date -u +%Y%m%dT%H%M%SZ)"
  baseline="$site_root/releases/$release_name"
  install -d -o root -g root -m 755 "$baseline"
  cp -a "$web_root/." "$baseline/"
  rm -f "$baseline/upload.php" "$baseline/upload.php.save"
  ln -s "releases/$release_name" "$site_root/current"
fi

config_file="$(readlink -f "$nginx_vhost")"
test -f "$config_file"
backup_file="$config_file.before-shastovsky-releases"
cp -a "$config_file" "$backup_file"
config_changed=0

python3 - "$config_file" <<'PY'
from pathlib import Path
import os
import stat
import sys

path = Path(sys.argv[1])
content = path.read_text(encoding="utf-8")
legacy_root = "root /var/www/html;"
release_root = "root /var/www/shastovsky/current;"

if legacy_root in content:
    if content.count(legacy_root) != 1:
        raise SystemExit("Expected exactly one shastovsky.com webroot entry")
    content = content.replace(legacy_root, release_root, 1)
elif release_root not in content:
    raise SystemExit("The shastovsky.com webroot is neither the known legacy nor release path")

php_deny = "    location ~* \\.php(?:$|\\.) {\n        return 403;\n    }\n"
if "location ~* \\.php(?:$|\\.)" not in content:
    anchor = "    location / {\n"
    if content.count(anchor) != 1:
        raise SystemExit("Could not locate the expected shastovsky.com SPA route")
    content = content.replace(anchor, php_deny + "\n" + anchor, 1)

mode = stat.S_IMODE(path.stat().st_mode)
temporary = path.with_name(path.name + ".codex-tmp")
temporary.write_text(content, encoding="utf-8")
os.chmod(temporary, mode)
os.chown(temporary, path.stat().st_uid, path.stat().st_gid)
os.replace(temporary, path)
PY

config_changed=0
if ! cmp -s "$backup_file" "$config_file"; then
  config_changed=1
fi

rollback_nginx_config() {
  if [[ "$config_changed" -eq 1 ]]; then
    cp -a "$backup_file" "$config_file"
    nginx -t && systemctl reload nginx
  fi
}
trap rollback_nginx_config ERR

if ! nginx -t; then
  cp -a "$backup_file" "$config_file"
  nginx -t && systemctl reload nginx
  exit 1
fi
if ! systemctl reload nginx; then
  cp -a "$backup_file" "$config_file"
  nginx -t && systemctl reload nginx
  exit 1
fi

response_file="$(mktemp)"
trap 'rm -f "$response_file"' EXIT
curl --fail --silent --show-error --location --max-time 10 \
  --resolve shastovsky.com:443:127.0.0.1 \
  https://shastovsky.com/ --output "$response_file"
grep -q 'flutter_bootstrap.js' "$response_file"
status="000"
for attempt in {1..10}; do
  if status="$(curl --silent --show-error --output /dev/null --write-out '%{http_code}' \
    --max-time 3 --resolve shastovsky.com:443:127.0.0.1 \
    https://shastovsky.com/upload.php)" && [[ "$status" == "403" ]]; then
    break
  fi
  # Old Nginx workers may still be draining immediately after a graceful reload.
  if [[ "$attempt" -lt 10 ]]; then
    sleep 1
  fi
done
if [[ "$status" != "403" ]]; then
  echo "Expected /upload.php to return 403, got $status" >&2
  rollback_nginx_config
  exit 1
fi
trap - ERR

echo "Restricted deploy receiver is ready; active release: $(readlink -f "$site_root/current")"

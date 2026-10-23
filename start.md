# Карта проекта

Персональный сайт на Flutter Web: блог и путешествия, портфолио, SEO-инструменты, Firebase-вход и сохранённые отчёты. Сначала проверь `git status` и локальные инструкции; не переноси ключи и конфиги из соседних проектов.

## Где менять

| Задача | Файлы |
| --- | --- |
| Запуск и Firebase | `lib/main.dart`, `lib/firebase_options.dart` |
| URL и выбор страниц | `lib/components/route_generator.dart`; имена маршрутов объявлены в страницах |
| Меню | `lib/components/blog.dart` |
| Главная, контакты, портфолио | `lib/pages/page_list.dart`, `page_contacts.dart`, `page_portfolio.dart` |
| Статьи о поездках | `lib/pages/travel_posts/` |
| SEO и разработка | `lib/pages/pages_useful/`, `lib/data/all_articles.dart` |
| Инструменты и прогнозы | `lib/pages/pages_instruments/`, `lib/services/`, `lib/models/` |
| Аккаунт и данные | `lib/pages/page_login.dart`, `page_account.dart`, `lib/services/` |
| Общие компоненты и стили | `lib/components/`, `lib/ui/`, `lib/utils/` |
| HTML, метаданные и SEO | `web/index.html` |
| Предварительный рендер маршрутов | `prerender_tool/` |
| CI и production-деплой | `.github/workflows/main.yml`, `deploy/` |

## Проверка и сборка

Минимальный SDK по lock-файлу: Flutter 3.47.0 / Dart 3.13.0.

```bash
flutter pub get --enforce-lockfile
flutter analyze
flutter build web --release --no-web-resources-cdn --no-wasm-dry-run
```

Если менялись URL, метаданные или статьи, изучи `prerender_tool/` и проверь prerender-команду в GitHub Actions. Flutter и prerender имеют отдельные lock-файлы; оба должны быть в Git.

## Публикация

Push в `main` репозитория `Dan1elShastovsckiy/shastovskyapp` запускает `.github/workflows/main.yml`: анализ, web-сборку, prerender и публикацию на `shastovsky.com`. Активная версия будет находиться в `/var/www/shastovsky/current`. Nginx, sitemap, robots, файлы подтверждения домена и `uploads/` — серверные данные; деплой должен сохранять их. Секреты GitHub и SSH-ключи не хранятся в репозитории.

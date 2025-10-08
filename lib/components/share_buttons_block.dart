// lib/components/share_buttons_block.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal/components/components.dart';
import 'package:url_launcher/url_launcher.dart';

// Умный импорт: выбирает нужный файл в зависимости от платформы
import 'package:minimal/utils/url_provider.dart'
    if (dart.library.html) 'package:minimal/utils/url_provider_web.dart';

class ShareButtonsBlock extends StatefulWidget {
  final String shareText;
  final String shareSubject;

  const ShareButtonsBlock({
    super.key,
    this.shareText = "Смотрите, что я нашел на сайте Даниила Шастовского:",
    this.shareSubject = "Интересная страница",
  });

  @override
  State<ShareButtonsBlock> createState() => _ShareButtonsBlockState();
}

class _ShareButtonsBlockState extends State<ShareButtonsBlock> {
  late final String _currentPageUrl;

  @override
  void initState() {
    super.initState();
    _currentPageUrl = getCurrentUrl();
  }

  // Универсальная функция для запуска URL
  Future<void> _launchShareUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Показываем ошибку, если не удалось открыть ссылку
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Не удалось открыть приложение для отправки."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Методы для каждой социальной сети ---

  void _shareToTelegram() {
    final url =
        'https://t.me/share/url?url=${Uri.encodeComponent(_currentPageUrl)}&text=${Uri.encodeComponent(widget.shareText)}';
    _launchShareUrl(url);
  }

  void _shareToVK() {
    final url =
        'https://vk.com/share.php?url=${Uri.encodeComponent(_currentPageUrl)}&title=${Uri.encodeComponent(widget.shareSubject)}';
    _launchShareUrl(url);
  }

  void _shareToWhatsApp() {
    final url =
        'https://api.whatsapp.com/send?text=${Uri.encodeComponent(widget.shareText)} ${Uri.encodeComponent(_currentPageUrl)}';
    _launchShareUrl(url);
  }

  void _shareToFacebook() {
    final url =
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(_currentPageUrl)}';
    _launchShareUrl(url);
  }

  void _shareViaEmail() {
    final url =
        'mailto:?subject=${Uri.encodeComponent(widget.shareSubject)}&body=${Uri.encodeComponent(widget.shareText)} ${Uri.encodeComponent(_currentPageUrl)}';
    _launchShareUrl(url);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _currentPageUrl)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ссылка скопирована в буфер обмена!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextHeadlineSecondary(text: "Поделиться этой страницей"),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildShareButton(
              icon: Icons.telegram,
              label: "Telegram",
              onPressed: _shareToTelegram,
              color: const Color(0xFF26A5E4),
            ),
            _buildShareButton(
              // У VK нет официальной иконки в Material Icons, используем похожую
              icon: Icons.group_work,
              label: "ВКонтакте",
              onPressed: _shareToVK,
              color: const Color(0xFF4C75A3),
            ),
            _buildShareButton(
              icon: Icons.chat_bubble, // Используем общую иконку чата
              label: "WhatsApp",
              onPressed: _shareToWhatsApp,
              color: const Color(0xFF25D366),
            ),
            _buildShareButton(
              icon: Icons.facebook,
              label: "Facebook",
              onPressed: _shareToFacebook,
              color: const Color(0xFF1877F2),
            ),
            _buildShareButton(
              icon: Icons.email_outlined,
              label: "Email",
              onPressed: _shareViaEmail,
              color: Colors.grey.shade700,
            ),
            _buildShareButton(
              icon: Icons.copy,
              label: "Копировать",
              onPressed: _copyToClipboard,
              color: Colors.blueGrey.shade700,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// lib/components/google_sign_in_button.dart

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web show renderButton;
import 'package:minimal/services/auth_service.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  Future<void> _handleMobileSignIn(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.triggerMobileGoogleSignIn();
      // Перенаправление произойдет автоматически благодаря слушателям в AuthService
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Ошибка входа: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // --- ВЕБ-ВЕРСИЯ ---
      // Рендерим стандартную кнопку Google. Вся магия происходит в AuthService,
      // который слушает `authenticationEvents`.
      return web.renderButton();
    } else {
      // --- МОБИЛЬНАЯ ВЕРСИЯ ---
      return ElevatedButton.icon(
        onPressed: () => _handleMobileSignIn(context),
        icon: Image.asset('assets/images/google_logo.png', height: 22.0),
        label: const Text("Продолжить с Google"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 0,
        ),
      );
    }
  }
}

// lib/pages/page_forgot_password.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String name = 'forgot-password';
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authService = Provider.of<AuthService>(context, listen: false);
      final error =
          await authService.resetPassword(email: _emailController.text);
      setState(() => _isLoading = false);

      if (error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Ссылка для восстановления пароля была отправлена на твой email!"),
                backgroundColor: Colors.green),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: MinimalMenuBar(),
      ),
      // Добавляем drawer
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Center(
          child: MaxWidthBox(
            maxWidth: 500,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Восстановить пароль",
                      style: headlineTextStyle(context),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Введи свой email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Надо ввести email..." : null,
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: elevatedButtonStyle(context).copyWith(
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 20)),
                          ),
                          onPressed: _resetPassword,
                          child:
                              const Text("Отправить мне ссылку восстановления"),
                        ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, '/${LoginPage.name}'),
                      child: const Text("Вернуться к логину"),
                    ),
                  ),
                  divider(context),
                  const Footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

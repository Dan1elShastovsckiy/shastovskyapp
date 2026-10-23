// lib/pages/page_register.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/google_sign_in_button.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const String name = 'register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRegistering = false;
  // <<< ШАГ 1: Добавляем поле для хранения ссылки на сервис >>>
  late AuthService _authService;

  // <<< ИЗМЕНЕНИЕ 1: Добавляем initState и подписку на события AuthService >>>
  @override
  void initState() {
    super.initState();
    // <<< ШАГ 2: Получаем ссылку на сервис и СОХРАНЯЕМ ее >>>
    _authService = Provider.of<AuthService>(context, listen: false);
    // Подписываемся на события
    _authService.addListener(_onAuthStateChanged);
  }

  // <<< ИЗМЕНЕНИЕ 2: Добавляем dispose и отписываемся от событий >>>
  @override
  void dispose() {
    // <<< ШАГ 3: Используем сохраненную ссылку для отписки >>>
    _authService.removeListener(_onAuthStateChanged);

    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // <<< ИЗМЕНЕНИЕ 3: Добавляем метод-обработчик для перенаправления >>>
  void _onAuthStateChanged() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (mounted && authService.isAuthenticated && !_isRegistering) {
      // <<< НАЧАЛО ИЗМЕНЕНИЙ >>>
      // 1. Пытаемся получить маршрут для редиректа
      final redirectRoute = authService.getAndClearPostLoginRedirect();

      if (redirectRoute != null) {
        // 2. Если маршрут есть, переходим на него
        Navigator.pushNamedAndRemoveUntil(
            context, redirectRoute, (route) => false);
      } else {
        // 3. Если маршрута нет, работаем по-старому - на страницу аккаунта
        Navigator.pushReplacementNamed(context, '/${AccountPage.name}');
      }
      // <<< КОНЕЦ ИЗМЕНЕНИЙ >>>
    }
  }

  // <<< Функция регистрации (без изменений) >>>
  Future<void> _register() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    _isRegistering = true;
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final error = await authService.register(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );

      if (!mounted) return;

      if (error == null && authService.user != null) {
        try {
          await authService.user!.sendEmailVerification();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Отлично! Письмо с подтверждением отправлено на твой email"),
                  backgroundColor: Colors.green),
            );
          }
        } catch (e) {
          debugPrint("Не удалось отправить письмо с подтверждением: $e");
        }
        if (mounted) {
          // Пользователь остаётся на странице, чтобы увидеть сообщение о письме.
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error ?? "Какая-то ошибка, непонятно..."),
            backgroundColor: Colors.red));
      }
    } finally {
      _isRegistering = false;
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // <<< Функция валидации пароля (без изменений) >>>
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста введи пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен быть длиной не менее 6 символов';
    }
    final hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    if (!hasLetter || !hasDigit) {
      return 'Пароль должен содержать как минимум одну букву и одну цифру';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: MinimalMenuBar(),
      ),
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
                  const SizedBox(height: 24),
                  const Breadcrumbs(items: [
                    BreadcrumbItem(text: "Главная", routeName: '/'),
                    BreadcrumbItem(text: "Регистрация"),
                  ]),
                  const SizedBox(height: 40),
                  Text("Регистрация",
                      style: headlineTextStyle(context),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),

                  // Кнопка Google и разделитель (без изменений)
                  const GoogleSignInButton(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: divider(context)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("ИЛИ", style: subtitleTextStyle(context)),
                      ),
                      Expanded(child: divider(context)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Остальная часть формы (без изменений)
                  TextFormField(
                    controller: _firstNameController,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                        labelText: "Имя", border: OutlineInputBorder()),
                    validator: (value) =>
                        value!.isEmpty ? "Напиши свое имя пожалуйста" : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                        labelText: "Фамилия", border: OutlineInputBorder()),
                    validator: (value) =>
                        value!.isEmpty ? "Напиши свою фамилию" : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                        labelText: "Email", border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty
                        ? "Заполни свой email, пожалуйста"
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: "Пароль",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: "Подтверди пароль",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Пароль не подошел...';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      style: elevatedButtonStyle(context).copyWith(
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 20)),
                      ),
                      onPressed: _register,
                      child: const Text("Зарегистрироваться"),
                    ),

                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pushReplacementNamed(
                              context, '/${LoginPage.name}'),
                      child: const Text("У меня уже есть аккаунт, хочу войти"),
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

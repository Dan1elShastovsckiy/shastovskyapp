// lib/pages/page_login.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/google_sign_in_button.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'pages.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String name = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  // <<< ШАГ 1: Добавляем поле для хранения ссылки на сервис >>>
  late AuthService _authService;

  // <<< ИЗМЕНЕНИЕ 1: Добавляем initState и подписываемся на события AuthService >>>
  @override
  void initState() {
    super.initState();
    // <<< ШАГ 2: Получаем ссылку на сервис и СОХРАНЯЕМ ее >>>
    // listen: false здесь обязательно, так как мы не хотим перерисовывать виджет
    _authService = Provider.of<AuthService>(context, listen: false);
    // Подписываемся на события
    _authService.addListener(_onAuthStateChanged);
  }

  // <<< ИЗМЕНЕНИЕ 2: Добавляем dispose и отписываемся от событий >>>
  @override
  void dispose() {
    // <<< ШАГ 3: Используем сохраненную ссылку для отписки >>>
    // Теперь мы не обращаемся к context в dispose
    _authService.removeListener(_onAuthStateChanged);

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // <<< ИЗМЕНЕНИЕ 3: Добавляем сам метод-обработчик >>>
  // Этот метод будет автоматически вызван, когда AuthService вызовет notifyListeners()
  void _onAuthStateChanged() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (mounted && authService.isAuthenticated) {
      // <<< НАЧАЛО ИЗМЕНЕНИЙ >>>
      print('--- ШАГ 2: Сработал _onAuthStateChanged ---');
      // 1. Пытаемся получить маршрут для редиректа
      final redirectRoute = authService.getAndClearPostLoginRedirect();
      print('--- ШАГ 3: Полученный маршрут из сервиса: $redirectRoute ---');

      if (redirectRoute != null) {
        print('--- ШАГ 4: Маршрут есть! Переходим на $redirectRoute ---');
        // 2. Если маршрут есть, переходим на него
        Navigator.pushNamedAndRemoveUntil(
            context, redirectRoute, (route) => false);
      } else {
        print('--- ШАГ 4: Маршрут ПУСТОЙ! Переходим на /account ---');
        // 3. Если маршрута нет, работаем по-старому - на страницу аккаунта
        Navigator.pushReplacementNamed(context, '/${AccountPage.name}');
      }
      // <<< КОНЕЦ ИЗМЕНЕНИЙ >>>
    }
  }

  // Метод для входа по email/паролю (без изменений)
  Future<void> _login() async {
    if (_isLoading) return;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authService = Provider.of<AuthService>(context, listen: false);
      final error = await authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red));
      } else {
        // Явное перенаправление для входа по паролю остается
        //Navigator.pushReplacementNamed(context, '/${AccountPage.name}');
      }
    }
  }

  // Метод _googleSignIn() полностью удален, он больше не нужен.

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
                    BreadcrumbItem(text: "Логин"),
                  ]),
                  const SizedBox(height: 40),
                  Text("Логин",
                      style: headlineTextStyle(context),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),

                  // Кнопка Google (без изменений)
                  const GoogleSignInButton(),
                  const SizedBox(height: 20),

                  // Разделитель (без изменений)
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

                  // Форма входа (без изменений)
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    enabled: !_isLoading,
                    validator: (value) =>
                        value!.isEmpty ? "Сюда надо вводить email" : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "А тут надо ввести пароль",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    enabled: !_isLoading,
                    validator: (value) => value!.isEmpty
                        ? "Напиши тут свой пароль(я не подглядываю)"
                        : null,
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
                      onPressed: _login,
                      child: const Text("Войти"),
                    ),

                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    children: [
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pushNamed(
                                context, '/${ForgotPasswordPage.name}'),
                        child: const Text("Я забыл свой пароль"),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pushReplacementNamed(
                                context, '/${RegisterPage.name}'),
                        child: const Text("У меня нету аккаунта"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

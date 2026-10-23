// lib/services/auth_service.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // <<< Добавляем импорт
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  User? _user;
  bool _isInitialized = false;
  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<GoogleSignInAuthenticationEvent>?
      _googleEventsSubscription;
  Future<void>? _googleSignInInitialization;
  String? _postLoginRedirectRoute; // Поле для редиректа оставляем

  // <<< ИЗМЕНЕНИЕ 1: Конструктор теперь ПУСТОЙ >>>
  AuthService();

  // <<< ИЗМЕНЕНИЕ 2: Создаем новый публичный метод для инициализации >>>
  Future<void> initialize() async {
    // Вся логика из старого конструктора переезжает сюда
    _authStateSubscription ??=
        _auth.authStateChanges().listen(_onAuthStateChanged);

    await _ensureGoogleSignInInitialized();
  }

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    await _googleSignIn.initialize();
    _googleEventsSubscription = _googleSignIn.authenticationEvents.listen(
      _onGoogleAuthEvent,
      onError: (error) {
        print("Google Authentication Event Error: $error");
      },
    );
  }

  // Этот метод вызывается, когда GoogleSignIn успешно аутентифицировал пользователя
  Future<void> _onGoogleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn &&
        _auth.currentUser == null) {
      final googleUser = event.user;
      await _firebaseSignInFromGoogle(googleUser);
    }
  }

  // Обновляем состояние нашего сервиса, когда меняется пользователь Firebase
  void _onAuthStateChanged(User? firebaseUser) {
    final userChanged = _user != firebaseUser;
    final firstAuthStateReceived = !_isInitialized;
    _user = firebaseUser;
    _isInitialized = true;

    if (userChanged || firstAuthStateReceived) {
      notifyListeners();
    }
  }

  // Вспомогательный метод для входа в Firebase после успеха в Google
  Future<void> _firebaseSignInFromGoogle(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Firebase sign in from Google failed: $e");
    }
  }
  // --- НАЧАЛО: Добавляем два новых метода ---

  /// Запоминает маршрут, на который нужно вернуться после входа.
  /// Вызывается ПЕРЕД переходом на страницу логина.
  void setPostLoginRedirect(String route) {
    _postLoginRedirectRoute = route;
  }

  /// Получает сохраненный маршрут и СРАЗУ ЖЕ его очищает,
  /// чтобы он не был использован повторно при следующем входе.
  /// Вызывается ПОСЛЕ успешного входа.
  String? getAndClearPostLoginRedirect() {
    final route = _postLoginRedirectRoute;
    _postLoginRedirectRoute = null; // Очищаем после получения
    return route;
  }
  // --- КОНЕЦ ---

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  // Метод для выхода
  Future<void> logout() async {
    // disconnect() более полный, чем signOut(), он также отзывает разрешения
    await _googleSignIn.disconnect();
    await _auth.signOut();
  }

  // Этот метод нужен ТОЛЬКО для мобильных платформ, чтобы вручную запустить окно входа
  Future<void> triggerMobileGoogleSignIn() async {
    try {
      await _ensureGoogleSignInInitialized();
      await _googleSignIn.authenticate();
    } catch (e) {
      print("Mobile Google Sign-In failed: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _googleEventsSubscription?.cancel();
    super.dispose();
  }

  // --- Остальные методы (register, login, resetPassword) без изменений ---

  Future<String?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        await user.reload();
        _user = _auth.currentUser;
        notifyListeners();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

extension on GoogleSignInAuthentication {
  String? get accessToken => null;
}

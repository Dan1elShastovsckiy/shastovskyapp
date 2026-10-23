import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minimal/models/score_entry.dart'; // Убедитесь, что эта модель существует

@pragma('vm:entry-point')
class GameService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _snakeScoresCollection = 'snake_high_scores';
// Получить поток 10 лучших результатов для таблицы рекордов
  Stream<List<ScoreEntry>> getTopScores() {
    return _db
        .collection(_snakeScoresCollection)
        .orderBy('score', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScoreEntry.fromJson(doc.data()))
            .toList());
  }

// Получить ОДИН, лучший результат конкретного пользователя
  Future<ScoreEntry?> getUserBestScore(String userId) async {
    try {
      final doc =
          await _db.collection(_snakeScoresCollection).doc(userId).get();
      if (doc.exists) {
        return ScoreEntry.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print("Ошибка получения рекорда пользователя: $e");
      return null;
    }
  }

// Обновить или создать рекорд для пользователя
// Метод принимает новый результат и решает, нужно ли обновлять его в БД
  Future<void> updateUserScore({
    required String userId,
    required String userName,
    required int newScore,
  }) async {
    // Не сохраняем нулевые или отрицательные результаты
    if (newScore <= 0) return;

    try {
      final userScoreRef = _db.collection(_snakeScoresCollection).doc(userId);

      // Получаем текущий лучший результат пользователя из Firestore
      final currentScoreDoc = await userScoreRef.get();

      if (currentScoreDoc.exists) {
        // Если документ с рекордом уже существует, сравниваем счет
        final currentBest = ScoreEntry.fromJson(currentScoreDoc.data()!).score;

        // Обновляем, ТОЛЬКО ЕСЛИ новый счет СТРОГО БОЛЬШЕ старого
        if (newScore > currentBest) {
          final entry = ScoreEntry(
            userId: userId,
            userName: userName,
            score: newScore,
            updatedAt: DateTime.now(),
          );
          await userScoreRef.set(entry.toJson());
          print(
              "Новый рекорд ($newScore) сохранен для пользователя $userName.");
        } else {
          // Если счет не лучше, ничего не делаем и выводим сообщение в консоль (для отладки)
          print(
              "Текущий счет ($newScore) не лучше рекорда ($currentBest). Сохранение пропущено.");
        }
      } else {
        // Если документа нет, это первая игра пользователя, просто создаем новый
        print(
            "Первый рекорд ($newScore) сохраняется для пользователя $userName.");
        final entry = ScoreEntry(
          userId: userId,
          userName: userName,
          score: newScore,
          updatedAt: DateTime.now(),
        );
        await userScoreRef.set(entry.toJson());
      }
    } catch (e) {
      print("Ошибка при обновлении рекорда: $e");
      // В релизной версии можно добавить логирование в сервис ошибок (Sentry, Firebase Crashlytics)
      rethrow;
    }
  }
}

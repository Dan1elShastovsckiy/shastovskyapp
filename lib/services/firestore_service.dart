// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minimal/models/forecast_report.dart'; // Мы создадим этот файл на следующем шаге

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'forecast_reports';

  // Сохранить новый отчет или обновить существующий
  Future<void> saveReport(ForecastReport report) async {
    try {
      await _db.collection(_collectionPath).doc(report.id).set(report.toJson());
    } catch (e) {
      // Для отладки
      print("Firestore Service Error: Ошибка при сохранении отчета: $e");
      rethrow;
    }
  }

  // Получить один конкретный отчет по его ID
  Future<ForecastReport?> getReport(String id) async {
    try {
      final doc = await _db.collection(_collectionPath).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return ForecastReport.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print("Firestore Service Error: Ошибка при получении отчета: $e");
      return null;
    }
  }

  // Получить "живой" список (поток) отчетов для конкретного пользователя
  Stream<List<ForecastReport>> getReportsForUser(String userId) {
    return _db
        .collection(_collectionPath)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ForecastReport.fromJson(doc.data()))
            .toList());
  }
}

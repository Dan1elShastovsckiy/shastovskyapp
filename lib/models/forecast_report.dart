// lib/models/forecast_report.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minimal/models/monthly_data.dart';

// Главная модель для хранения отчета в Firestore
class ForecastReport {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime createdAt;

  // Входные данные, которые были использованы
  final List<MonthlyData> historicalData;
  final ForecastSettings settings;

  // Результаты, которые были получены
  // Ключи Enums преобразуются в строки для совместимости с JSON
  final Map<String, List<ForecastResult>> forecastResults;
  final Map<String, double> usedSeasonality;

  ForecastReport({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.historicalData,
    required this.settings,
    required this.forecastResults,
    required this.usedSeasonality,
  });

  // Метод для преобразования объекта в JSON-совместимый Map для Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'historicalData': historicalData.map((d) => d.toJson()).toList(),
      'settings': settings.toJson(),
      'forecastResults': forecastResults.map(
          (key, value) => MapEntry(key, value.map((r) => r.toJson()).toList())),
      'usedSeasonality': usedSeasonality,
    };
  }

  // Фабричный конструктор для создания объекта из данных Firestore
  factory ForecastReport.fromJson(Map<String, dynamic> json) {
    return ForecastReport(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      historicalData: (json['historicalData'] as List)
          .map((data) => MonthlyData.fromJson(data as Map<String, dynamic>))
          .toList(),
      settings:
          ForecastSettings.fromJson(json['settings'] as Map<String, dynamic>),
      forecastResults: (json['forecastResults'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
              key,
              (value as List)
                  .map(
                      (r) => ForecastResult.fromJson(r as Map<String, dynamic>))
                  .toList())),
      usedSeasonality: (json['usedSeasonality'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
    );
  }
}

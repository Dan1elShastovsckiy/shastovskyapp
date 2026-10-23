// lib/models/monthly_data.dart

class MonthlyData {
  final DateTime month;
  double yandexVisits;
  double googleVisits;
  double yandexBrandVisits;

  double totalVisits = 0;
  double brandShare = 0;
  double yandexShare = 0.5;
  double brandTraffic = 0;
  double nonBrandTraffic = 0;
  double brandTrend = 0;
  double nonBrandTrend = 0;
  double brandSeasonality = 1.0;
  double nonBrandSeasonality = 1.0;

  MonthlyData({
    required this.month,
    this.yandexVisits = 0,
    this.googleVisits = 0,
    this.yandexBrandVisits = 0,
  });

  static MonthlyData clone(MonthlyData source) {
    return MonthlyData(
      month: source.month,
      yandexVisits: source.yandexVisits,
      googleVisits: source.googleVisits,
      yandexBrandVisits: source.yandexBrandVisits,
    )
      ..totalVisits = source.totalVisits
      ..brandShare = source.brandShare
      ..yandexShare = source.yandexShare
      ..brandTraffic = source.brandTraffic
      ..nonBrandTraffic = source.nonBrandTraffic
      ..brandTrend = source.brandTrend
      ..nonBrandTrend = source.nonBrandTrend
      ..brandSeasonality = source.brandSeasonality
      ..nonBrandSeasonality = source.nonBrandSeasonality;
  }

  // TO/FROM JSON METHODS
  Map<String, dynamic> toJson() => {
        'month': month.toIso8601String(),
        'yandexVisits': yandexVisits,
        'googleVisits': googleVisits,
        'yandexBrandVisits': yandexBrandVisits,
      };

  static MonthlyData fromJson(Map<String, dynamic> json) => MonthlyData(
        month: DateTime.parse(json['month'] as String),
        yandexVisits: (json['yandexVisits'] as num).toDouble(),
        googleVisits: (json['googleVisits'] as num).toDouble(),
        yandexBrandVisits: (json['yandexBrandVisits'] as num).toDouble(),
      );
}

enum ForecastTarget { yandex, google, total, combined }

class ForecastSettings {
  final List<double> seoGrowthFactors;
  final TrendType trendType;
  final SeasonalitySource seasonalitySource;
  final ForecastTarget forecastTarget;

  ForecastSettings({
    this.seoGrowthFactors = const [1.0],
    this.trendType = TrendType.linear,
    this.seasonalitySource = SeasonalitySource.automatic,
    this.forecastTarget = ForecastTarget.total,
  });

  // TO/FROM JSON METHODS
  Map<String, dynamic> toJson() => {
        'seoGrowthFactors': seoGrowthFactors,
        'trendType': trendType.name, // Используем .name для Enums
        'seasonalitySource': seasonalitySource.name,
        'forecastTarget': forecastTarget.name,
      };

  static ForecastSettings fromJson(Map<String, dynamic> json) =>
      ForecastSettings(
        seoGrowthFactors: (json['seoGrowthFactors'] as List)
            .map((e) => (e as num).toDouble())
            .toList(),
        trendType: TrendType.values
            .byName(json['trendType'] as String), // byName для Enums
        seasonalitySource: SeasonalitySource.values
            .byName(json['seasonalitySource'] as String),
        forecastTarget:
            ForecastTarget.values.byName(json['forecastTarget'] as String),
      );
}

enum TrendType { linear, exponential }

enum SeasonalitySource { automatic, manual }

class ManualSeasonalityPoint {
  final DateTime month;
  double queryCount;

  ManualSeasonalityPoint({required this.month, this.queryCount = 0});
}

class ForecastResult {
  final DateTime month;
  final double brandForecast;
  final double nonBrandWithoutSeo;
  final double totalWithoutSeo;
  final double nonBrandGrowth;
  final double nonBrandForecast;
  final double totalGrowth;
  final double totalForecast;
  final double optimisticForecast;
  final double pessimisticForecast;

  ForecastResult({
    required this.month,
    this.brandForecast = 0,
    this.nonBrandWithoutSeo = 0,
    this.totalWithoutSeo = 0,
    this.nonBrandGrowth = 0,
    this.nonBrandForecast = 0,
    this.totalGrowth = 0,
    this.totalForecast = 0,
    this.optimisticForecast = 0,
    this.pessimisticForecast = 0,
  });

  // TO/FROM JSON METHODS
  Map<String, dynamic> toJson() => {
        'month': month.toIso8601String(),
        'brandForecast': brandForecast,
        'nonBrandWithoutSeo': nonBrandWithoutSeo,
        'totalWithoutSeo': totalWithoutSeo,
        'nonBrandGrowth': nonBrandGrowth,
        'nonBrandForecast': nonBrandForecast,
        'totalGrowth': totalGrowth,
        'totalForecast': totalForecast,
        'optimisticForecast': optimisticForecast,
        'pessimisticForecast': pessimisticForecast,
      };

  static ForecastResult fromJson(Map<String, dynamic> json) => ForecastResult(
        month: DateTime.parse(json['month'] as String),
        brandForecast: (json['brandForecast'] as num).toDouble(),
        nonBrandWithoutSeo: (json['nonBrandWithoutSeo'] as num).toDouble(),
        totalWithoutSeo: (json['totalWithoutSeo'] as num).toDouble(),
        nonBrandGrowth: (json['nonBrandGrowth'] as num).toDouble(),
        nonBrandForecast: (json['nonBrandForecast'] as num).toDouble(),
        totalGrowth: (json['totalGrowth'] as num).toDouble(),
        totalForecast: (json['totalForecast'] as num).toDouble(),
        optimisticForecast: (json['optimisticForecast'] as num).toDouble(),
        pessimisticForecast: (json['pessimisticForecast'] as num).toDouble(),
      );
}

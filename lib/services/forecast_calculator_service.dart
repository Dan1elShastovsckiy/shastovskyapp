// lib/services/forecast_calculator_service.dart

import 'dart:math';

import 'package:minimal/models/monthly_data.dart';

class RegressionResult {
  final double slope;
  final double intercept;

  RegressionResult(this.slope, this.intercept);

  double predict(double x) {
    return slope * x + intercept;
  }
}

class SeoForecastCalculator {
  final List<MonthlyData> historicalData;
  final ForecastSettings settings;
  final List<ManualSeasonalityPoint> manualSeasonalityData;

  SeoForecastCalculator(this.historicalData, this.settings,
      {this.manualSeasonalityData = const []});

  RegressionResult _calculateLinearRegression(List<double> yValues) {
    if (yValues.length < 2) {
      return RegressionResult(0, yValues.isNotEmpty ? yValues.first : 0);
    }
    final xValues = List<double>.generate(yValues.length, (i) => i.toDouble());
    final n = yValues.length;

    final sumX = xValues.reduce((a, b) => a + b);
    final sumY = yValues.reduce((a, b) => a + b);
    final sumXY = List<double>.generate(n, (i) => xValues[i] * yValues[i])
        .reduce((a, b) => a + b);
    final sumX2 = xValues.map((x) => x * x).reduce((a, b) => a + b);

    final denominator = (n * sumX2 - sumX * sumX);
    if (denominator == 0) return RegressionResult(0, sumY / n);

    final slope = (n * sumXY - sumX * sumY) / denominator;
    final intercept = (sumY - slope * sumX) / n;

    return RegressionResult(slope, intercept);
  }

  void _prepareBaseData(List<MonthlyData> data) {
    if (data.isEmpty) return;

    final lastYearData =
        data.length > 12 ? data.sublist(data.length - 12) : data;
    double totalYandex = 0;
    double totalYandexBrand = 0;
    for (var d in lastYearData) {
      if (d.yandexVisits > 0) {
        totalYandex += d.yandexVisits;
        totalYandexBrand += d.yandexBrandVisits;
      }
    }
    final avgBrandShare =
        (totalYandex > 0) ? totalYandexBrand / totalYandex : 0.0;

    for (var d in data) {
      d.yandexShare = (d.yandexVisits + d.googleVisits > 0)
          ? d.yandexVisits / (d.yandexVisits + d.googleVisits)
          : 0.5;
      d.brandShare = avgBrandShare;
    }
  }

  void _calculateTrend(List<MonthlyData> data) {
    if (data.length < 2) return;

    final brandValues = data.map((d) => d.brandTraffic).toList();
    final nonBrandValues = data.map((d) => d.nonBrandTraffic).toList();

    if (settings.trendType == TrendType.linear) {
      var brandRegression = _calculateLinearRegression(brandValues);
      var nonBrandRegression = _calculateLinearRegression(nonBrandValues);

      if (brandRegression.slope < 0) {
        brandRegression = RegressionResult(
            0,
            brandValues.isNotEmpty
                ? brandValues.reduce((a, b) => a + b) / brandValues.length
                : 0);
      }
      if (nonBrandRegression.slope < 0) {
        nonBrandRegression = RegressionResult(
            0,
            nonBrandValues.isNotEmpty
                ? nonBrandValues.reduce((a, b) => a + b) / nonBrandValues.length
                : 0);
      }

      for (int i = 0; i < data.length; i++) {
        data[i].brandTrend = brandRegression.predict(i.toDouble());
        data[i].nonBrandTrend = nonBrandRegression.predict(i.toDouble());
      }
    } else {
      _applyHoltSmoothing(
          data, (d) => d.brandTraffic, (d, v) => d.brandTrend = v);
      _applyHoltSmoothing(
          data, (d) => d.nonBrandTraffic, (d, v) => d.nonBrandTrend = v);
    }
  }

  void _applyHoltSmoothing(
      List<MonthlyData> data,
      double Function(MonthlyData) getValue,
      void Function(MonthlyData, double) setValue,
      {double alpha = 0.4,
      double beta = 0.2}) {
    if (data.length < 2) return;
    double level = getValue(data[0]);
    double trend = getValue(data[1]) - getValue(data[0]);
    for (int i = 0; i < data.length; i++) {
      setValue(data[i], max(0, level + trend).toDouble());
      double lastLevel = level;
      level = alpha * getValue(data[i]) + (1 - alpha) * (lastLevel + trend);
      trend = beta * (level - lastLevel) + (1 - beta) * trend;
    }
  }

  void _calculateSeasonality(List<MonthlyData> data) {
    if (data.isEmpty) return;
    for (var d in data) {
      if (d.brandTrend > 0) {
        d.brandSeasonality = d.brandTraffic / d.brandTrend;
      }
      if (d.nonBrandTrend > 0) {
        d.nonBrandSeasonality = d.nonBrandTraffic / d.nonBrandTrend;
      }
    }
  }

  Map<int, double> _getAverageSeasonality(
      List<MonthlyData> data, double Function(MonthlyData) getSeasonality) {
    final Map<int, List<double>> monthlySeasonality = {};
    for (var d in data) {
      if (!monthlySeasonality.containsKey(d.month.month)) {
        monthlySeasonality[d.month.month] = [];
      }
      monthlySeasonality[d.month.month]!.add(getSeasonality(d));
    }
    return monthlySeasonality.map((month, values) => MapEntry(month,
        values.isEmpty ? 1.0 : values.reduce((a, b) => a + b) / values.length));
  }

  Map<int, double> _getManualSeasonality() {
    if (manualSeasonalityData.isEmpty) return {};

    final Map<int, List<double>> monthlyValues = {};
    double totalSum = 0;
    int count = 0;

    for (var point in manualSeasonalityData) {
      if (point.queryCount > 0) {
        totalSum += point.queryCount;
        count++;
        if (!monthlyValues.containsKey(point.month.month)) {
          monthlyValues[point.month.month] = [];
        }
        monthlyValues[point.month.month]!.add(point.queryCount);
      }
    }

    if (count == 0) return {};

    final Map<int, double> monthlyAverages = monthlyValues.map((month, values) {
      return MapEntry(month, values.reduce((a, b) => a + b) / values.length);
    });

    final overallAverage = totalSum / count;
    if (overallAverage == 0) return {};

    return monthlyAverages
        .map((month, avg) => MapEntry(month, avg / overallAverage));
  }

  Map<String, dynamic> runForecast() {
    final totalData =
        List<MonthlyData>.from(historicalData.map((d) => MonthlyData.clone(d)));
    final yandexData =
        List<MonthlyData>.from(historicalData.map((d) => MonthlyData.clone(d)));
    final googleData =
        List<MonthlyData>.from(historicalData.map((d) => MonthlyData.clone(d)));

    _prepareBaseData(totalData);
    _prepareBaseData(yandexData);
    _prepareBaseData(googleData);

    for (var d in totalData) {
      d.totalVisits = d.yandexVisits + d.googleVisits;
      d.brandTraffic = d.totalVisits * d.brandShare;
      d.nonBrandTraffic = d.totalVisits * (1 - d.brandShare);
    }
    for (var d in yandexData) {
      d.totalVisits = d.yandexVisits;
      d.brandTraffic = d.totalVisits * d.brandShare;
      d.nonBrandTraffic = d.totalVisits * (1 - d.brandShare);
    }
    for (var d in googleData) {
      d.totalVisits = d.googleVisits;
      d.brandTraffic = 0;
      d.nonBrandTraffic = d.totalVisits;
    }

    final totalResult = _generateSingleForecast(12, totalData);
    final yandexResult = _generateSingleForecast(12, yandexData);
    final googleResult = _generateSingleForecast(12, googleData);

    return {
      'total': totalResult['forecast'],
      'yandex': yandexResult['forecast'],
      'google': googleResult['forecast'],
      'seasonality': totalResult['seasonality'],
    };
  }

  Map<String, dynamic> _generateSingleForecast(
      int months, List<MonthlyData> data) {
    if (data.length < 2) {
      return {'forecast': [], 'seasonality': {}};
    }

    _calculateTrend(data);
    _calculateSeasonality(data);

    Map<int, double> finalBrandSeasonality;
    Map<int, double> finalNonBrandSeasonality;

    if (settings.seasonalitySource == SeasonalitySource.manual &&
        manualSeasonalityData.isNotEmpty) {
      final manualSeasonality = _getManualSeasonality();
      finalBrandSeasonality = manualSeasonality;
      finalNonBrandSeasonality = manualSeasonality;
    } else {
      finalBrandSeasonality =
          _getAverageSeasonality(data, (d) => d.brandSeasonality);
      finalNonBrandSeasonality =
          _getAverageSeasonality(data, (d) => d.nonBrandSeasonality);
    }

    final lastData = data.last;

    final brandRegression =
        _calculateLinearRegression(data.map((d) => d.brandTraffic).toList());
    final nonBrandRegression =
        _calculateLinearRegression(data.map((d) => d.nonBrandTraffic).toList());

    final brandSlope = max(0, brandRegression.slope).toDouble();
    final nonBrandSlope = max(0, nonBrandRegression.slope).toDouble();

    final lastBrandIntercept =
        brandRegression.predict((data.length - 1).toDouble());
    final lastNonBrandIntercept =
        nonBrandRegression.predict((data.length - 1).toDouble());

    final residuals =
        data.map((d) => d.nonBrandTraffic - d.nonBrandTrend).toList();
    final stdDev = residuals.length > 1
        ? sqrt(residuals.map((r) => r * r).reduce((a, b) => a + b) /
            (residuals.length - 1))
        : 0;

    List<ForecastResult> forecast = [];
    for (int i = 1; i <= months; i++) {
      final forecastMonth =
          DateTime(lastData.month.year, lastData.month.month + i, 1);

      double nextBrandTrend, nextNonBrandTrend;
      if (settings.trendType == TrendType.linear) {
        nextBrandTrend = lastBrandIntercept + brandSlope * i;
        nextNonBrandTrend = lastNonBrandIntercept + nonBrandSlope * i;
      } else {
        final brandTrendStep =
            (data.length > 1 && data[data.length - 2].brandTrend > 0
                ? lastData.brandTrend / data[data.length - 2].brandTrend
                : 1.0);
        final nonBrandTrendStep =
            (data.length > 1 && data[data.length - 2].nonBrandTrend > 0
                ? lastData.nonBrandTrend / data[data.length - 2].nonBrandTrend
                : 1.0);
        nextBrandTrend =
            lastData.brandTrend * pow(brandTrendStep, i).toDouble();
        nextNonBrandTrend =
            lastData.nonBrandTrend * pow(nonBrandTrendStep, i).toDouble();
      }

      final brandSeasonality =
          finalBrandSeasonality[forecastMonth.month] ?? 1.0;
      final nonBrandSeasonality =
          finalNonBrandSeasonality[forecastMonth.month] ?? 1.0;

      final brandForecast = max(0, nextBrandTrend * brandSeasonality);
      final nonBrandWithoutSeo =
          max(0, nextNonBrandTrend * nonBrandSeasonality);

      final seoFactor = (i <= settings.seoGrowthFactors.length)
          ? settings.seoGrowthFactors[i - 1]
          : settings.seoGrowthFactors.last;

      final nonBrandForecast = nonBrandWithoutSeo * seoFactor;
      final totalForecast = brandForecast + nonBrandWithoutSeo;

      final marginOfError = 1.96 * stdDev * sqrt(i);
      final optimistic = totalForecast + marginOfError;
      final pessimistic = max(0, totalForecast - marginOfError).toDouble();

      forecast.add(ForecastResult(
        month: forecastMonth,
        brandForecast: brandForecast.toDouble(),
        nonBrandWithoutSeo: nonBrandWithoutSeo.toDouble(),
        totalWithoutSeo: (brandForecast + nonBrandWithoutSeo).toDouble(),
        nonBrandGrowth: (nonBrandForecast - nonBrandWithoutSeo).toDouble(),
        nonBrandForecast: nonBrandForecast.toDouble(),
        totalGrowth: (nonBrandForecast - nonBrandWithoutSeo).toDouble(),
        totalForecast: (brandForecast + nonBrandForecast).toDouble(),
        optimisticForecast: optimistic.toDouble(),
        pessimisticForecast: pessimistic.toDouble(),
      ));
    }
    return {
      'forecast': forecast,
      'seasonality': finalNonBrandSeasonality,
    };
  }
}

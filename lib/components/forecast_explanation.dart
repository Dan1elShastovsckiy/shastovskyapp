// lib/components/forecast_explanation.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:minimal/components/components.dart';

class ForecastExplanation extends StatelessWidget {
  const ForecastExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Инструмент использует методы временных рядов для построения прогноза, разделяя исторические данные на три компонента: тренд, сезонность и случайные колебания.",
        ),
        SizedBox(height: 24),
        _ExplanationTile(
          icon: Icons.timeline,
          title: "Шаг 1: Построение Тренда",
          content:
              "Тренд — это общее направление движения трафика (растет, падает или стагнирует).\n\n"
              "• **Линейный тренд:** Строит прямую линию через ваши исторические данные (метод наименьших квадратов). Если тренд оказывается отрицательным, он принудительно заменяется на горизонтальную линию (стабилизацию), чтобы избежать нереалистичных прогнозов падения в ноль.\n\n"
              "• **Экспоненциальное сглаживание:** Более сложный метод (двойное сглаживание Хольта), который придает больший вес недавним данным. Он лучше улавливает ускорение или замедление роста.",
        ),
        SizedBox(height: 16),
        _ExplanationTile(
          icon: Icons.wb_sunny_outlined,
          title: "Шаг 2: Расчет Сезонности",
          content:
              "Сезонность — это регулярные, предсказуемые колебания спроса в течение года.\n\n"
              "• **Автоматический расчет:** Алгоритм делит фактический трафик каждого месяца на значение тренда для этого же месяца. `Коэффициент = Факт / Тренд`. Затем он усредняет эти коэффициенты для каждого месяца (всех январей, всех февралей и т.д.), чтобы получить стабильную модель сезонности.\n\n"
              "• **Ручной режим (Wordstat/Вебмастер):** Вы вводите данные о 'числе запросов' для ключевых фраз. Алгоритм рассчитывает среднее значение для каждого месяца и делит его на общее среднее за весь период. `Коэф. = Среднее_за_месяц / Общее_среднее`. Этот метод позволяет использовать 'чистую' рыночную сезонность, игнорируя просадки трафика на вашем сайте.",
        ),
        SizedBox(height: 16),
        _ExplanationTile(
          icon: Icons.trending_up,
          title: "Шаг 3: Построение Прогноза",
          content: "Финальный прогноз собирается как конструктор:\n\n"
              "1.  **Базовый прогноз:** Алгоритм экстраполирует (продлевает в будущее) линию тренда, рассчитанную на Шаге 1.\n"
              "2.  **Учет сезонности:** Базовый прогноз каждого месяца умножается на его коэффициент сезонности. `Прогноз_без_SEO = Базовый_прогноз * Коэф_сезонности`.\n"
              "3.  **Влияние SEO:** К небрендовой части прогноза добавляется процент роста, который вы задали в настройках. `Итоговый_прогноз = Бренд + (Небренд_без_SEO * (1 + %_роста_SEO))`.",
        ),
        SizedBox(height: 16),
        _ExplanationTile(
          icon: Icons.architecture,
          title: "Доверительные интервалы (Оптимистичный/Пессимистичный)",
          content:
              "Ни один прогноз не может быть точным на 100%. Поэтому инструмент рассчитывает 'стандартное отклонение' — среднюю ошибку исторического тренда. На основе этой ошибки строится 'коридор':\n\n"
              "• **Оптимистичный прогноз:** `Реалистичный + Погрешность`\n"
              "• **Пессимистичный прогноз:** `Реалистичный - Погрешность`\n\n"
              "Этот коридор показывает наиболее вероятный диапазон, в котором окажется ваш реальный трафик.",
        ),
      ],
    );
  }
}

class _ExplanationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _ExplanationTile(
      {required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Получаем тему
    return ExpansionTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title,
          style: headlineSecondaryTextStyle(context).copyWith(fontSize: 18)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              16.0, 8.0, 16.0, 16.0), // Увеличим отступ снизу
          // <<< ИСПРАВЛЕНИЕ: Используем MarkdownBody >>>
          child: MarkdownBody(
            data: content,
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
              p: bodyTextStyle(context),
            ),
          ),
        ),
      ],
    );
  }
}

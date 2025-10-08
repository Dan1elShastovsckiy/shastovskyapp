// /lib/pages/pages_useful/page_seo_analyzer.dart

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:http/http.dart' as http;
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/pages/pages.dart';
import 'dart:async';
import 'package:snowball_stemmer/snowball_stemmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;
// ИСПРАВЛЕНИЕ: убрали 'hide Text', так как оно больше не нужно
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:html2md/html2md.dart' as html2md;
// ИСПРАВЛЕНИЕ: Этот импорт теперь не используется напрямую, но его наличие в pubspec.yaml
// дает доступ к методу-расширению Document.fromHtml()
// import 'package:quill_html_converter/quill_html_converter.dart';

// --- МОДЕЛИ ДАННЫХ ---

class KeywordRequirement {
  final String phrase;
  final int min;
  final int max;
  KeywordRequirement(this.phrase, this.min, this.max);
}

class AnalysisPayload {
  final List<dynamic> quillDelta;
  final TzData tzData;
  final SearchMode searchMode;

  AnalysisPayload({
    required this.quillDelta,
    required this.tzData,
    required this.searchMode,
  });
}

class GeneralRequirementResult {
  final String name;
  final String requirement;
  final String actual;
  final bool isSuccess;
  GeneralRequirementResult(
      this.name, this.requirement, this.actual, this.isSuccess);
}

class TzData {
  String volume;
  String metaTitle;
  String metaDescription;
  String structure;
  String exactKeywords;
  String dilutedKeywords;
  String thematicWords;
  String generalRequirements;

  TzData({
    required this.volume,
    required this.metaTitle,
    required this.metaDescription,
    required this.structure,
    required this.exactKeywords,
    required this.dilutedKeywords,
    required this.thematicWords,
    required this.generalRequirements,
  });
}

class AnalysisResult {
  final List<GeneralRequirementResult> generalResults;
  final String volumeResult;
  final String titleResult;
  final String descriptionResult;
  final String structureResult;
  final List<YandexSpellerError> spellingErrors;
  final AnalysisCategoryResult exactInclusion;
  final AnalysisCategoryResult dilutedInclusion;
  final AnalysisCategoryResult thematicWords;
  final List<TextSpan> highlightedText;

  AnalysisResult({
    required this.generalResults,
    required this.volumeResult,
    required this.titleResult,
    required this.descriptionResult,
    required this.structureResult,
    required this.spellingErrors,
    required this.exactInclusion,
    required this.dilutedInclusion,
    required this.thematicWords,
    required this.highlightedText,
  });
}

class AnalysisCategoryResult {
  final List<MapEntry<KeywordRequirement, int>> results;
  int notFound = 0, moreThanNeeded = 0, lessThanNeeded = 0, perfectMatch = 0;
  AnalysisCategoryResult(this.results) {
    for (var entry in results) {
      final req = entry.key;
      final count = entry.value;
      if (count == 0)
        notFound++;
      else if (count < req.min)
        lessThanNeeded++;
      else if (count > req.max)
        moreThanNeeded++;
      else
        perfectMatch++;
    }
  }
}

class YandexSpellerError {
  final String word;
  final int pos;
  final int len;
  final List<String> suggestions;
  YandexSpellerError(this.word, this.pos, this.len, this.suggestions);
}

class TextTzPair {
  final QuillController textController = QuillController.basic();
  final TextEditingController tzController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController structureController = TextEditingController();
  final TextEditingController exactKeywordsController = TextEditingController();
  final TextEditingController dilutedKeywordsController =
      TextEditingController();
  final TextEditingController thematicWordsController = TextEditingController();
  final GlobalKey key = GlobalKey();
  TzData? parsedTz;
  AnalysisResult? analysisResult;
}

enum SearchMode {
  overlapping,
  singlePass,
  uniquePass,
}

// <<< НАЧАЛО: ВСЯ ЛОГИКА АНАЛИЗА, ВЫНЕСЕННАЯ ДЛЯ РАБОТЫ В ИЗОЛЯТЕ >>>

Future<Map<String, dynamic>> runAnalysisInIsolate(
    AnalysisPayload payload) async {
  final doc = Document.fromJson(payload.quillDelta);
  final plainTextFromDelta = doc.toPlainText();
  final converter =
      QuillDeltaToHtmlConverter(List.castFrom(payload.quillDelta));
  final html = converter.convert();
  final markdownTextFromDelta = html2md.convert(html);

  final stemmer = SnowballStemmer(Algorithm.russian);

  String normalizeEyo(String text) => text.replaceAll('ё', 'е');

  String stemText(String text) {
    final words = text.split(RegExp(r"(\s+|[.,!?—:;()" "'\-])"));
    final stemmedWords = words.map((word) {
      if (word.trim().isEmpty) return word;
      return stemmer.stem(word.toLowerCase());
    });
    return stemmedWords.join('');
  }

  bool isWordBoundary(String text, int index) {
    if (index < 0 || index > text.length) return false;
    if (index == 0 || index == text.length) return true;
    final prevChar = text[index - 1];
    final nextChar = text[index];
    final boundaryChars = RegExp(r'[\s.,!?;:()\[\]"' '’]');
    return boundaryChars.hasMatch(prevChar) || boundaryChars.hasMatch(nextChar);
  }

  List<KeywordRequirement> parseKeywordsFromText(String text) {
    if (text.toLowerCase() == "не найдено" || text.isEmpty) return [];
    List<KeywordRequirement> keywords = [];
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    final header1 = 'Ключевое слово'.toLowerCase();
    final header2 = 'Количество упоминаний в тексте(раз(а))'.toLowerCase();
    final contentLines = lines.where((line) {
      final trimmedLower = line.trim().toLowerCase();
      return trimmedLower.isNotEmpty &&
          trimmedLower != header1 &&
          trimmedLower != header2;
    }).toList();
    final countOnNextLineRegex = RegExp(r'^\((\d+)\)$');
    final rangeRegex = RegExp(r'(.+?)\s*\((\d+)(?:-(\d+))?\)\s*$');
    final tableRegex = RegExp(r'^(.*?)\s+\d+\s+раз\(?а?\)');

    for (int i = 0; i < contentLines.length; i++) {
      final currentLine = contentLines[i].trim();
      if (i + 1 < contentLines.length) {
        final nextLine = contentLines[i + 1].trim();
        final match = countOnNextLineRegex.firstMatch(nextLine);
        if (match != null) {
          final phrase = currentLine.replaceAll(RegExp(r'[\.,;]$'), '');
          final count = int.parse(match.group(1)!);
          keywords.add(KeywordRequirement(phrase, count, count));
          i++;
          continue;
        }
      }
      final rangeMatch = rangeRegex.firstMatch(currentLine);
      if (rangeMatch != null) {
        final phrase =
            rangeMatch.group(1)!.trim().replaceAll(RegExp(r'[\.,;]$'), '');
        final min = int.parse(rangeMatch.group(2)!);
        final max =
            rangeMatch.group(3) != null ? int.parse(rangeMatch.group(3)!) : min;
        keywords.add(KeywordRequirement(phrase, min, max));
        continue;
      }
      final tableMatch = tableRegex.firstMatch(currentLine);
      if (tableMatch != null) {
        final phrase =
            tableMatch.group(1)!.trim().replaceAll(RegExp(r'[\.,;]$'), '');
        final countString = RegExp(r'(\d+)').firstMatch(currentLine)!.group(1)!;
        final count = int.parse(countString);
        keywords.add(KeywordRequirement(phrase, count, count));
        continue;
      }
      if (currentLine.isNotEmpty) {
        keywords.add(KeywordRequirement(
            currentLine.replaceAll(RegExp(r'[\.,;]$'), ''), 1, 999));
      }
    }
    return keywords;
  }

  int countOccurrences(
      String text, String phrase, bool exact, List<List<int>> consumedRanges) {
    if (phrase.isEmpty) return 0;
    int count = 0;
    final lowerText = text.toLowerCase();
    final lowerPhrase = phrase.toLowerCase();
    for (final match in lowerPhrase.allMatches(lowerText)) {
      bool isOverlapping = false;
      for (final range in consumedRanges) {
        if (match.start < range[1] && match.end > range[0]) {
          isOverlapping = true;
          break;
        }
      }
      if (isOverlapping) continue;
      if (exact) {
        bool isStartBoundary =
            (match.start == 0) || isWordBoundary(lowerText, match.start);
        bool isEndBoundary = (match.end == lowerText.length) ||
            isWordBoundary(lowerText, match.end);
        if (isStartBoundary && isEndBoundary) {
          count++;
        }
      } else {
        count++;
      }
    }
    return count;
  }

  List<MapEntry<KeywordRequirement, int>> analyzeKeywords(
    String text,
    List<KeywordRequirement> requirements,
    String type,
    SearchMode mode,
    List<List<int>> globalConsumedRanges,
  ) {
    final String textToAnalyze = (type == 'exact') ? text : stemText(text);
    List<MapEntry<KeywordRequirement, int>> results = [];
    const stopWords = {
      'и',
      'в',
      'на',
      'с',
      'к',
      'по',
      'о',
      'у',
      'за',
      'из',
      'для',
      'от',
      'до',
      'без',
      'через'
    };
    List<List<int>> localConsumedRanges = [];
    final activeRanges = (mode == SearchMode.uniquePass)
        ? globalConsumedRanges
        : localConsumedRanges;

    if (mode != SearchMode.overlapping) {
      requirements.sort((a, b) => b.phrase.length.compareTo(a.phrase.length));
    }

    for (var req in requirements) {
      int count = 0;
      final String phraseToSearch =
          (type == 'exact') ? req.phrase : stemText(req.phrase);
      final lowerText = textToAnalyze.toLowerCase();
      final lowerPhrase = phraseToSearch.toLowerCase();
      final bool useWordBoundaryCheck = (type == 'exact');

      if (mode == SearchMode.overlapping) {
        if (type == 'exact' || type == 'thematic') {
          count = countOccurrences(
              textToAnalyze, phraseToSearch, useWordBoundaryCheck, []);
        } else if (type == 'diluted') {
          final significantWords = phraseToSearch
              .split(' ')
              .where(
                  (w) => w.isNotEmpty && !stopWords.contains(w.toLowerCase()))
              .toList();
          if (significantWords.isEmpty) {
            results.add(MapEntry(req, 0));
            continue;
          }
          final sentences = text.split(RegExp(r'[.!?\n]'));
          for (var sentence in sentences) {
            final stemmedSentence = stemText(sentence);
            if (significantWords.every((word) =>
                countOccurrences(stemmedSentence, word, false, []) > 0)) {
              count++;
            }
          }
        }
      } else {
        if (type == 'exact' || type == 'thematic') {
          for (final match
              in RegExp(RegExp.escape(lowerPhrase)).allMatches(lowerText)) {
            bool isOverlapping = activeRanges
                .any((range) => match.start < range[1] && match.end > range[0]);
            if (isOverlapping) continue;
            if (useWordBoundaryCheck) {
              bool isStartBoundary =
                  (match.start == 0) || isWordBoundary(lowerText, match.start);
              bool isEndBoundary = (match.end == lowerText.length) ||
                  isWordBoundary(lowerText, match.end);
              if (!isStartBoundary || !isEndBoundary) continue;
            }
            count++;
            activeRanges.add([match.start, match.end]);
          }
        } else if (type == 'diluted') {
          final significantWords = lowerPhrase
              .split(' ')
              .where((w) => w.isNotEmpty && !stopWords.contains(w))
              .toList();
          if (significantWords.isEmpty) {
            results.add(MapEntry(req, 0));
            continue;
          }
          final sentences = text.split(RegExp(r'[.!?\n]'));
          int sentenceOffset = 0;
          for (var sentence in sentences) {
            final stemmedSentence = stemText(sentence).toLowerCase();
            bool sentenceOverlaps = activeRanges.any((range) =>
                sentenceOffset < range[1] &&
                (sentenceOffset + sentence.length) > range[0]);
            if (sentenceOverlaps) {
              sentenceOffset += sentence.length + 1;
              continue;
            }
            bool allWordsFound = significantWords.every((word) =>
                countOccurrences(stemmedSentence, word, false, []) > 0);
            if (allWordsFound) {
              count++;
              activeRanges
                  .add([sentenceOffset, sentenceOffset + sentence.length]);
            }
            sentenceOffset += sentence.length + 1;
          }
        }
      }
      results.add(MapEntry(req, count));
    }
    return results;
  }

  List<GeneralRequirementResult> analyzeGeneralRequirements(
      String text, String requirementText) {
    List<GeneralRequirementResult> results = [];
    final services = ['Уникальность', 'Главред', 'Тургенев', 'Спам', 'Вода'];
    for (var service in services) {
      final reqRegex =
          RegExp(service + r'.*?(\d+[\.,]?\d*)', caseSensitive: false);
      final actRegex = RegExp(service + r'[:\-—\s]*(\d+[\.,]?\d*)[/\d\s,]*%',
          caseSensitive: false);
      final reqMatch = reqRegex.firstMatch(requirementText);
      final actMatch = actRegex.firstMatch(text);
      final reqValue =
          double.tryParse(reqMatch?.group(1)?.replaceAll(',', '.') ?? '');
      final actValue =
          double.tryParse(actMatch?.group(1)?.replaceAll(',', '.') ?? '');
      if (reqValue != null) {
        bool success = false;
        String actualString = actMatch?.group(1) ?? 'Не найдено';
        if (actValue != null) {
          if (service == 'Уникальность' || service == 'Главред') {
            success = actValue >= reqValue;
          } else {
            success = actValue <= reqValue;
          }
        }
        String reqString = (service == 'Уникальность' || service == 'Главред')
            ? '≥ $reqValue'
            : '≤ $reqValue';
        results.add(GeneralRequirementResult(
            service, reqString, actualString, success));
      }
    }
    final firstParagraph =
        text.split('\n\n').first.replaceAll(RegExp(r'#+\s*'), '');
    results.add(GeneralRequirementResult('Первый абзац', '≤ 500 симв.',
        '${firstParagraph.length}', firstParagraph.length <= 500));
    final hasList = text.contains(RegExp(r'^\s*[*-]|\d+\.', multiLine: true));
    results.add(GeneralRequirementResult(
        'Списки', 'Хотя бы 1', hasList ? 'Есть' : 'Нет', hasList));
    final h2Count =
        RegExp(r'(^##\s+.+)|(^.+\n-+$)', multiLine: true, caseSensitive: false)
            .allMatches(text)
            .length;
    results.add(GeneralRequirementResult('Подзаголовки H2', 'Есть',
        h2Count > 0 ? 'Найдено: $h2Count' : 'Нет', h2Count > 0));
    return results;
  }

  String analyzeVolume(String text, String requirement) {
    final currentVolume = text.replaceAll(' ', '').length;
    final regex = RegExp(r'(\d+)');
    final matches = regex.allMatches(requirement).toList();
    if (matches.isEmpty) {
      return 'Текущий объем: $currentVolume симв. Требование в ТЗ не найдено.';
    }
    final minVolume = int.parse(matches[0].group(1)!);
    final maxVolume = matches.length > 1
        ? int.parse(matches[1].group(1)!)
        : minVolume + (minVolume * 0.2).round();
    if (currentVolume >= minVolume && currentVolume <= maxVolume) {
      return '✅ Объем соответствует: $currentVolume из $minVolume-$maxVolume симв. (без пробелов)';
    } else if (currentVolume < minVolume) {
      return '❌ Объем не соответствует: $currentVolume из $minVolume-$maxVolume симв. (нужно еще ${minVolume - currentVolume})';
    } else {
      return '❌ Объем не соответствует: $currentVolume из $minVolume-$maxVolume симв. (превышение на ${currentVolume - maxVolume})';
    }
  }

  String analyzeMetaTag(String text, String requirement, String tagName) {
    if (requirement.toLowerCase() == "не найдено" || requirement.isEmpty) {
      return 'Требование для $tagName не найдено в ТЗ.';
    }
    if (text.toLowerCase().contains(requirement.toLowerCase().trim())) {
      return '✅ $tagName найден в тексте.';
    } else {
      return '❌ $tagName не найден в тексте.';
    }
  }

  String analyzeStructure(String text, String requirement) {
    if (requirement.toLowerCase() == "не найдено" || requirement.isEmpty) {
      return 'Требование по структуре не найдено в ТЗ.';
    }
    final List<String> requiredThemes = requirement
        .split('\n')
        .map((line) => line.trim())
        .where((line) =>
            line.isNotEmpty &&
            line.length > 10 &&
            !line.toLowerCase().startsWith('что писать') &&
            !line.toLowerCase().startsWith('формат'))
        .toList();
    if (requiredThemes.isEmpty) {
      return '⚠️ В ТЗ не найдено тем для проверки структуры.';
    }
    final h2Pattern = RegExp(r'(^##\s+(.+)$)|(^(.+)\n-+$)', multiLine: true);
    final List<String> articleHeadings =
        h2Pattern.allMatches(text).map((match) {
      return (match.group(2) ?? match.group(4) ?? '').trim();
    }).toList();
    if (articleHeadings.isEmpty) {
      return '⚠️ В тексте не найдено ни одного H2 заголовка в формате Markdown (## Заголовок).';
    }
    int foundCount = 0;
    List<String> notFoundThemes = [];
    for (var theme in requiredThemes) {
      bool themeFound = false;
      final themeKeywords = normalizeEyo(theme.toLowerCase())
          .replaceAll(RegExp(r'[,.()?]'), '')
          .split(' ')
          .where((word) => word.length > 3)
          .toSet();
      if (themeKeywords.isEmpty) continue;
      for (var heading in articleHeadings) {
        final normalizedHeading = normalizeEyo(heading.toLowerCase());
        if (themeKeywords
            .every((keyword) => normalizedHeading.contains(keyword))) {
          themeFound = true;
          break;
        }
      }
      if (themeFound) {
        foundCount++;
      } else {
        notFoundThemes.add(theme);
      }
    }
    final isOk = foundCount >= requiredThemes.length;
    String result =
        '${isOk ? '✅' : '⚠️'} Найдено соответствие для $foundCount из ${requiredThemes.length} тем структуры.';
    if (notFoundThemes.isNotEmpty) {
      result +=
          '\nТемы без соответствия в заголовках: ${notFoundThemes.join("; ")}';
    }
    return result;
  }

  // --- Основной процесс анализа в изоляте ---
  final markdownText = normalizeEyo(markdownTextFromDelta);
  final plainText = normalizeEyo(plainTextFromDelta);
  final tzData = payload.tzData;

  final generalResults =
      analyzeGeneralRequirements(markdownText, tzData.generalRequirements);
  final volumeResult = analyzeVolume(plainText, tzData.volume);
  final titleResult = analyzeMetaTag(plainText, tzData.metaTitle, "Title");
  final descriptionResult =
      analyzeMetaTag(plainText, tzData.metaDescription, "Description");
  final structureResult = analyzeStructure(markdownText, tzData.structure);

  final exactReqs = parseKeywordsFromText(tzData.exactKeywords);
  final dilutedReqs = parseKeywordsFromText(tzData.dilutedKeywords);
  final thematicReqs = parseKeywordsFromText(tzData.thematicWords);

  List<List<int>> globalConsumedRanges = [];

  final exactResult = analyzeKeywords(markdownText, exactReqs, 'exact',
      payload.searchMode, globalConsumedRanges);
  final dilutedResult = analyzeKeywords(markdownText, dilutedReqs, 'diluted',
      payload.searchMode, globalConsumedRanges);
  final thematicResult = analyzeKeywords(markdownText, thematicReqs, 'thematic',
      payload.searchMode, globalConsumedRanges);

  return {
    'generalResults': generalResults,
    'volumeResult': volumeResult,
    'titleResult': titleResult,
    'descriptionResult': descriptionResult,
    'structureResult': structureResult,
    'exactInclusion': AnalysisCategoryResult(exactResult),
    'dilutedInclusion': AnalysisCategoryResult(dilutedResult),
    'thematicWords': AnalysisCategoryResult(thematicResult),
    'exactKeywords': exactReqs,
    'thematicKeywords': thematicReqs,
  };
}

// <<< КОНЕЦ БЛОКА ДЛЯ ИЗОЛЯТА >>>

class SeoAnalyzerPage extends StatefulWidget {
  static const String name = 'useful/instruments/seo-analyzer';
  const SeoAnalyzerPage({super.key});

  @override
  State<SeoAnalyzerPage> createState() => _SeoAnalyzerPageState();
}

class _SeoAnalyzerPageState extends State<SeoAnalyzerPage> {
  List<TextTzPair> _pairs = [TextTzPair()];
  bool _isLoading = false;
  SearchMode _selectedMode = SearchMode.overlapping;

  static const List<String> _allKnownMarkers = [
    'Объем текста',
    'Объем',
    'Title:',
    'Title',
    'Метатег Title',
    'Description:',
    'Description',
    'Метатег Description',
    'H1:',
    'H1',
    'Мета-теги',
    'Структура текста',
    'Примерная структура статьи',
    'Ключевые фразы',
    'Ключи, которые нужно использовать в тексте',
    'Ключи',
    'Слова из подсветки в выдаче',
    'Разбавленное вхождение',
    'Тематические слова использовать в любой форме',
    'Тематикозадающие слова / LSI',
    'LSI',
    'Тематические слова',
    'Общие требования к тексту',
    'Тема/H1',
    'Страница URL',
    'Частые вопросы (FAQ)',
    'Перелинковка',
    'Примеры конкурентов',
    'Примечание'
  ];

  final SnowballStemmer _stemmer = SnowballStemmer(Algorithm.russian);

  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title: "SEO Анализатор текста | Инструменты Даниила Шастовского",
      description:
          "Бесплатный онлайн-инструмент для проверки соответствия текста SEO-ТЗ. Анализ ключевых слов, LSI, объема и других параметров.",
    );
  }

  @override
  void dispose() {
    for (var pair in _pairs) {
      pair.textController.dispose();
      pair.tzController.dispose();
      pair.volumeController.dispose();
      pair.titleController.dispose();
      pair.descriptionController.dispose();
      pair.structureController.dispose();
      pair.exactKeywordsController.dispose();
      pair.dilutedKeywordsController.dispose();
      pair.thematicWordsController.dispose();
    }
    super.dispose();
  }

  void _addPair() {
    if (_pairs.length < 5) {
      setState(() {
        _pairs.add(TextTzPair());
      });
    }
  }

  void _removePair(int index) {
    if (_pairs.length > 1) {
      setState(() {
        _pairs.removeAt(index);
      });
    }
  }

  void _recognizeStructure(QuillController controller) {
    // Получаем текущий текст и разбиваем его на строки.
    // LineSplitter() надежнее, чем split('\n'), так как работает с разными типами переносов строк.
    final plainText = controller.document.toPlainText();
    final lines = const LineSplitter().convert(plainText);

    // Создаем новый, пустой Delta, который мы будем наполнять.
    final newDelta = Delta();

    for (final line in lines) {
      final trimmedLine = line.trim();

      // Если строка пустая, просто сохраняем перенос строки.
      if (trimmedLine.isEmpty) {
        newDelta.insert('\n');
        continue;
      }

      // --- Правило 1: Распознаем пункты списка ---
      // Если строка начинается с одного из маркеров...
      if (trimmedLine.startsWith('•') ||
          trimmedLine.startsWith('-') ||
          trimmedLine.startsWith('*')) {
        // Убираем маркер и пробел из начала строки
        final lineContent = trimmedLine.substring(1).trim();
        // Вставляем сам текст пункта
        newDelta.insert(lineContent);
        // А затем вставляем перенос строки с атрибутом "маркированный список".
        // Это стандартный способ форматирования блоков в Quill.
        newDelta.insert('\n', {'list': 'bullet'});
      }
      // --- Правило 2: Распознаем заголовки ---
      // Эвристика: строка относительно короткая и не заканчивается знаком препинания.
      else if (trimmedLine.length < 80 &&
          !'.?!,:;'.contains(trimmedLine.substring(trimmedLine.length - 1))) {
        newDelta.insert(trimmedLine);
        // Применяем стиль "Заголовок 2" к переносу строки.
        newDelta.insert('\n', {'header': 2});
      }
      // --- Правило 3: Все остальное считаем обычным параграфом ---
      else {
        // Просто вставляем строку с переносом без всяких атрибутов.
        newDelta.insert(trimmedLine + '\n');
      }
    }

    // ИСПРАВЛЕНИЕ: Используем правильный метод для полной замены содержимого редактора.
    controller.document = Document.fromDelta(newDelta);

    // Перемещаем курсор в конец, чтобы было удобно продолжать редактирование.
    controller.moveCursorToEnd();
  }

  Future<void> _runGlobalAnalysis() async {
    // 1. Немедленно показываем оверлей.
    setState(() => _isLoading = true);

    // 2. ВАЖНЫЙ ШАГ: Даем UI-потоку небольшую паузу (50 миллисекунд).
    // Этого времени достаточно, чтобы Flutter успел не только показать,
    // но и проиграть несколько кадров анимации лоадера.
    await Future.delayed(const Duration(milliseconds: 50));

    // 3. Теперь, когда анимация уже точно идет, запускаем сам анализ.
    // Мы вынесли его в отдельную асинхронную функцию для чистоты.
    _performAnalysis();
  }

// Новая вспомогательная функция, которая содержит всю логику
  Future<void> _performAnalysis() async {
    for (var pair in _pairs) {
      // Эта операция все еще может вызвать очень короткое "подрагивание"
      // на ОЧЕНЬ больших текстах, но оно будет минимальным, так как анимация уже запущена.
      final plainText = pair.textController.document.toPlainText();
      if (plainText.trim().isEmpty) {
        pair.analysisResult = null;
        continue;
      }

      final tzData = TzData(
        volume: pair.volumeController.text,
        metaTitle: pair.titleController.text,
        metaDescription: pair.descriptionController.text,
        structure: pair.structureController.text,
        exactKeywords: pair.exactKeywordsController.text,
        dilutedKeywords: pair.dilutedKeywordsController.text,
        thematicWords: pair.thematicWordsController.text,
        generalRequirements: _parseSection(
                pair.tzController.text, ['Общие требования к тексту']) ??
            "Не найдено",
      );

      final payload = AnalysisPayload(
        quillDelta: pair.textController.document.toDelta().toJson(),
        tzData: tzData,
        searchMode: _selectedMode,
      );

      final isolateFuture = compute(runAnalysisInIsolate, payload);
      final spellingFuture = _checkSpelling(plainText);

      final isolateResult = await isolateFuture;
      final spellingErrors = await spellingFuture;

      final List<TextSpan> highlightedText = _buildHighlightedText(
        plainText,
        isolateResult['exactKeywords'],
        isolateResult['thematicKeywords'],
      );

      pair.analysisResult = AnalysisResult(
        generalResults: isolateResult['generalResults'],
        volumeResult: isolateResult['volumeResult'],
        titleResult: isolateResult['titleResult'],
        descriptionResult: isolateResult['descriptionResult'],
        structureResult: isolateResult['structureResult'],
        exactInclusion: isolateResult['exactInclusion'],
        dilutedInclusion: isolateResult['dilutedInclusion'],
        thematicWords: isolateResult['thematicWords'],
        highlightedText: highlightedText,
        spellingErrors: spellingErrors,
      );
    }

    // Когда все анализы завершены, обновляем UI и выключаем лоадер
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /*/// "Очищает" HTML, скопированный из Google Docs, используя DOM-парсер
  /// для надежной замены специфичных стилей на стандартные семантические теги.
  String _sanitizeGoogleDocsHtml(String dirtyHtml) {
    // 1. Парсим грязный HTML в объектную модель документа (DOM)
    final document = html_parser.parse(dirtyHtml);

    // 2. Ищем все теги <p> и пытаемся понять, не являются ли они заголовком или пунктом списка
    final paragraphs = document.querySelectorAll('p');
    for (final p in paragraphs) {
      String innerText = p.text.trim();
      if (innerText.isEmpty) continue;

      // --- Логика для списков ---
      // Если текст параграфа начинается с маркера списка
      if (innerText.startsWith('•') ||
          innerText.startsWith('-') ||
          innerText.startsWith('*')) {
        // Создаем новый, чистый элемент <li>
        final newListItem = html_dom.Element.tag('li');
        // Убираем маркер и лишние пробелы из текста и кладем его внутрь <li>
        newListItem.innerHtml = innerText.substring(1).trim();
        // Заменяем старый <p> на новый <li> в дереве документа
        p.replaceWith(newListItem);
        continue; // Переходим к следующему параграфу
      }

      // --- Логика для заголовков (основана на размере шрифта) ---
      final span = p.querySelector('span');
      if (span != null && span.attributes['style'] != null) {
        final style = span.attributes['style']!;
        // Ищем размер шрифта в стилях
        final sizeMatch = RegExp(r'font-size:\s*(\d+)pt').firstMatch(style);
        if (sizeMatch != null) {
          final fontSize = int.parse(sizeMatch.group(1)!);
          String? headingTag;

          // Определяем тег заголовка по размеру шрифта (эти значения можно подстроить)
          if (fontSize >= 20)
            headingTag = 'h1';
          else if (fontSize >= 16)
            headingTag = 'h2';
          else if (fontSize >= 14) headingTag = 'h3';

          if (headingTag != null) {
            final newHeading = html_dom.Element.tag(headingTag);
            newHeading.innerHtml =
                p.innerHtml; // Сохраняем внутренний HTML (с жирным и т.д.)
            p.replaceWith(newHeading);
            continue;
          }
        }
      }
    }

    // 3. После обработки всех <p> оборачиваем группы <li> в <ul>
    // Это нужно делать после основного цикла, чтобы не нарушать итерацию
    String bodyHtml = document.body!.innerHtml;
    bodyHtml = bodyHtml.replaceAllMapped(
      RegExp(r'(<li>.*?</li>)+', dotAll: true),
      (match) => '<ul>${match.group(0)}</ul>',
    );

    debugPrint("--- ОЧИЩЕННЫЙ HTML ---\n$bodyHtml\n--------------------");
    return bodyHtml;
  }*/

  Future<void> _pasteHtml(QuillController controller) async {
    String? clipboardText;
    try {
      // Мы все еще используем try-catch на случай других платформенных ошибок
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      clipboardText = clipboardData?.text;
    } catch (e) {
      debugPrint("Не удалось прочитать буфер обмена: $e");
      return;
    }

    if (clipboardText == null || clipboardText.isEmpty) {
      return;
    }

    // Просто вставляем текст как есть
    final selection = controller.selection;
    controller.document.replace(
        selection.start, selection.end - selection.start, clipboardText);
  }

  String _normalizeEyo(String text) {
    return text.replaceAll('ё', 'е');
  }

  String _stemText(String text) {
    final words = text.split(RegExp(r"(\s+|[.,!?—:;()" "'\-])"));
    final stemmedWords = words.map((word) {
      if (word.trim().isEmpty) return word;
      return _stemmer.stem(word.toLowerCase());
    });
    return stemmedWords.join('');
  }

  bool _isWordBoundary(String text, int index) {
    if (index < 0 || index > text.length) return false;
    if (index == 0 || index == text.length) return true;
    final prevChar = text[index - 1];
    final nextChar = text[index];
    final boundaryChars = RegExp(r'[\s.,!?;:()\[\]"' '’]');
    return boundaryChars.hasMatch(prevChar) || boundaryChars.hasMatch(nextChar);
  }

  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Как пользоваться анализатором",
              style: headlineSecondaryTextStyle(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 200,
                    child: Image.asset('assets/images/i_have_no_idea.webp'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Этот инструмент создан для автоматизации проверки текстов на соответствие SEO-ТЗ.",
                  style: bodyTextStyle(context),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Этап 1: Вставка и форматирование",
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                MarkdownBody(
                  data:
                      "1.  **Вставьте текст статьи** в левое поле. Используйте новую **иконку вставки на панели инструментов**, чтобы вставить текст из Google Docs/Word с сохранением форматирования.\n"
                      "2.  **Используйте панель инструментов** над полем ввода, чтобы быстро разметить **заголовки (H1, H2)** и **списки**.\n"
                      "3.  **Вставьте текст вашего ТЗ** в правое поле и нажмите **«Распарсить ТЗ»**.",
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: bodyTextStyle(context),
                      listBullet: bodyTextStyle(context)),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Этап 2: Проверка и Анализ",
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                MarkdownBody(
                  data:
                      "1.  После парсинга ниже появятся **редактируемые поля**. Проверьте и при необходимости **скорректируйте** данные.\n"
                      "2.  Выберите подходящий **режим анализа** (рекомендуемый — «Разовые вхождения»).\n"
                      "3.  Нажмите **«Запустить глобальный анализ»** и получите подробный отчет.",
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: bodyTextStyle(context),
                      listBullet: bodyTextStyle(context)),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Обозначение подсветок в тексте",
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: bodyTextStyle(context),
                          children: [
                            TextSpan(
                              text: "  Точное вхождение  ",
                              style: TextStyle(
                                  backgroundColor:
                                      Colors.yellow.withOpacity(0.5)),
                            ),
                            const TextSpan(
                                text: " — ключ найден в точной форме."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: bodyTextStyle(context),
                          children: [
                            TextSpan(
                              text: "  Тематическое слово  ",
                              style: TextStyle(
                                  backgroundColor:
                                      Colors.lightBlue.withOpacity(0.4)),
                            ),
                            const TextSpan(
                                text: " — LSI-слово в начальной форме."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: bodyTextStyle(context),
                          children: [
                            TextSpan(
                              text: "  Тематического слова  ",
                              style: TextStyle(
                                  backgroundColor:
                                      Colors.lightGreen.withOpacity(0.5)),
                            ),
                            const TextSpan(
                                text: " — LSI-слово в другой словоформе."),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Все понятно!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showModeHelpDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: headlineSecondaryTextStyle(context)),
        content: Text(content, style: bodyTextStyle(context)),
        actions: [
          TextButton(
            child: const Text("Понятно"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _parseTzForPair(int index) {
    final pair = _pairs[index];
    final String tz = pair.tzController.text;
    if (tz.isEmpty || tz.length > 35000 || tz.contains('<script')) {
      _showError(
          "Поле ТЗ №${index + 1} пустое, превышает 35000 символов или содержит <script>.");
      return;
    }

    final parsedData = TzData(
      volume: _parseSection(tz, ['Объем текста', 'Объем']) ?? "Не найдено",
      metaTitle: _parseSection(tz, ['Title:', 'Title']) ?? "Не найдено",
      metaDescription:
          _parseSection(tz, ['Description:', 'Description']) ?? "Не найдено",
      structure: _parseSection(
              tz, ['Структура текста', 'Примерная структура статьи']) ??
          "Не найдено",
      exactKeywords: _parseSection(tz, [
            'Ключевые фразы',
            'Ключи, которые нужно использовать в тексте',
            'Ключи'
          ]) ??
          "Не найдено",
      dilutedKeywords: _parseSection(
              tz, ['Слова из подсветки в выдаче', 'Разбавленное вхождение']) ??
          "Не найдено",
      thematicWords: _parseSection(tz, [
            'Тематические слова использовать в любой форме',
            'Тематикозадающие слова / LSI',
            'LSI',
            'Тематические слова'
          ]) ??
          "Не найдено",
      generalRequirements:
          _parseSection(tz, ['Общие требования к тексту']) ?? "Не найдено",
    );

    pair.volumeController.text = parsedData.volume;
    pair.titleController.text = parsedData.metaTitle;
    pair.descriptionController.text = parsedData.metaDescription;
    pair.structureController.text = parsedData.structure;
    pair.exactKeywordsController.text =
        _formatKeywordsForField(parsedData.exactKeywords);
    pair.dilutedKeywordsController.text = parsedData.dilutedKeywords;
    pair.thematicWordsController.text = parsedData.thematicWords;

    setState(() {
      pair.parsedTz = parsedData;
      pair.analysisResult = null;
    });
  }

  void _showError(String message) {
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  String? _parseSection(String tzText, List<String> markers) {
    final tzLines = tzText.split('\n');
    int bestStartLine = -1;

    for (int i = 0; i < tzLines.length; i++) {
      final trimmedLine = tzLines[i].trim();
      if (trimmedLine.isEmpty) continue;

      for (var marker in markers) {
        final lowerMarker = marker.toLowerCase();
        final potentialHeader =
            trimmedLine.split(RegExp(r'[:\-—]')).first.trim().toLowerCase();

        if (potentialHeader.startsWith(lowerMarker)) {
          bestStartLine = i;
        }
      }
    }

    if (bestStartLine == -1) return null;

    final startLineText = tzLines[bestStartLine].trim();
    final separatorMatch = RegExp(r'[:\-—]').firstMatch(startLineText);

    if (markers.any((m) => ['title', 'description']
            .contains(m.toLowerCase().replaceAll(':', ''))) &&
        separatorMatch != null) {
      final content = startLineText.substring(separatorMatch.end).trim();
      if (content.isNotEmpty) return content;
    }

    List<String> contentLines = [];
    final lowerCaseMarkers =
        markers.map((m) => m.toLowerCase().replaceAll(':', '')).toList();
    final bool isParsingStructure =
        lowerCaseMarkers.any((m) => m.contains('структура'));
    List<String> stopMarkers = _allKnownMarkers
        .map((m) => m.toLowerCase().replaceAll(':', ''))
        .where((m) => !lowerCaseMarkers.contains(m))
        .toList();

    if (isParsingStructure) {
      stopMarkers.removeWhere((m) => m == 'h1' || m == 'h2');
    }

    for (int i = bestStartLine + 1; i < tzLines.length; i++) {
      final currentLine = tzLines[i];
      final trimmedLine = currentLine.trim();

      if (trimmedLine.isEmpty) {
        if (contentLines.isEmpty) continue;
        if (i + 1 < tzLines.length && tzLines[i + 1].trim().isEmpty) {
          if (!isParsingStructure) {
            break;
          }
        }
      }

      if (trimmedLine.isNotEmpty) {
        bool isNewSection = stopMarkers.any((stopMarker) {
          final potentialHeader =
              trimmedLine.split(RegExp(r'[:\-—]')).first.trim().toLowerCase();
          return potentialHeader == stopMarker;
        });
        if (isNewSection) break;
      }

      contentLines.add(currentLine);
    }

    String fullContent = contentLines.join('\n').trim();

    if (markers.any((m) =>
        m.toLowerCase().contains('подсветки') ||
        m.toLowerCase().contains('тематические'))) {
      final lines = fullContent.split('\n');
      int listStartIndex = -1;
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (RegExp(r'^[•*-]').hasMatch(line) ||
            (line.isNotEmpty && !line.contains(' ') && line.length < 30) ||
            (line.isNotEmpty &&
                RegExp(r'^\S.*\S$').hasMatch(line) &&
                !line.toLowerCase().startsWith('используя'))) {
          listStartIndex = i;
          break;
        }
      }
      if (listStartIndex != -1) {
        return lines.sublist(listStartIndex).join('\n').trim();
      }
    }

    return fullContent.isEmpty ? null : fullContent;
  }

  List<KeywordRequirement> _parseKeywordsFromTextForUI(String text) {
    if (text.toLowerCase() == "не найдено" || text.isEmpty) return [];
    List<KeywordRequirement> keywords = [];
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    final header1 = 'Ключевое слово'.toLowerCase();
    final header2 = 'Количество упоминаний в тексте(раз(а))'.toLowerCase();
    final contentLines = lines.where((line) {
      final trimmedLower = line.trim().toLowerCase();
      return trimmedLower.isNotEmpty &&
          trimmedLower != header1 &&
          trimmedLower != header2;
    }).toList();
    final countOnNextLineRegex = RegExp(r'^\((\d+)\)$');
    final rangeRegex = RegExp(r'(.+?)\s*\((\d+)(?:-(\d+))?\)\s*$');
    final tableRegex = RegExp(r'^(.*?)\s+\d+\s+раз\(?а?\)');

    for (int i = 0; i < contentLines.length; i++) {
      final currentLine = contentLines[i].trim();
      if (i + 1 < contentLines.length) {
        final nextLine = contentLines[i + 1].trim();
        final match = countOnNextLineRegex.firstMatch(nextLine);
        if (match != null) {
          final phrase = currentLine.replaceAll(RegExp(r'[\.,;]$'), '');
          final count = int.parse(match.group(1)!);
          keywords.add(KeywordRequirement(phrase, count, count));
          i++;
          continue;
        }
      }
      final rangeMatch = rangeRegex.firstMatch(currentLine);
      if (rangeMatch != null) {
        final phrase =
            rangeMatch.group(1)!.trim().replaceAll(RegExp(r'[\.,;]$'), '');
        final min = int.parse(rangeMatch.group(2)!);
        final max =
            rangeMatch.group(3) != null ? int.parse(rangeMatch.group(3)!) : min;
        keywords.add(KeywordRequirement(phrase, min, max));
        continue;
      }
      final tableMatch = tableRegex.firstMatch(currentLine);
      if (tableMatch != null) {
        final phrase =
            tableMatch.group(1)!.trim().replaceAll(RegExp(r'[\.,;]$'), '');
        final countString = RegExp(r'(\d+)').firstMatch(currentLine)!.group(1)!;
        final count = int.parse(countString);
        keywords.add(KeywordRequirement(phrase, count, count));
        continue;
      }
      if (currentLine.isNotEmpty) {
        keywords.add(KeywordRequirement(
            currentLine.replaceAll(RegExp(r'[\.,;]$'), ''), 1, 999));
      }
    }
    return keywords;
  }

  String _formatKeywordsForField(String rawText) {
    final reqs = _parseKeywordsFromTextForUI(rawText);
    if (reqs.isEmpty) return rawText;
    return reqs.map((r) => "${r.phrase} (${r.min})").join('\n');
  }

  Future<List<YandexSpellerError>> _checkSpelling(String text) async {
    if (text.trim().isEmpty) return [];
    final cleanedText = text.replaceAll('\u2028', '\n');
    const int maxTextLength = 9500;
    List<YandexSpellerError> allErrors = [];

    for (int i = 0; i < cleanedText.length; i += maxTextLength) {
      final int end = (i + maxTextLength > cleanedText.length)
          ? cleanedText.length
          : i + maxTextLength;
      final textChunk = cleanedText.substring(i, end);

      try {
        final response = await http.post(
          Uri.parse(
              'https://speller.yandex.net/services/spellservice.json/checkText'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'lang=ru&format=plain&text=${Uri.encodeComponent(textChunk)}',
        );

        if (response.statusCode == 200) {
          final List<dynamic> errorsJson =
              jsonDecode(utf8.decode(response.bodyBytes));
          for (var errorData in errorsJson) {
            allErrors.add(YandexSpellerError(
              errorData['word'],
              errorData['pos'] + i,
              errorData['len'],
              List<String>.from(errorData['s']),
            ));
          }
        }
      } catch (e) {
        debugPrint("Ошибка при обращении к Яндекс.Спеллер: $e");
      }
    }
    return allErrors;
  }

  List<TextSpan> _buildHighlightedText(String text,
      List<KeywordRequirement> exact, List<KeywordRequirement> thematic) {
    if (text.isEmpty) return [const TextSpan(text: '')];

    final lsiStemsToHighlight =
        thematic.map((req) => _stemText(req.phrase.toLowerCase())).toSet();

    Map<String, Color> phrasesToHighlight = {};
    for (var req in exact) {
      phrasesToHighlight[req.phrase.toLowerCase()] =
          Colors.yellow.withOpacity(0.5);
    }
    for (var req in thematic) {
      if (!phrasesToHighlight.containsKey(req.phrase.toLowerCase())) {
        phrasesToHighlight[req.phrase.toLowerCase()] =
            Colors.lightBlue.withOpacity(0.4);
      }
    }

    if (phrasesToHighlight.isEmpty && lsiStemsToHighlight.isEmpty) {
      return [TextSpan(text: text)];
    }

    List<Color?> highlightMap = List.filled(text.length, null);

    final wordRegex = RegExp(r'[\wА-Яа-я]+');
    for (final match in wordRegex.allMatches(text)) {
      final word = match.group(0)!;
      final wordStem = _stemText(word.toLowerCase());

      if (lsiStemsToHighlight.contains(wordStem)) {
        for (int i = match.start; i < match.end; i++) {
          highlightMap[i] = Colors.lightGreen.withOpacity(0.5);
        }
      }
    }

    if (phrasesToHighlight.isNotEmpty) {
      final pattern =
          phrasesToHighlight.keys.map((p) => RegExp.escape(p)).join('|');
      final regex = RegExp(pattern, caseSensitive: false);

      for (var match in regex.allMatches(text)) {
        final matchedPhrase = match.group(0)!.toLowerCase();
        bool isStartBoundary =
            (match.start == 0) || _isWordBoundary(text, match.start);
        bool isEndBoundary =
            (match.end == text.length) || _isWordBoundary(text, match.end);

        if (isStartBoundary && isEndBoundary) {
          final color = phrasesToHighlight[matchedPhrase];
          for (int i = match.start; i < match.end; i++) {
            highlightMap[i] = color;
          }
        }
      }
    }

    List<TextSpan> spans = [];
    int lastIndex = 0;
    Color? lastColor;

    for (int i = 0; i < text.length; i++) {
      final currentColor = highlightMap[i];
      if (currentColor != lastColor) {
        if (i > lastIndex) {
          spans.add(TextSpan(
            text: text.substring(lastIndex, i),
            style: TextStyle(backgroundColor: lastColor),
          ));
        }
        lastIndex = i;
        lastColor = currentColor;
      }
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(backgroundColor: lastColor),
      ));
    }

    return spans;
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: MaxWidthBox(
                maxWidth: 1600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Breadcrumbs(items: [
                      BreadcrumbItem(text: "Главная", routeName: '/'),
                      BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                      BreadcrumbItem(
                          text: "Инструменты SEO",
                          routeName: '/useful/instruments'),
                      BreadcrumbItem(
                          text: "SEO Анализатор текста", routeName: null),
                    ]),
                    const SizedBox(height: 40),
                    Text("Анализатор текста на соответствие SEO ТЗ",
                        style: headlineTextStyle(context)),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: subtitleTextStyle(context),
                        children: <TextSpan>[
                          const TextSpan(
                            text:
                                'Вставьте ваш текст и техническое задание, чтобы проверить соответствие ключевых параметров. Можно добавить до 5 пар для одновременного анализа.\n\n',
                          ),
                          TextSpan(
                            text: 'ПРИМЕР/ШАБЛОН ПОЛНОЦЕННОГО РАБОТАЮЩЕГО ТЗ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = Uri.parse(
                                    'https://docs.google.com/document/d/1DAVnjwPHQGfa23KZN7SO71T5DeSRtcRB/edit?usp=sharing&ouid=114606455229993507775&rtpof=true&sd=true');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Не удалось открыть ссылку')),
                                  );
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.help_outline, size: 18),
                        label: const Text("Как это работает?"),
                        onPressed: () => _showHelpDialog(context),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pairs.length,
                      itemBuilder: (context, index) {
                        return _buildTextTzPairWidget(index, theme);
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_pairs.length < 5)
                          OutlinedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Добавить пару"),
                            onPressed: _addPair,
                          ),
                        if (_pairs.length > 1) ...[
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.remove),
                            label: const Text("Удалить последнюю"),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red),
                            onPressed: () => _removePair(_pairs.length - 1),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildSearchModeSelector(),
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.analytics_outlined),
                        label: const Text("Запустить глобальный анализ"),
                        style: elevatedButtonStyle(context).copyWith(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[700]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 48, vertical: 20)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        onPressed: _isLoading ? null : _runGlobalAnalysis,
                      ),
                    ),
                    if (_pairs.any((p) => p.analysisResult != null)) ...[
                      const SizedBox(height: 40),
                      divider(context),
                      const SizedBox(height: 40),
                      Text("Результаты анализа",
                          style: headlineTextStyle(context)),
                      const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _pairs.length,
                        itemBuilder: (context, index) {
                          final pair = _pairs[index];
                          if (pair.analysisResult == null)
                            return const SizedBox.shrink();
                          return _buildResultSection(
                              context, pair.analysisResult!, index + 1);
                        },
                      )
                    ],
                    const SizedBox(height: 80),
                    divider(context),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ),
          _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildTextTzPairWidget(int index, ThemeData theme) {
    final pair = _pairs[index];
    const double editorHeight = 300;

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Пара №${index + 1}",
                style: headlineSecondaryTextStyle(context)),
            const SizedBox(height: 16),
            ResponsiveRowColumn(
              layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowSpacing: 24,
              columnSpacing: 24,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Текст", style: headlineSecondaryTextStyle(context)),
                      const SizedBox(height: 8),
                      QuillToolbar.simple(
                        configurations: QuillSimpleToolbarConfigurations(
                          controller: pair.textController,
                          customButtons: [
                            QuillToolbarCustomButtonOptions(
                              icon: Icon(Icons.paste),
                              tooltip: "Вставить с форматированием",
                              onPressed: () {
                                // <<< ИСПРАВЛЕНО ЗДЕСЬ
                                _pasteHtml(pair.textController);
                              },
                            ),
                          ],
                          sharedConfigurations: const QuillSharedConfigurations(
                            locale: Locale('ru'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        height: editorHeight,
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            controller: pair.textController,
                            padding: const EdgeInsets.all(8),
                            readOnly: false,
                            sharedConfigurations:
                                const QuillSharedConfigurations(
                              locale: Locale('ru'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
// Кнопка 1: Вставить текст
                          ElevatedButton.icon(
                            icon: const Icon(Icons.paste),
                            label: const Text("Вставить текст"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                            onPressed: () {
                              _pasteHtml(pair.textController);
                            },
                          ),
                          const SizedBox(width: 16), // Отступ между кнопками
// Кнопка 2: Распознать структуру
                          ElevatedButton.icon(
                            icon: const Icon(Icons.auto_fix_high),
                            label: const Text("Распознать структуру"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                            onPressed: () {
                              _recognizeStructure(pair.textController);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Техническое задание",
                          style: headlineSecondaryTextStyle(context)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 400,
                        child: TextField(
                          controller: pair.tzController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: bodyTextStyle(context),
                          decoration: InputDecoration(
                            hintText: "Вставьте ТЗ...",
                            hintStyle: subtitleTextStyle(context),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.manage_search),
                          label: const Text("Распарсить это ТЗ"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                          ),
                          onPressed: () => _parseTzForPair(index),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (pair.parsedTz != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildEditableFieldsForPair(pair),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableFieldsForPair(TextTzPair pair) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Проверьте и скорректируйте данные из ТЗ",
            style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 16),
        _buildEditableField(context, pair.volumeController, "Объем текста"),
        const SizedBox(height: 16),
        _buildEditableField(context, pair.titleController, "Метатег Title"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.descriptionController, "Метатег Description"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.structureController, "Структура текста"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.exactKeywordsController, "Точное вхождение (Ключи)"),
        const SizedBox(height: 16),
        _buildEditableField(context, pair.dilutedKeywordsController,
            "Слова из подсветки в выдаче"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.thematicWordsController, "Тематические слова (LSI)"),
      ],
    );
  }

  Widget _buildEditableField(
      BuildContext context, TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: bodyTextStyle(context).copyWith(fontFamily: 'monospace'),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Если данные не нашлись, вы можете вписать их сюда...",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(
      BuildContext context, AnalysisResult result, int pairNumber) {
    return ExpansionTile(
      title: Text("Результаты анализа для Пары №$pairNumber",
          style: headlineTextStyle(context)),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.highlightedText.isNotEmpty) ...[
                Text("Текст с подсветкой",
                    style: headlineSecondaryTextStyle(context)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText.rich(
                    TextSpan(
                      style: bodyTextStyle(context),
                      children: result.highlightedText,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text("Общие требования",
                  style: headlineSecondaryTextStyle(context)),
              const SizedBox(height: 8),
              ...result.generalResults.map((res) => Card(
                    child: ListTile(
                      title: Text(res.name),
                      subtitle: Text(
                          "Требование: ${res.requirement}, Факт: ${res.actual}"),
                      trailing: res.isSuccess
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red),
                    ),
                  )),
              const SizedBox(height: 24),
              _buildSpellingErrorsSection(context, result.spellingErrors),
              const SizedBox(height: 24),
              Text("Параметры из ТЗ",
                  style: headlineSecondaryTextStyle(context)),
              const SizedBox(height: 8),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.text_fields),
                      title: const Text("Объем текста (без пробелов)"),
                      subtitle: Text(result.volumeResult),
                      trailing: result.volumeResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.title),
                      title: const Text("Метатег Title"),
                      subtitle: Text(result.titleResult),
                      trailing: result.titleResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text("Метатег Description"),
                      subtitle: Text(result.descriptionResult),
                      trailing: result.descriptionResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.format_list_bulleted),
                      title: const Text("Структура текста"),
                      subtitle: Text(result.structureResult),
                      trailing: result.structureResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(
                  context, "Точное вхождение", result.exactInclusion),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(context,
                  "Слова из подсветки в выдаче", result.dilutedInclusion),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(
                  context, "Тематические слова (LSI)", result.thematicWords),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSearchModeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Выберите режим анализа вхождений:",
            style: headlineSecondaryTextStyle(context),
          ),
          const SizedBox(height: 8),
          RadioListTile<SearchMode>(
            title: Row(
              children: [
                const Text("Пересечение вхождений (стандартный)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Пересечение вхождений",
                    "Самый простой режим. Каждая ключевая фраза ищется по всему тексту независимо от других. Если фраза 'купить автомобиль' найдена, то при поиске слова 'автомобиль' оно также будет найдено внутри этой фразы. Этот режим может завышать количество коротких ключей.",
                  ),
                )
              ],
            ),
            value: SearchMode.overlapping,
            groupValue: _selectedMode,
            onChanged: (SearchMode? value) {
              if (value != null) setState(() => _selectedMode = value);
            },
          ),
          RadioListTile<SearchMode>(
            title: Row(
              children: [
                const Text("Разовые вхождения (рекомендуемый)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Разовые вхождения",
                    "Более точный SEO-алгоритм. Сначала ищутся самые длинные фразы. Если фраза 'купить автомобиль' найдена, то эта часть текста 'блокируется', и более короткие ключи ('автомобиль', 'купить') внутри нее уже не ищутся. Блокировка работает только в рамках одного типа ключей (например, 'Точных').",
                  ),
                ),
              ],
            ),
            value: SearchMode.singlePass,
            groupValue: _selectedMode,
            onChanged: (SearchMode? value) {
              if (value != null) setState(() => _selectedMode = value);
            },
          ),
          RadioListTile<SearchMode>(
            title: Row(
              children: [
                const Text("Уникальные вхождения (строгий)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Уникальные вхождения",
                    "Самый строгий режим. Если любая фраза (например, точное вхождение 'купить автомобиль') найдена, то эта часть текста блокируется для поиска ВООБЩЕ ВСЕХ ДРУГИХ ключей (включая LSI и слова из подсветки). Полезно для избегания переспама.",
                  ),
                ),
              ],
            ),
            value: SearchMode.uniquePass,
            groupValue: _selectedMode,
            onChanged: (SearchMode? value) {
              if (value != null) setState(() => _selectedMode = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpellingErrorsSection(
      BuildContext context, List<YandexSpellerError> errors) {
    if (errors.isEmpty) {
      return Card(
        color: Colors.green.withOpacity(0.1),
        child: const ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text("Орфографических ошибок не найдено"),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Орфография (найдено ${errors.length} ${errors.length == 1 ? 'ошибка' : (errors.length < 5 ? 'ошибки' : 'ошибок')})",
          style: headlineSecondaryTextStyle(context),
        ),
        const SizedBox(height: 8),
        ...errors.map((error) {
          int start = error.pos - 20;
          if (start < 0) start = 0;
          final text = _pairs.first.textController.document.toPlainText();
          int end = error.pos + error.len + 20;
          if (end > text.length) {
            end = text.length;
          }
          final contextText = text.substring(start, end);

          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  style: bodyTextStyle(context),
                  children: [
                    TextSpan(text: contextText.substring(0, error.pos - start)),
                    TextSpan(
                      text: error.word,
                      style: const TextStyle(
                        backgroundColor: Colors.redAccent,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                        text: contextText
                            .substring(error.pos - start + error.len)),
                  ],
                ),
              ),
              subtitle: Text("Варианты: ${error.suggestions.join(', ')}"),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildKeywordAnalysisSection(BuildContext context, String title,
      AnalysisCategoryResult categoryResult) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 16),
        if (categoryResult.results.isEmpty)
          const Text("Требования для этой категории в ТЗ не найдены.")
        else ...[
          Text("Всего ключей в ТЗ: ${categoryResult.results.length}"),
          if (categoryResult.notFound > 0)
            Text(
                "❌ Нет вхождений: ${categoryResult.notFound} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.red)),
          if (categoryResult.moreThanNeeded > 0)
            Text(
                "⚠️ Вхождений больше, чем нужно: ${categoryResult.moreThanNeeded} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.orange)),
          if (categoryResult.lessThanNeeded > 0)
            Text(
                "⚠️ Вхождений меньше, чем нужно: ${categoryResult.lessThanNeeded} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.orange)),
          if (categoryResult.perfectMatch > 0)
            Text(
                "✅ Требуемое кол-во вхождений: ${categoryResult.perfectMatch} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 8),
          ExpansionTile(
            title: const Text("Показать детальную таблицу"),
            children: [
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Ключевая фраза")),
                    DataColumn(label: Text("Требуется"), numeric: true),
                    DataColumn(label: Text("Найдено"), numeric: true),
                  ],
                  rows: categoryResult.results.map((entry) {
                    final req = entry.key;
                    final count = entry.value;
                    Color rowColor = Colors.transparent;
                    if (count == 0)
                      rowColor = Colors.red.withOpacity(0.1);
                    else if (count < req.min || count > req.max)
                      rowColor = Colors.orange.withOpacity(0.1);
                    else
                      rowColor = Colors.green.withOpacity(0.1);

                    return DataRow(
                        color: MaterialStateProperty.all(rowColor),
                        cells: [
                          DataCell(Text(req.phrase)),
                          DataCell(Text(req.max >= 999
                              ? "≥ ${req.min}"
                              : (req.min == req.max
                                  ? "${req.min}"
                                  : "${req.min}-${req.max}"))),
                          DataCell(Text("$count")),
                        ]);
                  }).toList(),
                ),
              ),
            ],
          )
        ]
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isLoading
          ? Container(
              key: const ValueKey('loading'),
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Идет полный семантический анализ...\nПожалуйста, подождите.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('notLoading')),
    );
  }
}

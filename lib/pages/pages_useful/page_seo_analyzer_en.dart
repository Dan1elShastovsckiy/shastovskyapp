// /lib/pages/pages_useful/page_seo_analyzer_en.dart

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:http/http.dart' as http;
import 'package:minimal/components/components.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:minimal/utils/meta_tag_service.dart';
import 'dart:async';
import 'package:snowball_stemmer/snowball_stemmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:html2md/html2md.dart' as html2md;

// --- DATA MODELS (Language Agnostic) ---

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
      if (count == 0) {
        notFound++;
      } else if (count < req.min)
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

// <<< START: ISOLATE ANALYSIS LOGIC (ADAPTED FOR ENGLISH) >>>

Future<Map<String, dynamic>> runAnalysisInIsolateEn(
    AnalysisPayload payload) async {
  final doc = Document.fromJson(payload.quillDelta);
  final plainTextFromDelta = doc.toPlainText();
  final converter =
      QuillDeltaToHtmlConverter(List.castFrom(payload.quillDelta));
  final html = converter.convert();
  final markdownTextFromDelta = html2md.convert(html);

  final stemmer = SnowballStemmer(Algorithm.english);

  String stemText(String text) {
    final words = text.split(RegExp(r"(\s+|[.,!?—:;()" "'-])"));
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
    if (text.toLowerCase() == "not found" || text.isEmpty) return [];
    List<KeywordRequirement> keywords = [];
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    final header1 = 'keyword'.toLowerCase();
    final header2 = 'mentions (count)'.toLowerCase();
    final contentLines = lines.where((line) {
      final trimmedLower = line.trim().toLowerCase();
      return trimmedLower.isNotEmpty &&
          trimmedLower != header1 &&
          trimmedLower != header2;
    }).toList();
    final countOnNextLineRegex = RegExp(r'^\((\d+)\)$');
    final rangeRegex = RegExp(r'(.+?)\s*\((\d+)(?:-(\d+))?\)\s*$');

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
      'a',
      'an',
      'the',
      'and',
      'or',
      'but',
      'for',
      'in',
      'on',
      'at',
      'to',
      'from',
      'with',
      'by'
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
    final services = [
      'Uniqueness',
      'Readability',
      'Spam Score',
      'Water Content'
    ];
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
        String actualString = actMatch?.group(1) ?? 'Not found';
        if (actValue != null) {
          if (service == 'Uniqueness' || service == 'Readability') {
            success = actValue >= reqValue;
          } else {
            success = actValue <= reqValue;
          }
        }
        String reqString = (service == 'Uniqueness' || service == 'Readability')
            ? '≥ $reqValue'
            : '≤ $reqValue';
        results.add(GeneralRequirementResult(
            service, reqString, actualString, success));
      }
    }
    final firstParagraph =
        text.split('\n\n').first.replaceAll(RegExp(r'#+\s*'), '');
    results.add(GeneralRequirementResult('First Paragraph', '≤ 500 chars',
        '${firstParagraph.length}', firstParagraph.length <= 500));
    final hasList = text.contains(RegExp(r'^\s*[*-]|\d+\.', multiLine: true));
    results.add(GeneralRequirementResult(
        'Lists', 'At least 1', hasList ? 'Present' : 'Absent', hasList));
    final h2Count =
        RegExp(r'(^##\s+.+)|(^.+\n-+$)', multiLine: true, caseSensitive: false)
            .allMatches(text)
            .length;
    results.add(GeneralRequirementResult('H2 Subheadings', 'Present',
        h2Count > 0 ? 'Found: $h2Count' : 'None', h2Count > 0));
    return results;
  }

  String analyzeVolume(String text, String requirement) {
    final currentVolume = text.replaceAll(' ', '').length;
    final regex = RegExp(r'(\d+)');
    final matches = regex.allMatches(requirement).toList();
    if (matches.isEmpty) {
      return 'Current volume: $currentVolume chars. Requirement not found in TechSpec.';
    }
    final minVolume = int.parse(matches[0].group(1)!);
    final maxVolume = matches.length > 1
        ? int.parse(matches[1].group(1)!)
        : minVolume + (minVolume * 0.2).round();
    if (currentVolume >= minVolume && currentVolume <= maxVolume) {
      return '✅ Volume matches: $currentVolume of $minVolume-$maxVolume chars (no spaces)';
    } else if (currentVolume < minVolume) {
      return '❌ Volume does not match: $currentVolume of $minVolume-$maxVolume chars (need ${minVolume - currentVolume} more)';
    } else {
      return '❌ Volume does not match: $currentVolume of $minVolume-$maxVolume chars (exceeded by ${currentVolume - maxVolume})';
    }
  }

  String analyzeMetaTag(String text, String requirement, String tagName) {
    if (requirement.toLowerCase() == "not found" || requirement.isEmpty) {
      return 'Requirement for $tagName not found in TechSpec.';
    }
    if (text.toLowerCase().contains(requirement.toLowerCase().trim())) {
      return '✅ $tagName found in the text.';
    } else {
      return '❌ $tagName not found in the text.';
    }
  }

  String analyzeStructure(String text, String requirement) {
    if (requirement.toLowerCase() == "not found" || requirement.isEmpty) {
      return 'Structure requirements not found in TechSpec.';
    }
    final List<String> requiredThemes = requirement
        .split('\n')
        .map((line) => line.trim())
        .where((line) =>
            line.isNotEmpty &&
            line.length > 10 &&
            !line.toLowerCase().startsWith('what to write') &&
            !line.toLowerCase().startsWith('format'))
        .toList();
    if (requiredThemes.isEmpty) {
      return '⚠️ No themes found in TZ to check structure against.';
    }
    final h2Pattern = RegExp(r'(^##\s+(.+)$)|(^(.+)\n-+$)', multiLine: true);
    final List<String> articleHeadings =
        h2Pattern.allMatches(text).map((match) {
      return (match.group(2) ?? match.group(4) ?? '').trim();
    }).toList();
    if (articleHeadings.isEmpty) {
      return '⚠️ No H2 headings found in Markdown format (## Heading) in the text.';
    }
    int foundCount = 0;
    List<String> notFoundThemes = [];
    for (var theme in requiredThemes) {
      bool themeFound = false;
      final themeKeywords = theme
          .toLowerCase()
          .replaceAll(RegExp(r'[,.()?]'), '')
          .split(' ')
          .where((word) => word.length > 3)
          .toSet();
      if (themeKeywords.isEmpty) continue;
      for (var heading in articleHeadings) {
        final normalizedHeading = heading.toLowerCase();
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
        '${isOk ? '✅' : '⚠️'} Found correspondence for $foundCount of ${requiredThemes.length} structure themes.';
    if (notFoundThemes.isNotEmpty) {
      result +=
          '\nThemes with no correspondence in headings: ${notFoundThemes.join("; ")}';
    }
    return result;
  }

  final markdownText = markdownTextFromDelta;
  final plainText = plainTextFromDelta;
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

class SeoAnalyzerPageEn extends StatefulWidget {
  static const String name = 'useful/instruments/seo-analyzer-en';
  const SeoAnalyzerPageEn({super.key});

  @override
  State<SeoAnalyzerPageEn> createState() => _SeoAnalyzerPageEnState();
}

class _SeoAnalyzerPageEnState extends State<SeoAnalyzerPageEn> {
  final List<TextTzPair> _pairs = [TextTzPair()];
  bool _isLoading = false;
  SearchMode _selectedMode = SearchMode.overlapping;

  static const List<String> _allKnownMarkers = [
    'Volume',
    'Text Volume',
    'Title:',
    'Title',
    'Meta Title',
    'Description:',
    'Description',
    'Meta Description',
    'H1:',
    'H1',
    'Meta Tags',
    'Structure',
    'Article Structure',
    'Example Structure',
    'Keywords',
    'Key Phrases',
    'Exact Keywords',
    'Diluted Keywords',
    'Thematic Words',
    'LSI Keywords',
    'LSI',
    'General Requirements',
    'Theme/H1',
    'Page URL',
    'FAQ',
    'Notes',
    'Competitor Examples',
    'Note'
  ];

  final SnowballStemmer _stemmer = SnowballStemmer(Algorithm.english);

  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title: "SEO Text Analyzer | Daniil Shastovsky's Tools",
      description:
          "A free online tool to check text compliance with SEO technical specifications. Analyzes keywords, LSI, volume, and other parameters.",
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
    final plainText = controller.document.toPlainText();
    final lines = const LineSplitter().convert(plainText);
    final newDelta = Delta();

    for (final line in lines) {
      final trimmedLine = line.trim();

      if (trimmedLine.isEmpty) {
        newDelta.insert('\n');
        continue;
      }

      if (trimmedLine.startsWith('•') ||
          trimmedLine.startsWith('-') ||
          trimmedLine.startsWith('*')) {
        final lineContent = trimmedLine.substring(1).trim();
        newDelta.insert(lineContent);
        newDelta.insert('\n', {'list': 'bullet'});
      } else if (trimmedLine.length < 80 &&
          !'.?!,:;'.contains(trimmedLine.substring(trimmedLine.length - 1))) {
        newDelta.insert(trimmedLine);
        newDelta.insert('\n', {'header': 2});
      } else {
        newDelta.insert('$trimmedLine\n');
      }
    }
    controller.document = Document.fromDelta(newDelta);
    controller.moveCursorToEnd();
  }

  Future<void> _runGlobalAnalysis() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 50));
    _performAnalysis();
  }

  Future<void> _performAnalysis() async {
    for (var pair in _pairs) {
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
        generalRequirements:
            _parseSection(pair.tzController.text, ['General Requirements']) ??
                "Not found",
      );

      final payload = AnalysisPayload(
        quillDelta: pair.textController.document.toDelta().toJson(),
        tzData: tzData,
        searchMode: _selectedMode,
      );

      final isolateFuture = compute(runAnalysisInIsolateEn, payload);
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

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pasteHtml(QuillController controller) async {
    String? clipboardText;
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      clipboardText = clipboardData?.text;
    } catch (e) {
      debugPrint("Failed to read clipboard: $e");
      return;
    }

    if (clipboardText == null || clipboardText.isEmpty) {
      return;
    }

    final selection = controller.selection;
    controller.document.replace(
        selection.start, selection.end - selection.start, clipboardText);
  }

  String _stemText(String text) {
    final words = text.split(RegExp(r"(\s+|[.,!?—:;()'" "'-])"));
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
          title: Text("How to use the analyzer",
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
                  "This tool is designed to automate checking texts for compliance with SEO technical specifications (TechSpec).",
                  style: bodyTextStyle(context),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Step 1: Input and Formatting",
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                MarkdownBody(
                  data:
                      "1.  **Paste the article text** into the left field. Formatting from Word/Google Docs might be lost on paste.\n"
                      "2.  **Use the toolbar** above the input field to quickly mark up **headings (H1, H2)** and **lists**.\n"
                      "3.  **Paste your TechSpec text** into the right field and click **\"Parse This TZ\"**.",
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: bodyTextStyle(context),
                      listBullet: bodyTextStyle(context)),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Step 2: Verification and Analysis",
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                MarkdownBody(
                  data:
                      "1.  After parsing, **editable fields** will appear below. Check and **correct** the data if necessary.\n"
                      "2.  Choose a suitable **analysis mode** (recommended — \"Single Pass\").\n"
                      "3.  Click **\"Run Global Analysis\"** to get a detailed report.",
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: bodyTextStyle(context),
                      listBullet: bodyTextStyle(context)),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Text Highlighting Legend",
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
                              text: "  Exact Match  ",
                              style: TextStyle(
                                  backgroundColor:
                                      Colors.yellow.withOpacity(0.5)),
                            ),
                            const TextSpan(
                                text: " — keyword found in its exact form."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: bodyTextStyle(context),
                          children: [
                            TextSpan(
                              text: "  Thematic Word  ",
                              style: TextStyle(
                                  backgroundColor:
                                      Colors.lightBlue.withOpacity(0.4)),
                            ),
                            const TextSpan(
                                text: " — LSI word in its base form."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: bodyTextStyle(context),
                          children: [
                            TextSpan(
                              text: "  Thematic Word Form  ",
                              style: TextStyle(
                                  backgroundColor:
                                      Colors.lightGreen.withOpacity(0.5)),
                            ),
                            const TextSpan(
                                text: " — LSI word in a different form."),
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
              child: const Text("Got it!"),
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
            child: const Text("OK"),
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
          "TechSpec field #${index + 1} is empty, exceeds 35,000 characters, or contains a <script> tag.");
      return;
    }

    final parsedData = TzData(
      volume: _parseSection(tz, ['Volume', 'Text Volume']) ?? "Not found",
      metaTitle:
          _parseSection(tz, ['Title:', 'Title', 'Meta Title']) ?? "Not found",
      metaDescription: _parseSection(
              tz, ['Description:', 'Description', 'Meta Description']) ??
          "Not found",
      structure:
          _parseSection(tz, ['Structure', 'Article Structure']) ?? "Not found",
      exactKeywords: _parseSection(tz, [
            'Keywords',
            'Key Phrases',
            'Exact Keywords',
          ]) ??
          "Not found",
      dilutedKeywords: _parseSection(tz, ['Diluted Keywords']) ?? "Not found",
      thematicWords: _parseSection(tz, [
            'Thematic Words',
            'LSI Keywords',
            'LSI',
          ]) ??
          "Not found",
      generalRequirements:
          _parseSection(tz, ['General Requirements']) ?? "Not found",
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
        lowerCaseMarkers.any((m) => m.contains('structure'));
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
        m.toLowerCase().contains('thematic') ||
        m.toLowerCase().contains('lsi'))) {
      final lines = fullContent.split('\n');
      int listStartIndex = -1;
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (RegExp(r'^[•*-]').hasMatch(line) ||
            (line.isNotEmpty && !line.contains(' ') && line.length < 30) ||
            (line.isNotEmpty &&
                RegExp(r'^\S.*\S$').hasMatch(line) &&
                !line.toLowerCase().startsWith('use'))) {
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
    if (text.toLowerCase() == "not found" || text.isEmpty) return [];
    List<KeywordRequirement> keywords = [];
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    final header1 = 'keyword'.toLowerCase();
    final header2 = 'mentions (count)'.toLowerCase();
    final contentLines = lines.where((line) {
      final trimmedLower = line.trim().toLowerCase();
      return trimmedLower.isNotEmpty &&
          trimmedLower != header1 &&
          trimmedLower != header2;
    }).toList();
    final countOnNextLineRegex = RegExp(r'^\((\d+)\)$');
    final rangeRegex = RegExp(r'(.+?)\s*\((\d+)(?:-(\d+))?\)\s*$');

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
          // ADAPTED: Changed language to English
          body: 'lang=en&format=plain&text=${Uri.encodeComponent(textChunk)}',
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
        debugPrint("Error contacting Yandex.Speller: $e");
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

    final wordRegex = RegExp(r'(.+?)\s*\((\d+)(?:-(\d+))?\)\s*$');
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

  // --- UI (Fully Translated) ---
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
                      BreadcrumbItem(text: "Home", routeName: '/'),
                      BreadcrumbItem(text: "Useful", routeName: '/useful'),
                      BreadcrumbItem(
                          text: "SEO Tools", routeName: '/useful/instruments'),
                      BreadcrumbItem(
                          text: "SEO Text Analyzer", routeName: null),
                    ]),
                    const SizedBox(height: 40),
                    Text("SEO Text Analyzer for Technical Specifications",
                        style: headlineTextStyle(context)),
                    const SizedBox(height: 16),
                    Text(
                        'Paste your text and technical specifications (TechSpec) to check compliance with key parameters. You can add up to 5 pairs for simultaneous analysis.',
                        style: subtitleTextStyle(context)),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.help_outline, size: 18),
                        label: const Text("How does it work?"),
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
                            label: const Text("Add Pair"),
                            onPressed: _addPair,
                          ),
                        if (_pairs.length > 1) ...[
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.remove),
                            label: const Text("Remove Last"),
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
                        label: const Text("Run Global Analysis"),
                        style: elevatedButtonStyle(context).copyWith(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.green[700]),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 48, vertical: 20)),
                          textStyle: WidgetStateProperty.all(const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        onPressed: _isLoading ? null : _runGlobalAnalysis,
                      ),
                    ),
                    if (_pairs.any((p) => p.analysisResult != null)) ...[
                      const SizedBox(height: 40),
                      divider(context),
                      const SizedBox(height: 40),
                      Text("Analysis Results",
                          style: headlineTextStyle(context)),
                      const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _pairs.length,
                        itemBuilder: (context, index) {
                          final pair = _pairs[index];
                          if (pair.analysisResult == null) {
                            return const SizedBox.shrink();
                          }
                          return _buildResultSection(
                              context, pair.analysisResult!, index + 1);
                        },
                      )
                    ],
                    const SizedBox(height: 80),
                    const ShareButtonsBlock(
                      shareText: "Check out this handy SEO analyzer:",
                      shareSubject: "Tool: SEO Text Analyzer",
                    ),
                    const SizedBox(height: 40),
                    divider(context),
                    ...authorSection(
                      context: context,
                      imageUrl: "assets/images/avatar_default.webp",
                      name: "Tool Author: Daniil Shastovsky",
                      bio:
                          "SEO specialist and Flutter developer. I create useful tools for myself and my colleagues to automate routine tasks.",
                    ),
                    const SizedBox(height: 40),
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
    // ... This widget's internal text is also translated
    // Full method provided for clarity
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
            Text("Pair #${index + 1}",
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
                      Text("Text", style: headlineSecondaryTextStyle(context)),
                      const SizedBox(height: 8),
                      QuillToolbar.simple(
                        configurations: QuillSimpleToolbarConfigurations(
                          controller: pair.textController,
                          sharedConfigurations: const QuillSharedConfigurations(
                            locale: Locale('en'),
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
                              locale: Locale('en'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.paste),
                            label: const Text("Paste Text"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                            onPressed: () {
                              _pasteHtml(pair.textController);
                            },
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.auto_fix_high),
                            label: const Text("Recognize Structure"),
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
                      Text("Technical Specifications (TechSpec)",
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
                            hintText: "Paste your TechSpec here...",
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
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.manage_search),
                          label: const Text("Parse This TechSpec"),
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
        Text("Verify and correct the parsed TechSpec data",
            style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 16),
        _buildEditableField(context, pair.volumeController, "Text Volume"),
        const SizedBox(height: 16),
        _buildEditableField(context, pair.titleController, "Meta Title"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.descriptionController, "Meta Description"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.structureController, "Text Structure"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.exactKeywordsController, "Exact Keywords"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.dilutedKeywordsController, "Diluted Keywords"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.thematicWordsController, "Thematic Words (LSI)"),
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
            hintText: "If data was not found, you can enter it here...",
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
      title: Text("Analysis Results for Pair #$pairNumber",
          style: headlineTextStyle(context)),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.highlightedText.isNotEmpty) ...[
                Text("Highlighted Text",
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
              Text("General Requirements",
                  style: headlineSecondaryTextStyle(context)),
              const SizedBox(height: 8),
              ...result.generalResults.map((res) => Card(
                    child: ListTile(
                      title: Text(res.name),
                      subtitle: Text(
                          "Required: ${res.requirement}, Actual: ${res.actual}"),
                      trailing: res.isSuccess
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red),
                    ),
                  )),
              const SizedBox(height: 24),
              _buildSpellingErrorsSection(context, result.spellingErrors),
              const SizedBox(height: 24),
              Text("TechSpec Parameters",
                  style: headlineSecondaryTextStyle(context)),
              const SizedBox(height: 8),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.text_fields),
                      title: const Text("Text Volume (no spaces)"),
                      subtitle: Text(result.volumeResult),
                      trailing: result.volumeResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.title),
                      title: const Text("Meta Title"),
                      subtitle: Text(result.titleResult),
                      trailing: result.titleResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text("Meta Description"),
                      subtitle: Text(result.descriptionResult),
                      trailing: result.descriptionResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.format_list_bulleted),
                      title: const Text("Text Structure"),
                      subtitle: Text(result.structureResult),
                      trailing: result.structureResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(
                  context, "Exact Match Keywords", result.exactInclusion),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(
                  context, "Diluted Keywords", result.dilutedInclusion),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(
                  context, "Thematic Words (LSI)", result.thematicWords),
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
            "Select keyword analysis mode:",
            style: headlineSecondaryTextStyle(context),
          ),
          const SizedBox(height: 8),
          RadioListTile<SearchMode>(
            title: Row(
              children: [
                const Text("Overlapping Occurrences (standard)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Overlapping Occurrences",
                    "The simplest mode. Each keyword is searched throughout the text independently. If 'buy a car' is found, a search for 'car' will also find it within that phrase. This mode may overcount shorter keywords.",
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
                const Text("Single Pass (recommended)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Single Pass",
                    "A more accurate SEO algorithm. It searches for the longest phrases first. If 'buy a car' is found, that part of the text is 'locked,' and shorter keywords ('car', 'buy') are no longer searched for within it. Locking works only within one keyword type (e.g., 'Exact').",
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
                const Text("Unique Pass (strict)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Unique Pass",
                    "The strictest mode. If any phrase (e.g., exact match 'buy a car') is found, that part of the text is locked for ALL OTHER keyword searches (including LSI and diluted). Useful for avoiding keyword stuffing.",
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
          title: Text("No spelling errors found"),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Spelling (found ${errors.length} ${errors.length == 1 ? 'error' : 'errors'})",
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
              subtitle: Text("Suggestions: ${error.suggestions.join(', ')}"),
            ),
          );
        }),
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
          const Text("Requirements for this category not found in TechSpec.")
        else ...[
          Text("Total keywords in TechSpec: ${categoryResult.results.length}"),
          if (categoryResult.notFound > 0)
            Text(
                "❌ Not found: ${categoryResult.notFound} of ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.red)),
          if (categoryResult.moreThanNeeded > 0)
            Text(
                "⚠️ More than required: ${categoryResult.moreThanNeeded} of ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.orange)),
          if (categoryResult.lessThanNeeded > 0)
            Text(
                "⚠️ Less than required: ${categoryResult.lessThanNeeded} of ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.orange)),
          if (categoryResult.perfectMatch > 0)
            Text(
                "✅ Perfect match: ${categoryResult.perfectMatch} of ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 8),
          ExpansionTile(
            title: const Text("Show detailed table"),
            children: [
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Keyword")),
                    DataColumn(label: Text("Required"), numeric: true),
                    DataColumn(label: Text("Found"), numeric: true),
                  ],
                  rows: categoryResult.results.map((entry) {
                    final req = entry.key;
                    final count = entry.value;
                    Color rowColor = Colors.transparent;
                    if (count == 0) {
                      rowColor = Colors.red.withOpacity(0.1);
                    } else if (count < req.min || count > req.max)
                      rowColor = Colors.orange.withOpacity(0.1);
                    else
                      rowColor = Colors.green.withOpacity(0.1);

                    return DataRow(
                        color: WidgetStateProperty.all(rowColor),
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
                      'Running full semantic analysis...\nPlease wait.',
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

// lib/components/semantic_widgets.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

abstract class SemanticWidget extends StatefulWidget {
  final String tag;
  final String text;
  final Map<String, String> attributes;

  const SemanticWidget({
    super.key,
    required this.tag,
    this.text = '',
    this.attributes = const {},
  });
}

abstract class _SemanticWidgetState<T extends SemanticWidget> extends State<T> {
  @override
  void initState() {
    super.initState();

    // Выполняем логику только в веб-режиме пререндеринга
    if (kIsWeb && Uri.base.queryParameters['prerender'] == 'true') {
      // Используем addPostFrameCallback, чтобы гарантировать, что DOM готов
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final container = web.document.getElementById('prerender-container');
        if (container == null) return;

        // Каждый маршрут пререндерится в новом BrowserContext с пустым контейнером.
        // Не очищаем его из callback виджета: более поздний кадр иначе мог бы
        // удалить уже добавленные семантические элементы, включая ссылки внизу статьи.
        final element = web.document.createElement(widget.tag);
        element.textContent = widget.text;
        widget.attributes.forEach((key, value) {
          element.setAttribute(key, value);
        });
        container.append(element);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // <<< КЛЮЧЕВОЕ ИЗМЕНЕНИЕ: Виджет не рендерит НИЧЕГО >>>
    // Это полностью безопасно для любой сборки. Вся работа сделана в initState.
    return const SizedBox.shrink();
  }
}

// Конкретные реализации остаются без изменений
class SemanticH1 extends SemanticWidget {
  const SemanticH1(String text, {super.key}) : super(tag: 'h1', text: text);
  @override
  State<SemanticH1> createState() => _SemanticH1State();
}

class _SemanticH1State extends _SemanticWidgetState<SemanticH1> {}

class SemanticH2 extends SemanticWidget {
  const SemanticH2(String text, {super.key}) : super(tag: 'h2', text: text);
  @override
  State<SemanticH2> createState() => _SemanticH2State();
}

class _SemanticH2State extends _SemanticWidgetState<SemanticH2> {}

class SemanticP extends SemanticWidget {
  const SemanticP(String text, {super.key}) : super(tag: 'p', text: text);
  @override
  State<SemanticP> createState() => _SemanticPState();
}

class _SemanticPState extends _SemanticWidgetState<SemanticP> {}

class SemanticLinkedParagraph extends SemanticWidget {
  final String prefix;
  final String linkText;
  final String href;
  final String suffix;

  const SemanticLinkedParagraph({
    super.key,
    required this.prefix,
    required this.linkText,
    required this.href,
    this.suffix = '',
  }) : super(tag: 'p');

  @override
  State<SemanticLinkedParagraph> createState() =>
      _SemanticLinkedParagraphState();
}

class _SemanticLinkedParagraphState
    extends State<SemanticLinkedParagraph> {
  @override
  void initState() {
    super.initState();

    if (kIsWeb && Uri.base.queryParameters['prerender'] == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final container = web.document.getElementById('prerender-container');
        if (container == null) return;

        final paragraph = web.document.createElement('p');
        paragraph.append(web.document.createTextNode(widget.prefix));

        final link = web.document.createElement('a');
        link.textContent = widget.linkText;
        link.setAttribute('href', widget.href);
        paragraph.append(link);
        paragraph.append(web.document.createTextNode(widget.suffix));

        container.append(paragraph);
      });
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class SemanticImg extends SemanticWidget {
  SemanticImg({super.key, required String src, String alt = ''})
      : super(tag: 'img', attributes: {'src': _resolveAssetSrc(src), 'alt': alt});

  static String _resolveAssetSrc(String src) {
    // Flutter copies bundled assets beneath the web app's /assets/ directory.
    // Semantic image paths use package-relative names such as assets/images/.. .
    if (src.startsWith('assets/') && !src.startsWith('assets/assets/')) {
      return 'assets/$src';
    }
    return src;
  }

  @override
  State<SemanticImg> createState() => _SemanticImgState();
}

class _SemanticImgState extends _SemanticWidgetState<SemanticImg> {}

class SemanticA extends SemanticWidget {
  SemanticA({super.key, required String href, required super.text})
      : super(tag: 'a', attributes: {'href': href});
  @override
  State<SemanticA> createState() => _SemanticAState();
}

class _SemanticAState extends _SemanticWidgetState<SemanticA> {}

// Добавляем H3 для подзаголовков статей
class SemanticH3 extends SemanticWidget {
  const SemanticH3(String text, {super.key}) : super(tag: 'h3', text: text);
  @override
  State<SemanticH3> createState() => _SemanticH3State();
}

class _SemanticH3State extends _SemanticWidgetState<SemanticH3> {}

// Создаем удобную обертку SemanticLink (по сути это ваш SemanticA, но с понятным названием)
class SemanticLink extends SemanticWidget {
  SemanticLink({super.key, required super.text, required String href})
      : super(tag: 'a', attributes: {'href': href});
  @override
  State<SemanticLink> createState() => _SemanticLinkState();
}

class _SemanticLinkState extends _SemanticWidgetState<SemanticLink> {}

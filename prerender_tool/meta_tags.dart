import 'dart:convert';

/// Copies the metadata that Flutter updated at runtime into the generated HTML
/// while keeping the scripts and other static head content from web/index.html.
String applyPrerenderedMetadata(
  String html,
  String metadataJson, {
  required String canonicalUrl,
}) {
  final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
  var result = html;

  final title = metadata['title'] as String?;
  if (title != null && title.isNotEmpty) {
    result = result.replaceFirstMapped(
      RegExp(r'<title\b[^>]*>[\s\S]*?</title>', caseSensitive: false),
      (match) => '<title>${_escapeHtmlText(title)}</title>',
    );
  }

  final metaTitle = metadata['metaTitle'] as String?;
  if (metaTitle != null && metaTitle.isNotEmpty) {
    result = _replaceMetaContent(result, 'name', 'title', metaTitle);
  }

  final description = metadata['description'] as String?;
  if (description != null && description.isNotEmpty) {
    result = _replaceMetaContent(result, 'name', 'description', description);
  }

  final openGraphTitle = metadata['openGraphTitle'] as String?;
  if (openGraphTitle != null && openGraphTitle.isNotEmpty) {
    result =
        _replaceMetaContent(result, 'property', 'og:title', openGraphTitle);
  }

  final openGraphDescription = metadata['openGraphDescription'] as String?;
  if (openGraphDescription != null && openGraphDescription.isNotEmpty) {
    result = _replaceMetaContent(
        result, 'property', 'og:description', openGraphDescription);
  }

  final openGraphImage = metadata['openGraphImage'] as String?;
  if (openGraphImage != null && openGraphImage.isNotEmpty) {
    result =
        _replaceMetaContent(result, 'property', 'og:image', openGraphImage);
  }

  result = _replaceMetaContent(result, 'property', 'og:url', canonicalUrl);
  return _replaceCanonicalLink(result, canonicalUrl);
}

String _replaceCanonicalLink(String html, String canonicalUrl) {
  final canonicalPattern = RegExp(
    r'''<link\b(?=[^>]*\brel\s*=\s*(["'])canonical\1)[^>]*>''',
    caseSensitive: false,
  );
  final hrefPattern = RegExp(r'''(\bhref\s*=\s*)(["'])(.*?)\2''',
      caseSensitive: false, dotAll: true);
  final canonicalMatch = canonicalPattern.firstMatch(html);

  if (canonicalMatch != null) {
    final tag = canonicalMatch.group(0)!;
    final hrefMatch = hrefPattern.firstMatch(tag);
    final updatedTag = hrefMatch == null
        ? tag.replaceFirst(
            '>', ' href="${_escapeHtmlAttribute(canonicalUrl)}">')
        : tag.replaceRange(
            hrefMatch.start,
            hrefMatch.end,
            '${hrefMatch.group(1)}${hrefMatch.group(2)}${_escapeHtmlAttribute(canonicalUrl)}${hrefMatch.group(2)}',
          );
    return html.replaceRange(
        canonicalMatch.start, canonicalMatch.end, updatedTag);
  }

  return html.replaceFirstMapped(
    RegExp(r'</head>', caseSensitive: false),
    (match) =>
        '<link rel="canonical" href="${_escapeHtmlAttribute(canonicalUrl)}">\n${match[0]}',
  );
}

String _replaceMetaContent(
  String html,
  String selectorAttribute,
  String selectorValue,
  String content,
) {
  final selectorPattern = RegExp(
    '''(?:^|\\s)${RegExp.escape(selectorAttribute)}\\s*=\\s*(?:"${RegExp.escape(selectorValue)}"|'${RegExp.escape(selectorValue)}')''',
    caseSensitive: false,
  );
  final contentPattern = RegExp(r'''(\bcontent\s*=\s*)(["'])(.*?)\2''',
      caseSensitive: false, dotAll: true);

  for (final tagMatch
      in RegExp(r'<meta\b[^>]*>', caseSensitive: false).allMatches(html)) {
    final tag = tagMatch.group(0)!;
    if (!selectorPattern.hasMatch(tag)) continue;

    final contentMatch = contentPattern.firstMatch(tag);
    if (contentMatch == null) return html;

    final quote = contentMatch.group(2)!;
    final escapedContent = _escapeHtmlAttribute(content);
    final updatedTag = tag.replaceRange(
      contentMatch.start,
      contentMatch.end,
      '${contentMatch.group(1)}$quote$escapedContent$quote',
    );
    return html.replaceRange(tagMatch.start, tagMatch.end, updatedTag);
  }

  return html;
}

String _escapeHtmlText(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

String _escapeHtmlAttribute(String value) =>
    _escapeHtmlText(value).replaceAll('"', '&quot;').replaceAll("'", '&#39;');

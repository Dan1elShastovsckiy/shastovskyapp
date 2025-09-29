// /lib/pages/page_copyright.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart' hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';

class CopyrightPage extends StatelessWidget {
  static const String name = 'copyright';
  const CopyrightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    const licenseText = '''
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.
''';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: MaxWidthBox(
            maxWidth: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Copyright"),
                ]),
                const SizedBox(height: 40),
                Text("Copyright & License", style: headlineTextStyle(context)),
                const SizedBox(height: 24),
                SelectableText(
                    "Copyright (C) 2025 Daniil Shastovskii <shastovsckiy@ya.ru>",
                    style: bodyTextStyle(context)),
                const SizedBox(height: 24),
                SelectableText(licenseText,
                    style: bodyTextStyle(context)
                        .copyWith(fontFamily: 'monospace', height: 1.5)),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: bodyTextStyle(context),
                    children: [
                      const TextSpan(
                          text:
                              "Полный текст лицензии доступен на официальном сайте: "),
                      TextSpan(
                        text: "wtfpl.net",
                        style: bodyTextStyle(context).copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://www.wtfpl.net/about/')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                divider(context),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

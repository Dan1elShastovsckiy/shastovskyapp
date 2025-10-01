// /lib/pages/page_copyright.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';

class CopyrightPage extends StatelessWidget {
  static const String name = 'copyright';
  const CopyrightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    const licenseText = '''
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
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
                              "You may obtain a copy of the License at / Полный текст лицензии доступен на официальном сайте: "),
                      TextSpan(
                        text: "apache.org",
                        style: bodyTextStyle(context).copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(Uri.parse(
                              'http://www.apache.org/licenses/LICENSE-2.0')),
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

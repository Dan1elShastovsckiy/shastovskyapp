// lib/pages/page_contacts.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:minimal/utils/meta_tag_service.dart';

class ContactsPage extends StatefulWidget {
  static const String name = 'contacts';
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
        title: "Контакты | Даниил Шастовский",
        description:
            "Контакты для сотрудничества. Email, Telegram, WhatsApp и ссылки на все мои профили в социальных сетях.",
        imageUrl:
            "https://shastovsky.ru/assets/assets/images/avatar_default.png");
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String url,
    Widget? subtitle,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 300,
      height: 80,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: theme.colorScheme.onSurface, size: 32),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                subtitle,
              ]
            ],
          ),
        ),
        style: elevatedButtonStyle(context).copyWith(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          alignment: Alignment.centerLeft,
        ),
        onPressed: () => launchUrl(Uri.parse(url)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);
    final horizontalPadding =
        ResponsiveValue(context, defaultValue: 24.0, conditionalValues: [
      const Condition.largerThan(name: TABLET, value: 48.0),
    ]).value;

    Widget subtitleForbidden = Text(
      'Запрещенная в РФ организация',
      style: TextStyle(fontSize: 10, color: theme.colorScheme.secondary),
    );

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: MaxWidthBox(
                maxWidth: 1200,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text("Мои контакты",
                        style: headlineTextStyle(context).copyWith(
                            fontSize: ResponsiveValue(context,
                                defaultValue: 30.0,
                                conditionalValues: [
                              const Condition.largerThan(name: TABLET, value: 36.0)
                            ]).value)),
                    const SizedBox(height: 8),
                    Text("Контакты для сотрудничества",
                        style:
                            subtitleTextStyle(context).copyWith(fontSize: 18)),
                    const SizedBox(height: 40),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Text("📱",
                                style: TextStyle(fontSize: 32)),
                            title: Text(
                              "+7 991 *** ** 92",
                              style: headlineSecondaryTextStyle(context)
                                  .copyWith(fontSize: 24),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  backgroundColor: theme.colorScheme.surface,
                                  title: Text("Телефон для связи",
                                      style: headlineSecondaryTextStyle(
                                          dialogContext)),
                                  content: SelectableText(
                                    "+7 991 681-84-92",
                                    style: headlineSecondaryTextStyle(
                                            dialogContext)
                                        .copyWith(fontSize: 24),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text("Закрыть"),
                                    ),
                                    TextButton(
                                      onPressed: () => launchUrl(
                                          Uri.parse('tel:+79916818492')),
                                      child: const Text("Позвонить"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Text("💬",
                                style: TextStyle(fontSize: 32)),
                            title: Text(
                              "+7 991 *** ** 92",
                              style: headlineSecondaryTextStyle(context)
                                  .copyWith(fontSize: 24),
                            ),
                            subtitle: Text(
                              "WhatsApp",
                              style: subtitleTextStyle(context).copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  backgroundColor: theme.colorScheme.surface,
                                  title: Text("WhatsApp",
                                      style: headlineSecondaryTextStyle(
                                          dialogContext)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SelectableText(
                                        "+7 991 681-84-92",
                                        style: headlineSecondaryTextStyle(
                                                dialogContext)
                                            .copyWith(fontSize: 24),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Вы можете написать мне в WhatsApp по этому номеру",
                                        style: bodyTextStyle(dialogContext),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text("Закрыть"),
                                    ),
                                    TextButton(
                                      onPressed: () => launchUrl(Uri.parse(
                                          'https://wa.me/79916818492')),
                                      child: const Text("Открыть WhatsApp"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Text("📧",
                                style: TextStyle(fontSize: 32)),
                            title: Text(
                              "shastovsckiy@gmail.com",
                              style: headlineSecondaryTextStyle(context)
                                  .copyWith(fontSize: 24),
                            ),
                            onTap: () => launchUrl(
                                Uri.parse('mailto:shastovsckiy@gmail.com')),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Text("💬",
                                style: TextStyle(fontSize: 32)),
                            title: Text(
                              "@switchleveler",
                              style:
                                  headlineSecondaryTextStyle(context).copyWith(
                                fontSize: 24,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () => launchUrl(
                                Uri.parse('https://t.me/switchleveler')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    divider(context),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      child: Text("Все остальные мои профили в сети:",
                          textAlign: TextAlign.center,
                          style: headlineSecondaryTextStyle(context)
                              .copyWith(fontSize: 28)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildSocialButton(
                            context: context,
                            label: "Telegram личный",
                            icon: Icons.telegram,
                            url: 'https://t.me/switchleveler',
                          ),
                          _buildSocialButton(
                            context: context,
                            label: "Telegram канал",
                            icon: Icons.campaign,
                            url: 'https://t.me/shastovscky',
                          ),
                          _buildSocialButton(
                            context: context,
                            label: 'Instagram',
                            icon: Icons.camera_alt,
                            url: 'https://instagram.com/yellolwapple',
                            subtitle: subtitleForbidden,
                          ),
                          _buildSocialButton(
                            context: context,
                            label: 'YouTube',
                            icon: Icons.smart_display_outlined,
                            url: 'https://www.youtube.com/@itsmyadv',
                            subtitle: subtitleForbidden,
                          ),
                          _buildSocialButton(
                            context: context,
                            label: "VC.RU",
                            icon: Icons.article_outlined,
                            url: 'https://vc.ru/id1145025',
                          ),
                          _buildSocialButton(
                            context: context,
                            label: 'LinkedIn',
                            icon: Icons.work,
                            url:
                                'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571',
                            subtitle: subtitleForbidden,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  divider(context),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

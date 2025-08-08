import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/color.dart';
import 'package:minimal/pages/page_about.dart';
import 'package:minimal/pages/page_portfolio.dart';
import 'package:minimal/pages/page_typography.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatelessWidget {
  static const String name = 'contacts';

  const ContactsPage({super.key});

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
            ),
            child: Text(
              "SHASTOVSKY.",
              style: GoogleFonts.montserrat(
                color: textPrimary,
                fontSize: 24,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            title: const Text('ГЛАВНАЯ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          ListTile(
            title: const Text('ОБО МНЕ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AboutPage.name);
            },
          ),
          ListTile(
            title: const Text('ПОРТФОЛИО'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PortfolioPage.name);
            },
          ),
          ListTile(
            title: const Text('ОБ ЭТОМ САЙТЕ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, TypographyPage.name);
            },
          ),
          ListTile(
            title: const Text('КОНТАКТЫ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ContactsPage.name);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, String url) {
    return SizedBox(
      width: 300,
      height: 80,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.black, size: 32),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        ),
        onPressed: () => launchUrl(Uri.parse(url)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 410),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: marginBottom12,
                  child: Text(" ", style: headlineTextStyle),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: marginBottom40,
                  child: Column(
                    children: [
                      Text("Мои контакты",
                          style: headlineTextStyle.copyWith(fontSize: 36)),
                      const SizedBox(height: 8),
                      Text("Контакты для сотрудничества",
                          style: subtitleTextStyle.copyWith(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  margin: marginBottom40,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Text(
                          "📱",
                          style: TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          "+7 991 *** ** 92",
                          style:
                              headlineSecondaryTextStyle.copyWith(fontSize: 24),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor:
                                  Colors.white, // Белый фон всего меню
                              title: const Text("Телефон для связи"),
                              content: SelectableText(
                                "+7 991 681-84-92",
                                style: headlineSecondaryTextStyle.copyWith(
                                    fontSize: 24),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Закрыть"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      launchUrl(Uri.parse('tel:+79916818492')),
                                  child: const Text("Позвонить"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Text(
                          "💬",
                          style: TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          "+7 991 *** ** 92",
                          style:
                              headlineSecondaryTextStyle.copyWith(fontSize: 24),
                        ),
                        subtitle: Text(
                          "WhatsApp",
                          style: subtitleTextStyle.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor:
                                  Colors.white, // Белый фон всего меню
                              title: const Text("WhatsApp"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    "+7 991 681-84-92",
                                    style: headlineSecondaryTextStyle.copyWith(
                                        fontSize: 24),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Вы можете написать мне в WhatsApp по этому номеру",
                                    style: bodyTextStyle,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Закрыть"),
                                ),
                                TextButton(
                                  onPressed: () => launchUrl(
                                      Uri.parse('https://wa.me/79916818492')),
                                  child: const Text("Открыть WhatsApp"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Text(
                          "📧",
                          style: TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          "shastovsckiy@gmail.com",
                          style:
                              headlineSecondaryTextStyle.copyWith(fontSize: 24),
                        ),
                        onTap: () => launchUrl(
                            Uri.parse('mailto:shastovsckiy@gmail.com')),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Text(
                          "💬",
                          style: TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          "@switchleveler",
                          style: headlineSecondaryTextStyle.copyWith(
                            fontSize: 24,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () =>
                            launchUrl(Uri.parse('https://t.me/switchleveler')),
                      ),
                    ],
                  ),
                ),
              ),
              divider,
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: Text("Все остальные мои профили в сети:",
                      style: headlineSecondaryTextStyle.copyWith(fontSize: 28)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSocialButton(
                      "Telegram личный",
                      Icons.telegram,
                      'https://t.me/switchleveler',
                    ),
                    _buildSocialButton(
                      "Telegram канал",
                      Icons.campaign,
                      'https://t.me/shastovscky',
                    ),
                    _buildSocialButton(
                      "Instagram",
                      Icons.camera_alt,
                      'https://instagram.com/yellolwapple',
                    ),
                    _buildSocialButton(
                      "YouTube",
                      Icons.smart_display_outlined,
                      'https://www.youtube.com/@itsmyadv',
                    ),
                    _buildSocialButton(
                      "VC.RU",
                      Icons.article_outlined,
                      'https://vc.ru/id1145025',
                    ),
                    _buildSocialButton(
                      "LinkedIn",
                      Icons.work,
                      'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571',
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                divider,
                Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

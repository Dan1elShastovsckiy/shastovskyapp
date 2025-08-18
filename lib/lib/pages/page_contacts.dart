import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatelessWidget {
  static const String name = 'contacts';

  const ContactsPage({super.key});

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
      // Теперь buildAppDrawer берется из components.dart, и ошибки нет
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            isMobile ? 65 : 110), // Высота для десктопа исправлена
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
                    // --- Кнопки без подписи (остаются без изменений) ---
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

                    // --- Кнопки с подписью (модифицируем напрямую) ---

                    // Кнопка Instagram
                    SizedBox(
                      width: 300,
                      height: 80,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt,
                            color: Colors.black, size: 32),
                        label: Align(
                          // Выравниваем Column по левому краю
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Instagram',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Запрещенная в РФ организация',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                    ),

                    // Кнопка YouTube
                    SizedBox(
                      width: 300,
                      height: 80,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.smart_display_outlined,
                            color: Colors.black, size: 32),
                        label: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'YouTube',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Запрещенная в РФ организация',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://www.youtube.com/@itsmyadv')),
                      ),
                    ),

                    // Кнопка VC.RU (без подписи)
                    _buildSocialButton(
                      "VC.RU",
                      Icons.article_outlined,
                      'https://vc.ru/id1145025',
                    ),

                    // Кнопка LinkedIn
                    SizedBox(
                      width: 300,
                      height: 80,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.work,
                            color: Colors.black, size: 32),
                        label: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LinkedIn',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Запрещенная в РФ организация',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                      ),
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

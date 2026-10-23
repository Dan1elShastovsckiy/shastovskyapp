// lib/pages/page_leaderboard.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/models/score_entry.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/services/game_service.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatelessWidget {
  static const String name = 'leaderboard';
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final gameService = GameService();
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: MaxWidthBox(
          maxWidth: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(
                    text: "Змейка", routeName: '/${FaviSnakePage.name}'),
                BreadcrumbItem(text: "Таблица рекордов"),
              ]),
              const SizedBox(height: 40),
              Text("Таблица рекордов", style: headlineTextStyle(context)),
              const SizedBox(height: 8),
              Text("Лучшие игроки в Flutter Snake",
                  style: subtitleTextStyle(context)),
              const SizedBox(height: 40),
              if (!authService.isAuthenticated)
                Card(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Чтобы попасть в таблицу лидеров, необходимо войти в свой аккаунт.",
                          textAlign: TextAlign.center,
                          style: bodyTextStyle(context).copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/${LoginPage.name}');
                          },
                          child: const Text("Войти / Регистрация"),
                        ),
                      ],
                    ),
                  ),
                ),
              StreamBuilder<List<ScoreEntry>>(
                stream: gameService.getTopScores(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print("LEADERBOARD ERROR: ${snapshot.error}");
                    return const Card(
                      child: ListTile(
                        leading: Icon(Icons.error_outline, color: Colors.red),
                        title: Text("Ошибка загрузки рекордов"),
                        subtitle: Text("Пожалуйста, попробуйте позже"),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Card(
                      child: ListTile(
                        leading: Icon(Icons.leaderboard_outlined),
                        title: Text("Рекордов пока нет"),
                        subtitle: Text("Будьте первым!"),
                      ),
                    );
                  }

                  final scores = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final score = scores[index];
                      Color? rankColor;
                      if (index == 0) rankColor = Colors.amber.shade700;
                      if (index == 1) rankColor = Colors.grey.shade500;
                      if (index == 2) rankColor = Colors.brown.shade400;

                      final bool isCurrentUser = authService.isAuthenticated &&
                          authService.user!.uid == score.userId;

                      return Card(
                        elevation: isCurrentUser ? 4 : 1,
                        shape: isCurrentUser
                            ? RoundedRectangleBorder(
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2),
                                borderRadius: BorderRadius.circular(12),
                              )
                            : null,
                        child: ListTile(
                          leading: Text(
                            "#${index + 1}",
                            style: headlineSecondaryTextStyle(context).copyWith(
                              color: rankColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(score.userName,
                                  style: bodyTextStyle(context)
                                      .copyWith(fontWeight: FontWeight.bold)),
                              if (isCurrentUser)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.person,
                                      size: 16, color: Colors.blue),
                                ),
                            ],
                          ),
                          trailing: Text(
                            score.score.toString(),
                            style: headlineSecondaryTextStyle(context).copyWith(
                              color: rankColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 60),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.gamepad_outlined),
                  label: const Text("Вернуться к игре"),
                  style: elevatedButtonStyle(context),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${FaviSnakePage.name}');
                  },
                ),
              ),
              const SizedBox(height: 40),
              divider(context),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

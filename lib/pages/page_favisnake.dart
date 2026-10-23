// lib/pages/page_favisnake.dart

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/snake_game.dart';
import 'package:minimal/pages/page_account.dart';
import 'package:minimal/pages/page_leaderboard.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/services/game_service.dart';
import 'package:provider/provider.dart';

enum GameState { splash, running, gameOver }

class FaviSnakePage extends StatefulWidget {
  static const String name = 'fluttersnake';
  const FaviSnakePage({super.key});

  @override
  State<FaviSnakePage> createState() => _FaviSnakePageState();
}

class _FaviSnakePageState extends State<FaviSnakePage>
    with TickerProviderStateMixin {
  List<SnakeSegment> snake = [];
  Offset foodPosition = Offset.zero;
  List<Offset> obstacles = [];
  SnakeDirection direction = SnakeDirection.right;
  GameState gameState = GameState.splash;
  Timer? gameLoop;

  int score = 0;
  int level = 1;
  int highScore = 0;

  double gridSize = 20.0;
  Size gameAreaSize = Size.zero;
  int gridWidth = 0;
  int gridHeight = 0;

  late AnimationController _foodAnimationController;

  final GameService _gameService = GameService();
  final FocusNode _gameFocusNode = FocusNode();

  Offset _dragStartPos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _syncHighScore();
    _foodAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    _foodAnimationController.dispose();
    _gameFocusNode.dispose();
    super.dispose();
  }

  // <<< ИЗМЕНЕНИЕ 1: Полностью переработанный метод синхронизации >>>
  Future<void> _syncHighScore() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isAuthenticated) {
      // Если пользователь авторизован, получаем его лучший счет ИЗ ОБЛАКА
      final user = authService.user!;
      final cloudScoreEntry = await _gameService.getUserBestScore(user.uid);
      final cloudHighScore = cloudScoreEntry?.score ?? 0;

      if (mounted) {
        setState(() {
          // Устанавливаем highScore из Firestore
          highScore = cloudHighScore;
        });
      }
    } else {
      // Если не авторизован, его лучший счет всегда 0, так как мы не можем его хранить
      if (mounted) {
        setState(() {
          highScore = 0;
        });
      }
    }
  }

  // <<< ИЗМЕНЕНИЕ 2: Убираем SharedPreferences из сохранения >>>
  Future<void> _saveHighScore() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Просто обновляем highScore в UI, если текущий счет его побил
    if (score > highScore) {
      if (mounted) {
        setState(() {
          highScore = score;
        });
      }
    }

    // Сохраняем в Firestore, если пользователь авторизован
    if (authService.isAuthenticated) {
      final user = authService.user!;

      await _gameService.updateUserScore(
        userId: user.uid,
        userName: user.displayName ?? 'Аноним',
        newScore: score,
      );
    }
  }

  void _startGame() {
    FocusScope.of(context).requestFocus(_gameFocusNode);
    setState(() {
      score = 0;
      level = 1;
      direction = SnakeDirection.right;
      obstacles.clear();
      snake = [
        SnakeSegment(Offset(
            (gridWidth / 2).floorToDouble(), (gridHeight / 2).floorToDouble())),
        SnakeSegment(Offset((gridWidth / 2).floorToDouble() - 1,
            (gridHeight / 2).floorToDouble())),
      ];
      _generateFood();
      gameState = GameState.running;
    });

    gameLoop?.cancel();
    gameLoop = Timer.periodic(_getGameSpeed(), (timer) {
      if (mounted) {
        _updateGame();
      }
    });
  }

  Duration _getGameSpeed() {
    int speed = 200 - (level * 15);
    return Duration(milliseconds: speed < 50 ? 50 : speed);
  }

  void _generateObstacles() {
    setState(() {
      obstacles.clear();
      int obstacleCount = (level - 1) * 2;
      final random = Random();

      for (int i = 0; i < obstacleCount; i++) {
        Offset newObstacle;
        do {
          newObstacle = Offset(
            random.nextInt(gridWidth).toDouble(),
            random.nextInt(gridHeight).toDouble(),
          );
        } while (snake.any((s) => (s.position - newObstacle).distance < 5) ||
            (foodPosition - newObstacle).distance < 5);
        obstacles.add(newObstacle);
      }
    });
  }

  void _generateFood() {
    final random = Random();
    Offset newFoodPosition;
    do {
      newFoodPosition = Offset(
        random.nextInt(gridWidth).toDouble(),
        random.nextInt(gridHeight).toDouble(),
      );
    } while (snake.any((segment) => segment.position == newFoodPosition) ||
        obstacles.any((obs) => obs == newFoodPosition));

    if (mounted) {
      setState(() {
        foodPosition = newFoodPosition;
      });
    }
  }

  void _updateGame() {
    if (gameState != GameState.running || !mounted) return;

    setState(() {
      final newHeadPosition = _getNewHeadPosition();
      final finalHeadPosition = Offset(
        (newHeadPosition.dx + gridWidth) % gridWidth,
        (newHeadPosition.dy + gridHeight) % gridHeight,
      );

      if (snake.any((segment) => segment.position == finalHeadPosition) ||
          obstacles.any((obs) => obs == finalHeadPosition)) {
        _gameOver();
        return;
      }

      final newHead = SnakeSegment(finalHeadPosition);
      snake.insert(0, newHead);

      if (newHead.position == foodPosition) {
        score++;
        if (score % 5 == 0 && score > 0) {
          level++;
          _generateObstacles();
          gameLoop?.cancel();
          gameLoop = Timer.periodic(_getGameSpeed(), (timer) {
            if (mounted) _updateGame();
          });
        }
        _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  Offset _getNewHeadPosition() {
    final headPosition = snake.first.position;
    switch (direction) {
      case SnakeDirection.up:
        return Offset(headPosition.dx, headPosition.dy - 1);
      case SnakeDirection.down:
        return Offset(headPosition.dx, headPosition.dy + 1);
      case SnakeDirection.left:
        return Offset(headPosition.dx - 1, headPosition.dy);
      case SnakeDirection.right:
        return Offset(headPosition.dx + 1, headPosition.dy);
    }
  }

  void _onKeyPressed(RawKeyEvent event) {
    if (event is RawKeyDownEvent && gameState == GameState.running) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
          direction != SnakeDirection.down) {
        direction = SnakeDirection.up;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
          direction != SnakeDirection.up) {
        direction = SnakeDirection.down;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          direction != SnakeDirection.right) {
        direction = SnakeDirection.left;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          direction != SnakeDirection.left) {
        direction = SnakeDirection.right;
      }
    }
  }

  void _gameOver() {
    gameLoop?.cancel();
    _saveHighScore();
    if (mounted) {
      setState(() {
        gameState = GameState.gameOver;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: RawKeyboardListener(
        focusNode: _gameFocusNode,
        autofocus: true,
        onKey: _onKeyPressed,
        child: GestureDetector(
          onPanStart: (details) {
            _dragStartPos = details.globalPosition;
          },
          onPanUpdate: (details) {
            if (gameState != GameState.running) return;

            final delta = details.globalPosition - _dragStartPos;
            const double moveThreshold = 20.0;

            if (delta.distance < moveThreshold) return;

            if (delta.dx.abs() > delta.dy.abs()) {
              if (delta.dx > 0 && direction != SnakeDirection.left) {
                direction = SnakeDirection.right;
              } else if (delta.dx < 0 && direction != SnakeDirection.right) {
                direction = SnakeDirection.left;
              }
            } else {
              if (delta.dy > 0 && direction != SnakeDirection.up) {
                direction = SnakeDirection.down;
              } else if (delta.dy < 0 && direction != SnakeDirection.down) {
                direction = SnakeDirection.up;
              }
            }
            _dragStartPos = details.globalPosition;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              gameAreaSize = Size(constraints.maxWidth, constraints.maxHeight);
              gridWidth = (gameAreaSize.width / gridSize).floor();
              gridHeight = (gameAreaSize.height / gridSize).floor();

              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Stack(
                  children: [
                    ...obstacles.map((pos) => Positioned(
                          left: pos.dx * gridSize,
                          top: pos.dy * gridSize,
                          child: CustomPaint(
                            painter: ObstaclePainter(
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade400),
                            size: Size(gridSize, gridSize),
                          ),
                        )),
                    ...snake.map((segment) => Positioned(
                          left: segment.position.dx * gridSize,
                          top: segment.position.dy * gridSize,
                          child: CustomPaint(
                            painter: SnakeSegmentPainter(
                              segment == snake.first
                                  ? Colors.greenAccent
                                  : Colors.green,
                            ),
                            size: Size(gridSize, gridSize),
                          ),
                        )),
                    if (gameState == GameState.running)
                      Positioned(
                        left: foodPosition.dx * gridSize,
                        top: foodPosition.dy * gridSize,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0)
                              .animate(_foodAnimationController),
                          child: CustomPaint(
                            painter: FoodPainter(Colors.redAccent),
                            size: Size(gridSize, gridSize),
                          ),
                        ),
                      ),
                    if (gameState == GameState.splash) _buildSplashOverlay(),
                    if (gameState == GameState.gameOver)
                      _buildGameOverOverlay(),
                    if (gameState == GameState.running)
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          "СЧЕТ: $score  |  УРОВЕНЬ: $level",
                          style: bodyTextStyle(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2),
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSplashOverlay() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter Snake",
              style: headlineTextStyle(context).copyWith(
                  color: Theme.of(context).textTheme.displayLarge?.color,
                  fontSize: 50),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text("Ваш лучший счет: $highScore",
                style: subtitleTextStyle(context).copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color)),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  style: elevatedButtonStyle(context),
                  onPressed: _startGame,
                  child: const Text("Начать игру"),
                ),
                ElevatedButton(
                  style: elevatedButtonStyle(context).copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.blueGrey)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${LeaderboardPage.name}');
                  },
                  child: const Text("Рекорды"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Игра окончена",
              style: headlineTextStyle(context).copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.redAccent
                      : Theme.of(context).textTheme.displayLarge?.color,
                  fontSize: 50),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Ваш счет: $score",
              style: subtitleTextStyle(context).copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              "Лучший счет: $highScore",
              style: subtitleTextStyle(context).copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  style: elevatedButtonStyle(context),
                  onPressed: _startGame,
                  child: const Text("Играть снова"),
                ),
                ElevatedButton(
                  style: elevatedButtonStyle(context).copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.blueGrey)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${LeaderboardPage.name}');
                  },
                  child: const Text("Рекорды"),
                ),
                if (authService.isAuthenticated)
                  ElevatedButton(
                    style: elevatedButtonStyle(context).copyWith(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.blueGrey.shade700)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/${AccountPage.name}');
                    },
                    child: const Text("В личный кабинет"),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

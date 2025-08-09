// lib/pages/page_post.dart

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPage extends StatefulWidget {
  static const String name = 'marocco';

  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // Список всех изображений на странице для предварительного кэширования
  final List<String> _pageImages = [
    "assets/images/me_sachara_desert.jpg",
    "assets/images/marocco/IMG_4129.webp",
    "assets/images/marocco/IMG_9519.webp",
    "assets/images/marocco/IMG_9524.webp",
    "assets/images/marocco/IMG_0366.webp",
    "assets/images/marocco/camphoto_1804928587.webp",
    "assets/images/marocco/IMG_9542.webp",
    "assets/images/marocco/IMG_9536.webp",
    "assets/images/marocco/IMG_2766.webp",
    "assets/images/marocco/IMG_2834.webp",
    "assets/images/marocco/IMG_2824.webp",
    "assets/images/marocco/IMG_0134.webp",
    "assets/images/marocco/IMG_0389.webp",
    "assets/images/marocco/IMG_0547.webp",
    "assets/images/marocco/IMG_0455.webp",
    "assets/images/marocco/IMG_3255.webp",
    "assets/images/marocco/IMG_1394.webp",
    "assets/images/marocco/IMG_0693.webp",
    "assets/images/marocco/IMG_0694.webp",
    "assets/images/marocco/IMG_0873.webp",
    "assets/images/marocco/IMG_3426.webp",
    "assets/images/marocco/IMG_3532.webp",
    "assets/images/marocco/IMG_3883.webp",
    "assets/images/marocco/IMG_1105.webp",
    "assets/images/marocco/IMG_3927.webp",
    "assets/images/marocco/IMG_1112.webp",
    "assets/images/marocco/IMG_1114.webp",
    "assets/images/marocco/IMG_1119.webp",
    "assets/images/marocco/IMG_1250.webp",
    "assets/images/marocco/IMG_1254.webp",
    "assets/images/marocco/IMG_1262.webp",
    "assets/images/marocco/IMG_1272.webp",
    "assets/images/marocco/IMG_0889.webp",
    "assets/images/marocco/IMG_0959.webp",
    "assets/images/marocco/IMG_4232.webp",
    "assets/images/marocco/IMG_1419.webp",
    "assets/images/marocco/IMG_1427.webp",
    "assets/images/avatar_default.png",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Предварительное кэширование всех изображений для улучшения производительности
    for (final imagePath in _pageImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  // НОВЫЙ ВИДЖЕТ-ХЕЛПЕР ДЛЯ БОЛЬШОЙ КНОПКИ
  Widget _buildDownloadWallpaperButton() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
        constraints: const BoxConstraints(maxWidth: 700),
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.phone_iphone_rounded,
              color: Color.fromARGB(255, 0, 0, 0), size: 32),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Скачать мою подборку обоев на телефон с этой поездки бесплатно",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.5),
            // <<< ЭТА СТРОКА ДЛЯ ОБВОДКИ >>>
            side: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          onPressed: () =>
              launchUrl(Uri.parse('assets/marocco_photos_pack.zip')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            // Главная карусель с фото пустыни
            const ImageCarousel(images: [
              "assets/images/me_sachara_desert.jpg",
              "assets/images/marocco/IMG_4129.webp",
              "assets/images/marocco/IMG_9519.webp",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom12,
                child: Text(
                  "МАРОККО: Заблудиться, чтобы найти себя в сердце пустоты",
                  style: headlineTextStyle,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBodySecondary(text: "Главная  /  Марокко"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Салам алейкум, странники! ✋ Вернулся из Марокко, и до сих пор отряхиваю песок Сахары из кроссовок и, кажется, ноутбука. Это не был отпуск в классическом понимании. Это был интенсив под названием «Марокко: Режим Выживания», который неожиданно перерос в откровение. Хотите маршрут, полный острых ощущений и настоящей пустыни? Добро пожаловать!",
              ),
            ),

            // <<< ПЕРВАЯ КНОПКА ЗДЕСЬ >>>
            _buildDownloadWallpaperButton(),

            // Акт 1: Касабланка
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text:
                      "Акт 1: Касабланка - такси, тьма и первый глоток воздуха"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "18 мая. Приземлились в аэропорту Мохаммеда V, Касабланка. Первая битва: такси. Индрайв? Теоретически работает! Практика: водителя «прижали» местные полицейские, итоговая цена скакнула втрое. «Электричка удобная!» – гласил интернет. Мы вышли за пределы аэропорта... нас пешком повели обратно к парковке таксистов. Welcome to Morocco!",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_9519.webp",
              "assets/images/marocco/IMG_9524.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Первый ночлег – Hotel Suisse за 31€/ночь: крошечный номер, зеркало, кровать, душ-кабина. Рай после битвы за такси. Поиск ужина – квест: 40 минут по улицам возле бульвара Мохаммеда V и района Айн Диаб, сплошные закрытые кафе или места только с кофе. Спасение – местный магазин Marjane.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Зато утро открыло другую Касу: прогулка по парку Арабской Лиги и набережной Корниш – город современный, динамичный, много молодежи и детей. Первый свет!",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_0366.webp",
              "assets/images/marocco/camphoto_1804928587.webp",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // ... прочий контент ...

            // <<< ВТОРАЯ КНОПКА ЗДЕСЬ >>>
            _buildDownloadWallpaperButton(),

            // Роудтрип
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(text: "Эпичный роудтрип"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Арендовали машину в соседнем городке Риссани (через отель). Маршрут на 2 дня:",
              ),
            ),
            // ... прочий контент ...

            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Бонус: На трассе N10 нас остановили местные полицейские. Формально – за неполную остановку перед стоп-линией (жест регулировщика был неясен). Неформально – намек на «решение вопроса на месте». «Добровольный штраф» в 150 дирхам сработал быстрее официальной квитанции. Местный колорит.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_0889.webp",
              "assets/images/marocco/IMG_0959.webp",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // ... остальная часть статьи ...

            const ImageCarousel(images: [
              "assets/images/marocco/IMG_1427.webp",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // <<< ТРЕТЬЯ КНОПКА ЗДЕСЬ >>>
            _buildDownloadWallpaperButton(),

            // Теги и P.S.
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Путешествия"),
                Tag(tag: "Марокко"),
                Tag(tag: "Сахара"),
                Tag(tag: "Приключения"),
                Tag(tag: "Роудтрип"),
              ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom24,
                child: Text("P.S.", style: subtitleTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom40,
                child: RichText(
                  text: TextSpan(
                    style: bodyTextStyle,
                    children: [
                      const TextSpan(
                        text:
                            "Если вам понравился этот сайт или то, что я делаю - вы можете поддержать меня в моем телеграм канале ",
                      ),
                      TextSpan(
                        text: "@shastovscky",
                        style: bodyTextStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              launchUrl(Uri.parse('https://t.me/shastovscky')),
                      ),
                      const TextSpan(
                        text: " или подписаться на меня в инстаграм ",
                      ),
                      TextSpan(
                        text: "@yellolwapple",
                        style: bodyTextStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                      const TextSpan(
                        text: " в нем я делюсь фото и видео из своих поездок.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // кнопки соц.сетей (СТАРАЯ КНОПКА УДАЛЕНА)
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              width: double.infinity,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.telegram, color: Colors.black),
                        label: const Text('Telegram личный'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/switchleveler')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.campaign, color: Colors.black),
                        label: const Text('Telegram канал'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/shastovscky')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        label: const Text('Instagram'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.work, color: Colors.black),
                        label: const Text('LinkedIn'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.smart_display_outlined,
                            color: Colors.black),
                        label: const Text('YouTube'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://www.youtube.com/@itsmyadv')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.article_outlined,
                            color: Colors.black),
                        label: const Text('VC.RU'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://vc.ru/id1145025')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...authorSection(
                imageUrl: "assets/images/avatar_default.png",
                name: "Автор: Я, Шастовский Даниил",
                bio:
                    "Автор этого сайта, аналитик, фотограф, путешественник и просто хороший человек. Я люблю делиться своими впечатлениями и фотографиями из поездок по всему миру."),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: const PostNavigation(),
            ),
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(
                maxWidth: 1200,
                backgroundColor: Colors.white,
                child: Container()),
          ),
          ...[
            divider,
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}

// ... (Код виджета ImageCarousel остается без изменений) ...

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  const ImageCarousel({super.key, required this.images});
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _controller;
  int _currentPage = 0;
  bool _showButtons = false;
  Timer? _autoPlayTimer;
  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.images.length <= 1) return;
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) return;
      if (_currentPage < widget.images.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _controller.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!mounted) return;
        setState(() => _showButtons = true);
        _stopAutoPlay();
      },
      onExit: (_) {
        if (!mounted) return;
        setState(() => _showButtons = false);
        _startAutoPlay();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  if (!mounted) return;
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    panEnabled: false,
                    boundaryMargin: const EdgeInsets.all(20),
                    minScale: 1,
                    maxScale: 3,
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        return Container(
                          color: Colors.grey[200],
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('Ошибка загрузки изображения',
                              style: TextStyle(color: Colors.red)),
                        );
                      },
                    ),
                  );
                },
              ),
              if (widget.images.length > 1)
                AnimatedOpacity(
                  opacity: _showButtons ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: _currentPage > 0
                          ? () {
                              _controller.animateToPage(
                                _currentPage - 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                    ),
                  ),
                ),
              if (widget.images.length > 1)
                AnimatedOpacity(
                  opacity: _showButtons ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: _currentPage < widget.images.length - 1
                          ? () {
                              _controller.animateToPage(
                                _currentPage + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                    ),
                  ),
                ),
              if (widget.images.length > 1)
                Positioned(
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.images.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

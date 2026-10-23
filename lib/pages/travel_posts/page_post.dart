// lib/pages/page_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/comments_section.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/reactions_widget.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/utils/meta_tag_service.dart'; // Импортируем MetaTagService
// <<< ШАГ 1: Добавляем импорт семантических виджетов >>>
import 'package:minimal/components/semantic_widgets.dart';

class PostPage extends StatefulWidget {
  static const String name = 'marocco';

  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // Список всех изображений на странице для предварительного кэширования
  final List<String> _pageImages = [
    "assets/images/me_sachara_desert.webp",
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
    "assets/images/avatar_default.webp",
  ];

  // <<< ШАГ 2: Добавляем флаг для определения режима рендеринга >>>
  bool _isPrerendering = false;

  String _getThumbPath(String fullPath) {
    final int extensionIndex = fullPath.lastIndexOf('.webp');
    if (extensionIndex == -1) return fullPath;
    return '${fullPath.substring(0, extensionIndex)}_thumb.webp';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final fullImagePath in _pageImages) {
      final thumbPath = _getThumbPath(fullImagePath);
      precacheImage(AssetImage(thumbPath), context);
    }
  }

  @override
  void initState() {
    super.initState();
    // <<< ШАГ 3: Проверяем URL на наличие параметра пререндеринга >>>
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }

    MetaTagService().updateAllTags(
      title:
          "МАРОККО: Заблудиться, чтобы найти себя | Блог Даниила Шастовского",
      description:
          "История о том, как я потерялся в лабиринте улиц Марокко. Ароматы специй, крики зазывал, скрытые риады и сердце пустыни Сахара.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/me_sachara_desert.webp",
    );
  }

  // <<< ШАГ 4: Новый метод для генерации семантического контента >>>
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("МАРОККО: Заблудиться, чтобы найти себя в сердце пустоты"),
        SemanticImg(
            src: "assets/images/me_sachara_desert.webp",
            alt: "Автор в пустыне Сахара"),
        SemanticP(
            "Салам алейкум, странники! ✋ Вернулся из Марокко, и до сих пор отряхиваю песок Сахары из кроссовок и, кажется, ноутбука. Это не был отпуск в классическом понимании. Это был интенсив под названием «Марокко: Режим Выживания», который неожиданно перерос в откровение. Хотите маршрут, полный острых ощущений и настоящей пустыни? Добро пожаловать!"),
        SemanticH2("Акт 1: Касабланка - такси, тьма и первый глоток воздуха"),
        SemanticP(
            "18 мая. Приземлились в аэропорту Мохаммеда V, Касабланка. Первая битва: такси. Индрайв? Теоретически работает! Практика: водителя «прижали» местные полицейские, итоговая цена скакнула втрое. «Электричка удобная!» – гласил интернет. Мы вышли за пределы аэропорта... нас пешком повели обратно к парковке таксистов. Welcome to Morocco!"),
        SemanticImg(
            src: "assets/images/marocco/IMG_9519.webp",
            alt: "Вид на Касабланку"),
        SemanticP(
            "Первый ночлег – Hotel Suisse за 31€/ночь: крошечный номер, зеркало, кровать, душ-кабина. Рай после битвы за такси. Поиск ужина – квест: 40 минут по улицам возле бульвара Мохаммеда V и района Айн Диаб, сплошные закрытые кафе или места только с кофе. Спасение – местный магазин Marjane."),
        SemanticP(
            "Зато утро открыло другую Касу: прогулка по парку Арабской Лиги и набережной Корниш – город современный, динамичный, много молодежи и детей. Первый свет!"),
        SemanticImg(
            src: "assets/images/marocco/IMG_0366.webp",
            alt: "Парк Арабской Лиги"),
        SemanticH2("Акт 2: Танжер – Гибралтар, Холод и Отельный Хаос"),
        SemanticImg(
            src: "assets/images/marocco/IMG_9542.webp",
            alt: "Вид на Гибралтар из Танжера"),
        SemanticP(
            "Переезд на поезде ONCF в Танжер – неожиданный восторг! Первый класс (билеты брали онлайн) – комфортные кресла с розетками, подножками. Почти как бизнес-класс в самолете. Прибыли на вокзал Танжер-Вилль. И тут – облом: Букинг внезапно списал 200€ и отменил мой отель."),
        SemanticP(
            "Итог: я в апартаментах Appartement Borj Darna в тихом спальном районе Бени Макада за 250€/5 ночей. Завтрак подпортил «масляный» сюрприз – купленный в местной булочной маргарин вместо масла. И да, «жаркая Африка»? 17°C, солнце светит, но не греет."),
        SemanticImg(
            src: "assets/images/marocco/IMG_2766.webp", alt: "Улицы Танжера"),
        SemanticP(
            "Зато исследование Медины и Касбы – огонь! Кафе Hafa с террасами над проливом – must-see. Свежевыжатый апельсиновый сок в уличной лавке – восторг! 🌞 Поездка к мысу Спартель и пещерам Геркулеса с видом на Гибралтар – мощно. Котики на байках – как в Турции!"),
        SemanticH2(
            "Акт 3: Путь в Сердце Пустоты – Мерзуга и Оазис по Цене Песка"),
        SemanticP(
            "Гонка продолжается! Поезд обратно в Касу, спешка в аэропорт Мохаммеда V. Чуть не опоздали: таксисты у вокзала запросили 300 дирхам до аэропорта, iN-Drive не работал (аккаунты заблокировали за частые отмены из-за неявки водителей!). Чудом поймали таксиста, который довез. И – сюрприз! Билеты Royal Air Maroc оказались в бизнес-классе (видимо, переоценка). Сок – средний, но лаунж – бесплатный бонус."),
        SemanticImg(
            src: "assets/images/marocco/IMG_0134.webp",
            alt: "Пустыня Сахара, Мерзуга"),
        SemanticP(
            "Прилетели в Эр-Рашидию. Жара! +30°C! Но впереди – трансфер на 2.5 часа вглубь Сахары, в деревню Мерзуга (окрестности Эрг-Шебби). В отель Auberge La Chance прибыли глубокой ночью. Выдох."),
        SemanticP(
            "Мерзуга: Наш оазис. Отель – простой, но с ГЕНИАЛЬНЫМ условием: полное включенное питание за 180€/14 ночей! Ресторан: стейки, бургеры, пицца, тажины, свежевыжатые соки – пиршество! Правда, администрация сначала «забыла» про это условие брони. Мы – те самые русские, кто «достучался». 😉"),
        SemanticH2("Сердцебиение Пустыни"),
        SemanticP(
            "Восхождение на высокие дюны Эрг-Шебби на закате. Вид на бескрайние пески – космос. Спуск под невероятным ковром звезд Млечного Пути – чистая медитация. Даже песчаная буря, настигшая на вершине – часть магии!"),
        SemanticImg(
            src: "assets/images/marocco/IMG_4129.webp", alt: "Дюны Эрг-Шебби"),
        SemanticP(
            "Деревенские открытия: Попытки купить настоящую джеллабу и ходули Алладина на местном базаре. Озеро Dayet Srji – сухое, с грустным рейтингом 3.6 «из-за отсутствия воды». Гениальный «душолет» в номере, который приходилось держать рукой (администрация так с этим ничего и не сделала-_-)."),
        SemanticH2("Эпичный роудтрип"),
        SemanticP(
            "Арендовали машину в соседнем городке Риссани (через отель). Маршрут на 2 дня:"),
        SemanticP(
            "День 1: Мерзуга → Уарзазат («Ворота Пустыни», киностолица Марокко) через долину Драа (оазисы, берберские деревни). По пути: каньон Тодра (Todra Gorge) – мощь скал! И каньон Дадес (Dades Gorge) – «Долина тысячи касб». Ночлег в Уарзазате. ~400 км + 30 км пешком по каньонам."),
        SemanticImg(
            src: "assets/images/marocco/IMG_0693.webp", alt: "Каньон Тодра"),
        SemanticP(
            "День 2: Уарзазат → Айт-Бен-Хадду (Aït Benhaddou) – легендарный укрепленный город (ксар), декорация к «Гладиатору», «Игре престолов». Затем – кульминация: Gsa Heaven (Gas Station Heaven) – заброшенная заправка и декорации к хоррору «У холмов есть глаза». Жутковато и атмосферно! Обратно в Мерзугу – еще ~500 км, приехали в 3 ночи. Адреналин! 🚗💨"),
        SemanticImg(
            src: "assets/images/marocco/IMG_1105.webp", alt: "Айт-Бен-Хадду"),
        SemanticP(
            "Бонус: На трассе N10 нас остановили местные полицейские. Формально – за неполную остановку перед стоп-линией (жест регулировщика был неясен). Неформально – намек на «решение вопроса на месте». «Добровольный штраф» в 150 дирхам сработал быстрее официальной квитанции. Местный колорит."),
        SemanticH2("Чудо Пустыни"),
        SemanticP(
            "Прямо рядом с отелем и на нас пошел дождь! Первый за 5 лет в этом месте, как сказали местные. Песчаные холмы под дождем – сюрреализм."),
        SemanticH2("Финал: Дорога Домой и Тишина после Бури"),
        SemanticP(
            "Выдвигались в 4 утра в аэропорт Эр-Рашидии. Он... закрыт. 2 часа сидели на чемоданах под звездами у темного терминала – апогей абсурда. Потом – досыпали на огромном ковре для молитв внутри."),
        SemanticImg(
            src: "assets/images/marocco/IMG_4232.webp",
            alt: "Аэропорт Эр-Рашидии"),
        SemanticP(
            "Перелет в Касу, и мои 12 часов ожидания в аэропорту перед рейсом Turkish Airlines домой через Стамбул. Время осмыслить."),
        SemanticH2("Что нашел в Сердце Пустоты?"),
        SemanticP(
            "Весь этот хаос – такси-квесты, отмены броней, штрафы, маргарин, холодный Танжер, песок в каждой щели, закрытые аэропорты, немыслимые перегоны по N9, N10, R703 – все это отпало, как шелуха, там, на дюне Эрг-Шебби, под звездами. Пустота не пугает – она очищает. Она стирает суету, обнажая суть: ты, ветер, песок, небо. И это – невероятная сила и покой."),
        SemanticP(
            "Марокко не пытался мне понравиться. Он был настоящим: колоритным, сложным, местами раздражающим, но безумно живым. И именно когда все шло «не по плану» – терялись билеты, штрафовали полицейские, закрывались аэропорты, шел дождь в Сахаре – случалось что-то настоящее, запоминающееся, настоящее путешествие."),
        SemanticP(
            "Заблудился ли я? Безусловно. В логистике, в ценах, в ожиданиях от погоды. Нашел ли себя? Кусочек – точно. Тот, что ценит простые вещи: вкусную еду после долгой дороги, звезды над Сахарой без светового шума, и ту самую глубокую тишину Пустоты, которая громче любых слов."),
        SemanticP(
            "Ехать в Марокко стоит не за лоском. Ехать стоит за ощущением. За тем, чтобы потеряться в хаосе и найти нечто большее в тишине пустыни. 🏜️"),
        SemanticImg(
            src: "assets/images/marocco/IMG_1427.webp", alt: "Закат в пустыне"),
      ],
    );
  }

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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            shadowColor: Colors.black.withAlpha(128),
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
    // <<< ШАГ 5: Добавляем условную логику в метод build >>>
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            const ImageCarousel(images: [
              "assets/images/me_sachara_desert.webp",
              "assets/images/marocco/IMG_4129.webp",
              "assets/images/marocco/IMG_9519.webp",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom12,
                child: Text(
                  "МАРОККО: Заблудиться, чтобы найти себя в сердце пустоты",
                  style: headlineTextStyle(context),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Марокко"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Салам алейкум, странники! ✋ Вернулся из Марокко, и до сих пор отряхиваю песок Сахары из кроссовок и, кажется, ноутбука. Это не был отпуск в классическом понимании. Это был интенсив под названием «Марокко: Режим Выживания», который неожиданно перерос в откровение. Хотите маршрут, полный острых ощущений и настоящей пустыни? Добро пожаловать!",
              ),
            ),
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
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text: "Акт 2: Танжер – Гибралтар, Холод и Отельный Хаос"),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_9542.webp",
              "assets/images/marocco/IMG_9536.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Переезд на поезде ONCF в Танжер – неожиданный восторг! Первый класс (билеты брали онлайн) – комфортные кресла с розетками, подножками. Почти как бизнес-класс в самолете. Прибыли на вокзал Танжер-Вилль. И тут – облом: Букинг внезапно списал 200€ и отменил мой отель.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Итог: я в апартаментах Appartement Borj Darna в тихом спальном районе Бени Макада за 250€/5 ночей. Завтрак подпортил «масляный» сюрприз – купленный в местной булочной маргарин вместо масла. И да, «жаркая Африка»? 17°C, солнце светит, но не греет.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_2766.webp",
              "assets/images/marocco/IMG_2834.webp",
              "assets/images/marocco/IMG_2824.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Зато исследование Медины и Касбы – огонь! Кафе Hafa с террасами над проливом – must-see. Свежевыжатый апельсиновый сок в уличной лавке – восторг! 🌞 Поездка к мысу Спартель и пещерам Геркулеса с видом на Гибралтар – мощно. Котики на байках – как в Турции!",
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text:
                      "Акт 3: Путь в Сердце Пустоты – Мерзуга и Оазис по Цене Песка"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Гонка продолжается! Поезд обратно в Касу, спешка в аэропорт Мохаммеда V. Чуть не опоздали: таксисты у вокзала запросили 300 дирхам до аэропорта, iN-Drive не работал (аккаунты заблокировали за частые отмены из-за неявки водителей!). Чудом поймали таксиста, который довез. И – сюрприз! Билеты Royal Air Maroc оказались в бизнес-классе (видимо, переоценка). Сок – средний, но лаунж – бесплатный бонус.",
              ),
            ),
            const ImageCarousel(
                images: ["assets/images/marocco/IMG_0134.webp"]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Прилетели в Эр-Рашидию. Жара! +30°C! Но впереди – трансфер на 2.5 часа вглубь Сахары, в деревню Мерзуга (окрестности Эрг-Шебби). В отель Auberge La Chance прибыли глубокой ночью. Выдох.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Мерзуга: Наш оазис. Отель – простой, но с ГЕНИАЛЬНЫМ условием: полное включенное питание за 180€/14 ночей! Ресторан: стейки, бургеры, пицца, тажины, свежевыжатые соки – пиршество! Правда, администрация сначала «забыла» про это условие брони. Мы – те самые русские, кто «достучался». 😉",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_0389.webp",
              "assets/images/marocco/IMG_0547.webp",
              "assets/images/marocco/IMG_0455.webp",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(text: "Сердцебиение Пустыни"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Восхождение на высокие дюны Эрг-Шебби на закате. Вид на бескрайние пески – космос. Спуск под невероятным ковром звезд Млечного Пути – чистая медитация. Даже песчаная буря, настигшая на вершине – часть магии!",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_4129.webp",
              "assets/images/marocco/IMG_3255.webp",
              "assets/images/marocco/IMG_1394.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Деревенские открытия: Попытки купить настоящую джеллабу и ходули Алладина на местном базаре. Озеро Dayet Srji – сухое, с грустным рейтингом 3.6 «из-за отсутствия воды». Гениальный «душолет» в номере, который приходилось держать рукой (администрация так с этим ничего и не сделала-_-).",
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
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
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "День 1: Мерзуга → Уарзазат («Ворота Пустыни», киностолица Марокко) через долину Драа (оазисы, берберские деревни). По пути: каньон Тодра (Todra Gorge) – мощь скал! И каньон Дадес (Dades Gorge) – «Долина тысячи касб». Ночлег в Уарзазате. ~400 км + 30 км пешком по каньонам.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_0693.webp",
              "assets/images/marocco/IMG_0694.webp",
              "assets/images/marocco/IMG_0873.webp",
              "assets/images/marocco/IMG_3426.webp",
              "assets/images/marocco/IMG_3532.webp",
              "assets/images/marocco/IMG_3883.webp",
              "assets/images/marocco/IMG_0873.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "День 2: Уарзазат → Айт-Бен-Хадду (Aït Benhaddou) – легендарный укрепленный город (ксар), декорация к «Гладиатору», «Игре престолов». Затем – кульминация: Gsa Heaven (Gas Station Heaven) – заброшенная заправка и декорации к хоррору «У холмов есть глаза». Жутковато и атмосферно! Обратно в Мерзугу – еще ~500 км, приехали в 3 ночи. Адреналин! 🚗💨",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_1105.webp",
              "assets/images/marocco/IMG_3927.webp",
              "assets/images/marocco/IMG_1112.webp",
              "assets/images/marocco/IMG_1114.webp",
              "assets/images/marocco/IMG_1119.webp",
              "assets/images/marocco/IMG_1250.webp",
              "assets/images/marocco/IMG_1254.webp",
              "assets/images/marocco/IMG_1262.webp",
              "assets/images/marocco/IMG_1272.webp",
            ]),
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
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(text: "Чудо Пустыни"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Прямо рядом с отелем и на нас пошел дождь! Первый за 5 лет в этом месте, как сказали местные. Песчаные холмы под дождем – сюрреализм.",
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text: "Финал: Дорога Домой и Тишина после Бури"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Выдвигались в 4 утра в аэропорт Эр-Рашидии. Он... закрыт. 2 часа сидели на чемоданах под звездами у темного терминала – апогей абсурда. Потом – досыпали на огромном ковре для молитв внутри.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_4232.webp",
              "assets/images/marocco/IMG_1419.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Перелет в Касу, и мои 12 часов ожидания в аэропорту перед рейсом Turkish Airlines домой через Стамбул. Время осмыслить.",
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(text: "Что нашел в Сердце Пустоты?"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Весь этот хаос – такси-квесты, отмены броней, штрафы, маргарин, холодный Танжер, песок в каждой щели, закрытые аэропорты, немыслимые перегоны по N9, N10, R703 – все это отпало, как шелуха, там, на дюне Эрг-Шебби, под звездами. Пустота не пугает – она очищает. Она стирает суету, обнажая суть: ты, ветер, песок, небо. И это – невероятная сила и покой.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Марокко не пытался мне понравиться. Он был настоящим: колоритным, сложным, местами раздражающим, но безумно живым. И именно когда все шло «не по плану» – терялись билеты, штрафовали полицейские, закрывались аэропорты, шел дождь в Сахаре – случалось что-то настоящее, запоминающееся, настоящее путешествие.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Заблудился ли я? Безусловно. В логистике, в ценах, в ожиданиях от погоды. Нашел ли себя? Кусочек – точно. Тот, что ценит простые вещи: вкусную еду после долгой дороги, звезды над Сахарой без светового шума, и ту самую глубокую тишину Пустоты, которая громче любых слов.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Ехать в Марокко стоит не за лоском. Ехать стоит за ощущением. За тем, чтобы потеряться в хаосе и найти нечто большее в тишине пустыни. 🏜️",
              ),
            ),
            const ImageCarousel(
                images: ["assets/images/marocco/IMG_1427.webp"]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle(context)),
              ),
            ),
            _buildDownloadWallpaperButton(),
            const Align(
              alignment: Alignment.center,
              child: Text("Как вам статья?", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            const Center(
              child: ReactionsWidget(
                articleRouteName: PostPage.name,
              ),
            ),
            const SizedBox(height: 60),
            divider(context),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            const ShareButtonsBlock(),
            const SizedBox(height: 40),
            const CommentsSection(
              articleRouteName: PostPage.name,
            ),
            const SizedBox(height: 60),
            const RelatedArticles(
              currentArticleRouteName: PostPage.name,
              category: 'travel',
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom24,
                child: Text("P.S.", style: subtitleTextStyle(context)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom40,
                child: RichText(
                  text: TextSpan(
                    style: bodyTextStyle(context),
                    children: [
                      const TextSpan(
                        text:
                            "Если вам понравился этот сайт или то, что я делаю - вы можете поддержать меня в моем телеграм канале ",
                      ),
                      TextSpan(
                        text: "@shastovscky",
                        style: bodyTextStyle(context).copyWith(
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
                        style: bodyTextStyle(context).copyWith(
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
                        icon: Icon(Icons.telegram,
                            color: theme.colorScheme.onSurface),
                        label: const Text('Telegram личный'),
                        style: elevatedButtonStyle(context),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/switchleveler')),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.campaign,
                            color: theme.colorScheme.onSurface),
                        label: const Text('Telegram канал'),
                        style: elevatedButtonStyle(context),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/shastovscky')),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.camera_alt,
                            color: theme.colorScheme.onSurface),
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Instagram'),
                            const SizedBox(height: 2),
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                        style: elevatedButtonStyle(context),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.work,
                            color: theme.colorScheme.onSurface),
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('LinkedIn'),
                            const SizedBox(height: 2),
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                        style: elevatedButtonStyle(context),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.smart_display_outlined,
                            color: theme.colorScheme.onSurface),
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('YouTube'),
                            const SizedBox(height: 2),
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                        style: elevatedButtonStyle(context),
                        onPressed: () => launchUrl(
                            Uri.parse('https://www.youtube.com/@itsmyadv')),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.article_outlined,
                            color: theme.colorScheme.onSurface),
                        label: const Text('VC.RU'),
                        style: elevatedButtonStyle(context),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://vc.ru/id1145025')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...authorSection(
                context: context,
                imageUrl: "assets/images/avatar_default.webp",
                name: "Автор: Я, Шастовский Даниил",
                bio:
                    "Автор этого сайта, аналитик, фотограф, путешественник и просто хороший человек. Я люблю делиться своими впечатлениями и фотографиями из поездок по всему миру."),
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(maxWidth: 1200, child: Container()),
          ),
          ...[
            divider(context),
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}

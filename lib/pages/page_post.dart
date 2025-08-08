import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/page_about.dart';
import 'package:minimal/pages/page_contacts.dart';
import 'package:minimal/pages/page_portfolio.dart';
import 'package:minimal/pages/page_typography.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPage extends StatelessWidget {
  static const String name = 'marocco';

  const PostPage({super.key});

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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 410),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            // Главная карусель с фото пустыни
            const ImageCarousel(images: [
              "assets/images/me_sachara_desert.jpg",
              "assets/images/marocco/IMG_4129.jpg",
              "assets/images/marocco/IMG_9519.jpg",
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
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Акт 1: Касабланка
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text:
                      "Акт 1: Касабланка – Такси, Тьма и Первый Глоток Воздуха"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "18 мая. Приземлились в аэропорту Мохаммеда V, Касабланка. Первая битва: такси. Индрайв? Теоретически работает! Практика: водителя «прижали» местные полицейские, итоговая цена скакнула втрое. «Электричка удобная!» – гласил интернет. Мы вышли за пределы аэропорта... нас пешком повели обратно к парковке таксистов. Welcome to Morocco!",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_9519.jpg",
              "assets/images/marocco/IMG_9524.jpg",
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
              "assets/images/marocco/IMG_0366.jpg",
              "assets/images/marocco/camphoto_1804928587.jpg",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Акт 2: Танжер
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text: "Акт 2: Танжер – Гибралтар, Холод и Отельный Хаос"),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_9542.jpg",
              "assets/images/marocco/IMG_9536.jpg",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Переезд на поезде ONCF в Танжер – неожиданный восторг! Первый класс (билеты брали онлайн) – комфортные кресла с розетками, подножками. Почти как бизнес-класс в самолете. Прибыли на вокзал Танжер-Вилль. И тут – облом: Букинг внезапно списал 200€ и отменил мой отель. У Ани бронь в Hotel el Minzah подтвердилась.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Итог: я в апартаментах Appartement Borj Darna в тихом спальном районе Бени Макада за 250€/5 ночей. Аня – в центре. Завтрак подпортил «масляный» сюрприз – купленный в местной булочной маргарин вместо масла. И да, «жаркая Африка»? 17°C, солнце светит, но не греет.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_2766.jpg",
              "assets/images/marocco/IMG_2834.jpg",
              "assets/images/marocco/IMG_2824.jpg",
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
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Акт 3: Мерзуга
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
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_0134.jpg",
            ]),
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
              "assets/images/marocco/IMG_0389.jpg",
              "assets/images/marocco/IMG_0547.jpg",
              "assets/images/marocco/IMG_0455.jpg",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Сердцебиение пустыни
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
              "assets/images/marocco/IMG_4129.jpg",
              "assets/images/marocco/IMG_3255.jpg",
              "assets/images/marocco/IMG_1394.jpg",
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
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Роудтрип
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(text: "Эпичный Роудтрип"),
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
              "assets/images/marocco/IMG_0693.jpg",
              "assets/images/marocco/IMG_0694.jpg",
              "assets/images/marocco/IMG_0873.jpg",
              "assets/images/marocco/IMG_3426.jpg",
              "assets/images/marocco/IMG_3532.jpg",
              "assets/images/marocco/IMG_3883.jpg",
              "assets/images/marocco/IMG_0873.jpg",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "День 2: Уарзазат → Айт-Бен-Хадду (Aït Benhaddou) – легендарный укрепленный город (ксар), декорация к «Гладиатору», «Игре престолов». Затем – кульминация: Gsa Heaven (Gas Station Heaven) – заброшенная заправка и декорации к хоррору «У холмов есть глаза». Жутковато и атмосферно! Обратно в Мерзугу – еще ~500 км, приехали в 3 ночи. Адреналин! 🚗💨",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_1105.jpg",
              "assets/images/marocco/IMG_3927.jpg",
              "assets/images/marocco/IMG_1112.jpg",
              "assets/images/marocco/IMG_1114.jpg",
              "assets/images/marocco/IMG_1119.jpg",
              "assets/images/marocco/IMG_1250.jpg",
              "assets/images/marocco/IMG_1254.jpg",
              "assets/images/marocco/IMG_1262.jpg",
              "assets/images/marocco/IMG_1272.jpg",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Бонус: На трассе N10 нас остановили местные полицейские. Формально – за неполную остановку перед стоп-линией (жест регулировщика был неясен). Неформально – намек на «решение вопроса на месте». «Добровольный штраф» в 150 дирхам сработал быстрее официальной квитанции. Местный колорит.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_0889.jpg",
              "assets/images/marocco/IMG_0959.jpg",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Чудо пустыни
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
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Финал
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
              "assets/images/marocco/IMG_4232.jpg",
              "assets/images/marocco/IMG_1419.jpg",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Перелет в Касу, прощаемся с Аней (она летела дальше по Марокко), и мои 12 часов ожидания в аэропорту перед рейсом Turkish Airlines домой через Стамбул. Время осмыслить.",
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

            // Что нашел
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
            const ImageCarousel(images: [
              "assets/images/marocco/IMG_1427.jpg",
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),

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
            // кнопки соц.сетей
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              width: double.infinity,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
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
        setState(() => _showButtons = true);
        _stopAutoPlay();
      },
      onExit: (_) {
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
                              style: TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  );
                },
              ),

              // Кнопка "Назад"
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

              // Кнопка "Вперед"
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

              // Индикаторы
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

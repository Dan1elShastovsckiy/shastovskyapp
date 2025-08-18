//import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class PostGeorgiaPage extends StatefulWidget {
  // Важно: уникальное имя для роутера
  static const String name = 'georgia-part1';

  const PostGeorgiaPage({super.key});

  @override
  State<PostGeorgiaPage> createState() => _PostGeorgiaPageState();
}

class _PostGeorgiaPageState extends State<PostGeorgiaPage> {
  // Список всех изображений на странице для предварительного кэширования
  final List<String> _pageImages = [
    "assets/images/georgia_1/IMG_001.webp",
    "assets/images/georgia_1/IMG_002.webp",
    "assets/images/georgia_1/IMG_003.webp",
    "assets/images/georgia_1/IMG_004.webp",
    "assets/images/georgia_1/IMG_005.webp",
    "assets/images/georgia_1/IMG_006.webp",
    "assets/images/georgia_1/IMG_007.webp",
    "assets/images/georgia_1/IMG_008.webp",
    "assets/images/georgia_1/IMG_009.webp",
    "assets/images/georgia_1/IMG_010.webp",
    "assets/images/georgia_1/IMG_011.webp",
    "assets/images/georgia_1/IMG_012.webp",
    "assets/images/georgia_1/IMG_013.webp",
    "assets/images/georgia_1/IMG_014.webp",
    "assets/images/georgia_1/IMG_015.webp",
    "assets/images/georgia_1/IMG_016.webp",
    "assets/images/georgia_1/IMG_017.webp",
    "assets/images/georgia_1/IMG_018.webp",
    "assets/images/georgia_1/IMG_019.webp",
    "assets/images/georgia_1/IMG_020.webp",
    "assets/images/georgia_1/IMG_021.webp",
    "assets/images/georgia_1/IMG_022.webp",
    "assets/images/georgia_1/IMG_023.webp",
    "assets/images/georgia_1/IMG_024.webp",
    "assets/images/georgia_1/IMG_025.webp",
    "assets/images/georgia_1/IMG_026.webp",
    "assets/images/georgia_1/IMG_027.webp",
    "assets/images/georgia_1/IMG_028.webp",
    "assets/images/georgia_1/IMG_029.webp",
    "assets/images/georgia_1/IMG_030.webp",
    "assets/images/georgia_1/IMG_031.webp",
    "assets/images/georgia_1/IMG_032.webp",
    "assets/images/georgia_1/IMG_033.webp",
    "assets/images/georgia_1/IMG_034.webp",
    "assets/images/georgia_mountains.webp",
    "assets/images/avatar_default.png",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final imagePath in _pageImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  // Кнопка для скачивания обоев
  Widget _buildDownloadWallpaperButton() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
        constraints: const BoxConstraints(maxWidth: 700),
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.phone_iphone_rounded,
              color: Colors.black, size: 32),
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
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.5),
            side: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          onPressed: () =>
              launchUrl(Uri.parse('assets/georgia_1_photos_pack.zip')),
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
            // Главная карусель
            const ImageCarousel(images: [
              "assets/images/georgia_mountains.webp",
              "assets/images/georgia_1/IMG_001.webp",
              "assets/images/georgia_1/IMG_002.webp",
              "assets/images/georgia_1/IMG_003.webp",
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
                  "ГРУЗИЯ: Из Батуми в Кутаиси через горы",
                  style: headlineTextStyle,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBodySecondary(text: "Главная / Грузия: Часть 1"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Гамарджоба, друзья! Если вы думали, что Марокко был хаосом, то Грузия решила поднять ставки. Это история о том, как мы приземлились в апокалипсис, пережили шаурму для настоящих мужчин и отправились в хоррор-квест по ночным грузинским дорогам, чтобы найти деревню над облаками. Пристегнитесь!",
              ),
            ),

            // Акт 1: Прибытие в грозу
            const Align(
              alignment: Alignment.centerLeft,
              child:
                  TextHeadlineSecondary(text: "Акт 1: Посадка в сердце шторма"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Наш полет из Еревана в Батуми на Армянских авиалиниях сразу задал тон. Самолет, похожий на пластиковую игрушку, трещал и скрипел на взлете, а потом... пилот объявил, что в Батуми плохая погода и мы не можем сесть. О дальнейших планах он обещал сообщить, но, видимо, забыл. Так мы и начали наворачивать круги вокруг гигантской грозовой тучи, сверкающей молниями.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Это было как в кино. Пятый круг, посадка прямо сквозь облака, которые подсвечиваются разрядами молний. Я пошутил, что пилоты просто в нарды не доиграли и решили потянуть время. Когда шасси коснулись земли, салон взорвался такими громкими аплодисментами, каких я еще не слышал. Батуми встретил нас стеной ливня. Мокрые, но живые, мы добрались до квартиры и просто рухнули спать.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/georgia_1/IMG_027.webp",
              "assets/images/georgia_1/IMG_028.webp",
              "assets/images/georgia_1/IMG_025.webp",
              "assets/images/georgia_1/IMG_024.webp",
              "assets/images/georgia_1/IMG_026.webp",
            ]),

            // Акт 2: Батуми — город сюрпризов
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text: "Акт 2: Батуми — город сюрпризов и огненной шаурмы"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Первые дни в Батуми были чередой странных событий. Только мы обрадовались классной квартире и решили ее продлить, как хозяйка сообщила: «Я ее продала». Спасибо, что не нас. Попытка встать пораньше и поплавать в море? Погода ответила апокалиптической грозой и ливнем. Пришлось кутаться в плед и пить кофе, глядя на серое небо.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Но настоящий культурный шок ждал меня в обед. Даша, измученная недосыпом, попросила заказать шаурму. Привезли быстро. Откусываю и... познаю все тайны мироздания. В шаурму запихнули целые перцы халапеньо! Я моментально проснулся, выздоровел и захотел жить. Это была шаурма для настоящих мужчин. После такого даже защемленная на зарядке спина и поход по страховке в клинику уже не казались такой большой проблемой.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/georgia_1/IMG_030.webp",
              "assets/images/georgia_1/IMG_029.webp",
              "assets/images/georgia_1/IMG_031.webp",
              "assets/images/georgia_1/IMG_032.webp",
              "assets/images/georgia_1/IMG_033.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Когда погода наладилась, мы наконец-то смогли насладиться городом: гуляли по старому Батуми, нашли парк со свободными вольерами для птиц и красивую оранжерею. В общем, пришли в себя и были готовы к главному приключению.",
              ),
            ),

            // Акт 3: Роуд-трип
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text: "Акт 3: Роуд-трип в стиле хоррор-квеста"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Мы арендовали Mini Cooper и отправились вглубь Грузии по маршруту: Батуми → Уреки → Сенаки → Каньон Мартвили → Кутаиси. Дневная часть была прекрасна. А вот дорога от каньона до Кутаиси ночью — это был настоящий сюр.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/georgia_1/IMG_005.webp",
              "assets/images/georgia_1/IMG_004.webp",
              "assets/images/georgia_1/IMG_006.webp",
              "assets/images/georgia_1/IMG_007.webp",
              "assets/images/georgia_1/IMG_008.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Представьте: кромешная тьма, мы едем сквозь поселки, а на дороге постоянно возникают невидимые препятствия. Собаки, коровы, люди в черном, велосипедисты без отражателей, машины, брошенные на аварийке. Апогеем стала ТЕЛЕГА! Мужик на телеге, без единого огонька, просто материализовался из тьмы. А потом — растрепанная бабка, сидящая на обочине и просто смотрящая в никуда. Мы чувствовали себя героями хоррор-игры с одной целью: доехать живыми.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "В Кутаиси приключения продолжились. Навигатор привел нас не к тому отелю. В ресторане, куда мы приехали ужинать, не было хинкали. А потом вся улица взорвалась гудками и криками. Я подумал — свадьба. Оказалось, Грузия выиграла у Чехии в футбол 4:1! Весь город праздновал. Заселились в отель — простая комната с двумя кроватями и общим душем, но чистая и с гостеприимной хозяйкой. В какой-то момент мы просто начали истерически смеяться от абсурдности всего происходящего.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/georgia_1/IMG_009.webp",
              "assets/images/georgia_1/IMG_010.webp",
              "assets/images/georgia_1/IMG_011.webp",
              "assets/images/georgia_1/IMG_012.webp",
              "assets/images/georgia_1/IMG_013.webp",
              "assets/images/georgia_1/IMG_014.webp",
            ]),

            // Финал: Деревня над облаками
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(
                  text: "Финал: Деревня над Облаками и Дорога Домой"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "На следующий день, после завтрака и быстрого осмотра храма Баграта, мы отправились к главной цели — в деревню Гомисмта, которую нам посоветовал мужик из автопроката. Дорога туда шла через горы, по серпантинам. В какой-то момент мы буквально въехали в облако. Страшно и невероятно красиво!",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/georgia_1/IMG_019.webp",
              "assets/images/georgia_1/IMG_018.webp",
              "assets/images/georgia_1/IMG_015.webp",
              "assets/images/georgia_1/IMG_016.webp",
              "assets/images/georgia_1/IMG_020.webp",
              "assets/images/georgia_1/IMG_021.webp",
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "И вот мы поднялись над облаками. Виды — просто космос. Воздух пропитан запахом шашлыка. Гомисмта — это летняя деревня с крошечными домиками без воды (ее набирают в горном ключе) и без магазинов. Сюда приезжают с палатками, едой, чтобы насладиться природой. И да, туалетов тут тоже нет, только большие и добрые полянки.",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Обратная дорога в Батуми под ностальгическую музыку была уже спокойной. Мы наелись до отвала в Озургети всего на тысячу рублей на двоих и вернулись в город. И знаете что? Батуми снова встретил нас дождем. Кажется, это была его фишка.",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/georgia_1/IMG_017.webp",
              "assets/images/georgia_1/IMG_022.webp",
              "assets/images/georgia_1/IMG_023.webp",
            ]),

            // Выводы
            const Align(
              alignment: Alignment.centerLeft,
              child: TextHeadlineSecondary(text: "Что в итоге?"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: TextBody(
                text:
                    "Эта часть нашего грузинского путешествия была похожа на американские горки. От страха во время посадки и ночной поездки до полного восторга в деревне над облаками. Грузия не пыталась быть удобной. Она была настоящей, немного безумной, иногда пугающей, но всегда — невероятно душевной и вкусной. И это было только начало. Впереди нас ждал Тбилиси...",
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/georgia_1/IMG_034.webp",
            ]),

            _buildDownloadWallpaperButton(),

            // Теги и P.S.
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Путешествия"),
                Tag(tag: "Грузия"),
                Tag(tag: "Батуми"),
                Tag(tag: "Горы"),
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
                  constraints: const BoxConstraints(
                      maxWidth: 800), // Можно увеличить ширину для удобства
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      // --- Кнопки без подписи (остаются как были) ---
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

                      // --- КНОПКИ С ПОДПИСЬЮ (ИЗМЕНЕНА СТРУКТУРА LABEL) ---

                      // Кнопка Instagram
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        label: Column(
                          // Вместо Text используется Column
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Instagram'),
                            const SizedBox(height: 2),
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical:
                                  12), // Немного уменьшен вертикальный паддинг
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
                      ),

                      // Кнопка LinkedIn
                      ElevatedButton.icon(
                        icon: const Icon(Icons.work, color: Colors.black),
                        label: Column(
                          // Вместо Text используется Column
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('LinkedIn'),
                            const SizedBox(height: 2),
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                      ),

                      // Кнопка YouTube
                      ElevatedButton.icon(
                        icon: const Icon(Icons.smart_display_outlined,
                            color: Colors.black),
                        label: Column(
                          // Вместо Text используется Column
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('YouTube'),
                            const SizedBox(height: 2),
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://www.youtube.com/@itsmyadv')),
                      ),

                      // --- Кнопки без подписи (остаются как были) ---
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
            //нерабочие кнопки навигации
            // Если нужно, можно раскомментировать и использовать
            //Container(
            //padding: const EdgeInsets.symmetric(vertical: 80),
            //child: const PostNavigation(),
            //),
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

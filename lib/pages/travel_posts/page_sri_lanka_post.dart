// lib/pages/travel_posts/page_srilanka_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:minimal/components/comments_section.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/feature_tile.dart';
import 'package:minimal/components/reactions_widget.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
// Импорт семантических виджетов для возможного пререндеринга
import 'package:minimal/components/semantic_widgets.dart';

class PostSriLankaPage extends StatefulWidget {
  static const String name = 'sri-lanka';
  const PostSriLankaPage({super.key});

  @override
  State<PostSriLankaPage> createState() => _PostSriLankaPageState();
}

class _PostSriLankaPageState extends State<PostSriLankaPage> {
  final List<String> _pageImages = [
    "assets/images/sri_banner.webp", // main banner
    "assets/images/srilanka/9arch_bridge.webp", // 9 Arch Bridge
    "assets/images/srilanka/adam_peak.webp", // Adam's Peak
    "assets/images/srilanka/adam_peak2.webp", // Adam's Peak 2
    "assets/images/srilanka/airport_sunset.webp", // Airport Sunset
    "assets/images/srilanka/bad_breakfast.webp", // Bad Breakfast
    "assets/images/srilanka/beach_cafe_hikka.webp", // Beach Cafe Hikkaduwa
    "assets/images/srilanka/big_ocean.webp", // Big Ocean
    "assets/images/srilanka/big_ocean1.webp", // Big Ocean 1
    "assets/images/srilanka/buddha_monastery.webp", // Buddha Monastery
    "assets/images/srilanka/cafe_nella.webp", // Cafe Nella
    "assets/images/srilanka/dasha_adam_peak.webp", // Dasha at Adam's Peak
    "assets/images/srilanka/dasha_adam_peak2.webp", // Dasha at Adam's Peak 2
    "assets/images/srilanka/dasha_adam_peak3.webp", // Dasha at Adam's Peak 3
    "assets/images/srilanka/dasha_ella_hotel.webp", // Dasha at Ella Hotel
    "assets/images/srilanka/dasha_ella_hotel2.webp", // Dasha at Ella Hotel 2
    "assets/images/srilanka/dasha_mirissa.webp", // Dasha at Mirissa
    "assets/images/srilanka/dasha_tea_plantations.webp", // Dasha at Tea Plantations
    "assets/images/srilanka/dasha_waterfall.webp", // Dasha at Waterfall
    "assets/images/srilanka/elephant_school.webp", // Elephant School
    "assets/images/srilanka/elephants_butt.webp", // Elephant's Butt
    "assets/images/srilanka/flight_to_kl.webp", // Flight to Kuala Lumpur
    "assets/images/srilanka/galle_cafe.webp", // Galle Cafe
    "assets/images/srilanka/galle_fort.webp", // Galle Fort
    "assets/images/srilanka/good_pasta_lunch.webp", // Good Pasta Lunch
    "assets/images/srilanka/hikka_beach.webp", // Hikkaduwa Beach
    "assets/images/srilanka/hikka_beach2.webp", // Hikkaduwa Beach 2
    "assets/images/srilanka/hikka_beach3.webp", // Hikkaduwa Beach 3
    "assets/images/srilanka/history_tsunami.webp", // History of Tsunami
    "assets/images/srilanka/insects_home.webp", // Insects at Home
    "assets/images/srilanka/kegalle_lunch.webp", // Kegalle Lunch
    "assets/images/srilanka/local_coffee.webp", // Local Coffee
    "assets/images/srilanka/me_9arch_bridge.webp", // Me at 9 Arch Bridge
    "assets/images/srilanka/me_galle.webp", // Me in Galle
    "assets/images/srilanka/me_mirissa.webp", // Me in Mirissa
    "assets/images/srilanka/me_mirissa2.webp", // Me in Mirissa 2
    "assets/images/srilanka/me_pool.webp", // Me in the Pool
    "assets/images/srilanka/mountains_train.webp", // Mountains Train
    "assets/images/srilanka/mountains_train2.webp", // Mountains Train 2
    "assets/images/srilanka/parrot_rock.webp", // Parrot Rock
    "assets/images/srilanka/passionfruit.webp", // Passionfruit
    "assets/images/srilanka/spa_ceylon.webp", // Spa Ceylon
    "assets/images/srilanka/sunrise_5am_ella_hotel.webp", // Sunrise 5am at Ella Hotel
    "assets/images/srilanka/sunset_at_villa.webp", // Sunset at Villa
    "assets/images/srilanka/sunset_at_villa2.webp", // Sunset at Villa 2
    "assets/images/srilanka/sunset_hikka.webp", // Sunset at Hikkaduwa
    "assets/images/srilanka/tea_plantations.webp", // Tea Plantations
    "assets/images/srilanka/waterfall.webp", // Waterfall
  ];

  // Флаг для определения режима рендеринга
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

  final String _tsunamiInfo = """
**Катастрофа 2004 года:** 26 декабря 2004 года в Индийском океане произошло землетрясение, вызвавшее мощнейшее цунами.

*   **Жертвы:** Погибло более **230 000** человек в 14 странах Азии.
*   **Шри-Ланка:** Более **35 000** погибших.
*   **Трагедия поезда:** Поезд, шедший по побережью, был полностью уничтожен волной. Из ~1700 пассажиров выжило лишь около **10 человек**.
*   **Музей:** [Музей Цунами в Хиккадуве](https://maps.app.goo.gl/cYaftMwWcWzvehhL8?g_st=ipc) хранит вагон этого поезда, как напоминание о том, как быстро смерть становится огромной цифрой, статистикой...
""";

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }

    MetaTagService().updateAllTags(
      title: "Шри-Ланка. От серф-провала до горных вершин Цейлона",
      description:
          "Полный гайд: 6 месяцев жизни, цены, еда, лайфхаки и вся правда о серфинге, слонах и цунами. Бюджет на двоих.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/srilanka/srilanka-banner.webp",
    );
  }

  void _showInfoDialog(BuildContext context,
      {required String title, required String markdownContent}) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: headlineSecondaryTextStyle(context)),
          content: SingleChildScrollView(
            child: MarkdownBody(
              data: markdownContent,
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: bodyTextStyle(context),
                listBullet: bodyTextStyle(context),
                code: bodyTextStyle(context).copyWith(
                  fontFamily: 'monospace',
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Понятно"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  TextSpan _link(String text, String url) {
    return TextSpan(
      text: text,
      style: bodyTextStyle(context)
          .copyWith(color: Colors.blue, decoration: TextDecoration.underline),
      recognizer: TapGestureRecognizer()
        ..onTap = () => launchUrl(Uri.parse(url)),
    );
  }

  // Helper function to create button links (ElevatedButton.icon)
  Widget _linkButton(String label, String url, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton.icon(
        onPressed: () => launchUrl(Uri.parse(url)),
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }

  // Полная семантическая разметка для поисковиков
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("Шри-Ланка. От серф-провала до горных вершин Цейлона"),
        SemanticP(
            "Полгода жизни на острове. Вся правда о быте, ценах, серфинге, невероятных закатах и зачем тут так много собак. Честный гайд."),
        SemanticImg(
            src: "assets/images/sri_banner.webp", alt: "Пляж на Шри-Ланке"),
        SemanticH2("Глава 1: Полтора года погружения и сингальский Новый год"),
        SemanticP(
            "Мое первое знакомство со Шри-Ланкой случилось в 2022 году. Длинный перелет из Петербурга с пересадкой в Дубае (где я с ностальгией пообедал в Макдональдсе, которого уже не было в РФ) привел меня на остров, где я остался на целых **шесть месяцев**. Я жил на вилле нашей семейной знакомой Руми, и за это время мы стали настоящей семьей. Я смог полностью погрузиться в местный быт, который не увидишь из окна отеля."),
        SemanticP(
            "**Сингальский Новый Год:** Руми устроила нам настоящий праздник. Помню, как мы ели рис руками в палатках, где общественники готовят еду для всех. Богатые приезжают раздавать еду, а бедные могут поесть. Это очень вайбовая, аутентичная традиция."),
        SemanticP(
            "Позже я съездил в Коломбо. В самом городе делать особо нечего, но я **настоятельно рекомендую** хоть раз туда съездить и желательно сделать это на местном поезде, который всю дорогу едет вдоль побережья. Поездка недорогая: билетик стоит около 500-1000 LKR. Выезжать лучше рано утром или обратно до заката, чтобы застать его прямо из окна поезда на океан."),
        SemanticH2("Глава 2: Сёрфинг, океан и 'стиральная машина'"),
        SemanticP(
            "Конечно, Шри-Ланка — это про сёрфинг. В 5 утра меня привезли на пляж около Хиккадувы. При заходе в 'стиральную машину' волн океан забрал мою доску и вернул ее прямо мне в лицо. После небольшого сотрясения я снова полез обратно, и в итоге встал на доску, проехался и... снова рухнул, промолотый о камни и кораллы."),
        SemanticP(
            "Я понял, что сёрфинг — это не моё. На сноуборде или скейтборде ты управляешь процессом, а в океане есть только ты и стихия, которая на порядок сильнее. Чтобы управлять волной, нужно **СЛИШКОМ** много тренироваться."),
        SemanticP(
            "Если не хотите таких же травм, как у меня, езжайте в Велигаму. Там 'детские' волны, которые идеально подходят для обучения. Сам город очень красивый и вкусный."),
        SemanticImg(
            src: "assets/images/srilanka/big_ocean.webp",
            alt: "Волны Индийского океана у Шри-Ланки"),
        SemanticH2("Глава 3: Экспедиция в Сердце Цейлона (2024)"),
        SemanticP(
            "В 2024 году я приехал на Шри-Ланку уже вместе с Дашей. Я уже наученный опытом жизни там, смог показать ей Цейлон с лучшей стороны, объехав всё побережье от Хиккадувы до Мириссы. Настоящий сок острова — в глубине, в горах и древних местах."),
        SemanticP(
            "Поездка по Элле, Нувара-Элии, к 9-арочному мосту и слоновьему питомнику заняла у нас два дня. Мы взяли организованный тур с местным гидом Тимуром. Это оказалось намного удобнее и выгоднее, чем ехать самим. В цену (\$100 с человека) включено всё: транспорт, проживание в отеле на горе с видом, ужин и завтрак."),
        SemanticImg(
            src: "assets/images/srilanka/adam_peak.webp",
            alt: "Панорама с Пика Адама"),
        SemanticP(
            "Слоновий детский дом, чайные плантации и, конечно, **Пик Адама**. Как отметила Даша: «Настает момент, когда ты никуда не торопишься, стоишь, смотришь на эти массивные горы, утопая глазами в тумане, и думаешь: еб..ть, а о чем думать-то!» Это была идеальная перезагрузка. Мы познакомились с моей подругой Аней, с которой уже много раз встречались в разных уголках планеты (даже в [Иордании](https://shastovsky.com/jordan))."),
        SemanticImg(
            src: "assets/images/srilanka/9arch_bridge.webp",
            alt: "9-арочный мост в Элле."),
        SemanticP(
            "Мы также посетили Нувара-Элию — английскую деревню с полями для гольфа. Все это, включая водопад Равана и знаменитый 9-арочный мост, мы посмотрели за два дня."),
        SemanticP(
            "Отдельно стоит упомянуть магазин косметики **Ceylon Spa**. Их магазины по всему острову невероятно ярко и цветасто декорированы. Это чисто местная косметика, которая заслуживает внимания."),
        SemanticImg(
            src: "assets/images/srilanka/spa_ceylon.webp",
            alt: "Яркий декор магазина Ceylon Spa"),
        SemanticH2("Глава 4: Вся Правда о Еде, Деньгах и Быте"),
        SemanticP(
            "Местный рацион — рис, лапша, рыба, овощи. Полезно, но не разнообразно. Еда очень острая, а импортные товары дорогие. Главный шок: **практически нет доставок** и мало заведений с неместной кухней. Приходилось готовить самим, что, честно говоря, сильно утомляло."),
        SemanticP(
            "**Обмен валюты:** На острове много русских менял. Можно спокойно переводить с РФ банков на наличные рупии. Из банкоматов **Commercial Bank** и **DFCC Bank** (красный) позволяют снимать с зарубежных карт без дополнительной комиссии (нужно выбрать 'Без конвертации')."),
        SemanticP(
            "Из алкоголя: местный ром — **Аррак** — полная дрянь на мой вкус, но попробовать можно. Из еды: очень вкусное мороженое, много самодельных пуддингов, а вот шоколад очень ограничен (нет горького). **Сладкая маракуйя** — приятное открытие!"),
        SemanticImg(
            src: "assets/images/srilanka/good_pasta_lunch.webp",
            alt: "Обед на Шри-Ланке"),
        SemanticH2("Глава 5: Уроки Выживания и Музей Цунами"),
        SemanticP(
            "Нужно тщательно проверять еду: местные используют пластиковые лопатки для жарки, которые могут плавиться. И да, **змеи и скорпионы действительно заползают в туалет** и в дом. Нужно быть внимательным."),
        SemanticP(
            "Впечатляющий [Музей Цунами в Хиккадуве](https://maps.app.goo.gl/cYaftMwWcWzvehhL8?g_st=ipc) — это вагон поезда, который волна 2004 года размотала по всему берегу. Мысль: как страшно, когда смерть становится лишь огромной цифрой, статистикой…"),
        SemanticImg(
            src: "assets/images/srilanka/history_tsunami.webp",
            alt: "Информационный стенд в музее цунами"),
        SemanticH2("Эпилог: ТОП-1 Закатов"),
        SemanticP(
            "Шри-Ланка — это кардинально другая страна. Аутентичная большая деревня. **Закаты здесь — это, наверное, ТОП-1** из всех стран, где я был. Сюда действительно стоит приехать хотя бы раз, чтобы увидеть это."),
        SemanticImg(
            src: "assets/images/srilanka/sunset_hikka.webp",
            alt: "Невероятный закат на Шри-Ланке"),
        SemanticH2("Сводка: Цены, жилье и бюджет на месяц"),
        SemanticP(
            "Вот мои личные заметки, которые могут помочь тем, кто планирует остаться на острове надолго или просто хочет понять порядок цен. Актуальный курс (2024): **1000 LKR ≈ 267 руб.**"),
        SemanticP('''
**Бюджет на месяц (на одного человека)**:
- **Проживание (этаж/аппарты):** \$400-\$600 (без КУ).
- **Коммунальные услуги (Электричество):** ~23 000 руб. на двоих за месяц.
- **Питание (Самоготов + Кафе):** ~ \$300.
- **Транспорт (Байк):** ~ \$150.
- **ИТОГО:** ~ **\$950 / месяц** (для комфортной жизни и работы).
'''),
        SemanticH2("FAQ: Ответы на Главные Вопросы"),
        SemanticP(
            "**1. Где лучше жить?** Если вы турист на короткий срок и без работы — ближе к берегу. Если с работой и надолго — лучше подальше виллу снять. (Мы жили в [Ora Villas](https://maps.app.goo.gl/xWuMSPFLQydbYY6M7?g_st=ipc))."),
        SemanticP(
            "**2. Еда там совсем невкусная?** Там вкусная еда, но очень острая! Просто нужно проникнуться околоиндийской культурой. Если не любите острое, ищите туристические места."),
        SemanticP(
            "**3. Змеи и скорпионы заползают в туалет?** **Даже скорпионы заползают**. К сожалению, нужно быть внимательным, особенно в домах в отдалении от побережья. Это местная реальность."),
        SemanticP(
            "**4. Где и как лучше арендовать жилье?** Лучше всего искать через **Telegram-чаты** или написать местным, кто поможет с контактами. Booking.com в сезон может быть дороже. Целый этаж апартаментов стоит от **\$400 - \$600** в месяц."),
        SemanticP(
            "**5. Какой сезон лучше и когда не ехать?** Лучший сезон — с декабря по март (юго-западное побережье). В начале сезона (ноябрь/декабрь) и в конце (апрель) может быть дождливо. Мы попали в дождливый период в 2024 году."),
        SemanticP(
            "**6. На чем передвигаться?** Между городами лучше на поезде (до 700LKR) или автобусе(CRAZY-BUSы ездят по побережью - уровень комфорта НАМНОГО ниже поезда, но ездит чаще). Внутри городов — на тук-туках (торгуйтесь!). Для долгого проживания выгодно арендовать байк (~\$150 в месяц)."),
        SemanticP(
            "**7. Проблемы с электричеством и счетами?** Энергоснабжение нестабильное из-за давних проблем. Счета за электричество могут шокировать: у нас вышло **~23 000 рублей за месяц** на двоих. Экономьте свет и кондиционер!"),
        SemanticP(
            "**8. Алкоголь и местный ром?** Алкоголь продается только в отдельных **алкомаркетах** и довольно дорогой. Местный аналог рома — **Аррак** — на мой вкус, полная дрянь, но попробовать один раз можно."),
        SemanticP(
            "**9. Как обналичить деньги?** Используйте **менял** (через Telegram-чаты) для перевода с РФ карт. Из банкоматов **Commercial Bank** (нажать 'Без конвертации') и **DFCC Bank** (красный) не берут дополнительную комиссию за снятие с зарубежных карт."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildPrerenderContent(),
      )));
    }

    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    // ВЕСЬ ОСНОВНОЙ КОНТЕНТ СТАТЬИ НИЖЕ
    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Шри-Ланка"),
              ]),
            ),
            const SizedBox(height: 40),
            // Дата и время чтения
            Center(
              child: Text(
                DateFormat.yMMMMd('ru_RU').format(DateTime(2025, 02, 12)),
                style: bodyTextStyle(context).copyWith(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "~18 минут чтения", // примерное время
                  style: subtitleTextStyle(context).copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text("Шри-Ланка. От серф-провала до горных вершин Цейлона",
                style: headlineTextStyle(context), textAlign: TextAlign.center),

            const SizedBox(height: 16),

            Text(
              "6 месяцев жизни на острове. Вся правда о быте, ценах, серфинге, невероятных закатах и почему здесь может быть опасно жить... Честный гайд.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const ImageCarousel(images: [
              "assets/images/sri_banner.webp", // Баннер
              "assets/images/srilanka/airport_sunset.webp", // Закат в аэропорту
              "assets/images/srilanka/flight_to_kl.webp", // Перелет
              "assets/images/srilanka/mountains_train.webp", // Поезд в Коломбо
              "assets/images/srilanka/mountains_train2.webp", // Вид из поезда
            ]),
            const TextHeadlineSecondary(
                text:
                    "Глава 1: Полтора года погружения и сингальский Новый год"),
            // TextBody с bold
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Мое первое знакомство со Шри-Ланкой случилось в 2022 году. Длинный перелет из Петербурга с пересадкой в Дубае (где я с ностальгией пообедал в Макдональдсе, которого уже не было в РФ) привел меня на остров, где я остался на целых "),
                  TextSpan(
                      text: "шесть месяцев",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(text: "."),
                ],
              ),
            ),
            const TextBody(
                text:
                    "Я жил на вилле нашей семейной знакомой Руми. За это время мы стали настоящей семьей, и я смог полностью погрузиться в местный быт, который не увидишь из окна отеля. Это время подарило мне уникальный опыт:"),
            // TextBlockquote с bold (в надежде, что он обрабатывает Markdown)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 4),
                  ),
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.05),
                ),
                child: MarkdownBody(
                  data:
                      "**Сингальский Новый Год:** Руми устроила нам настоящий праздник. Помню, как мы ели рис руками в палатках, где общественники готовят еду для всех. Богатые приезжают раздавать еду, а бедные — могут поесть. Это очень вайбовая, аутентичная традиция.",
                  selectable: true,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: bodyTextStyle(context)
                        .copyWith(fontStyle: FontStyle.italic),
                    strong: bodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const ImageCarousel(images: [
              "assets/images/srilanka/big_ocean.webp", // Океан
              "assets/images/srilanka/big_ocean1.webp", // Мощь океана
              "assets/images/srilanka/hikka_beach.webp", // Пляж в Хиккадуве
              "assets/images/srilanka/hikka_beach2.webp", // Пляж в Хиккадуве 2
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 2: Сёрфинг, океан и 'стиральная машина'"),
            const TextBody(
                text:
                    "Конечно, Шри-Ланка — это про сёрфинг. В 5 утра меня привезли на пляж. При заходе в 'стиральную машину' волн океан забрал мою доску и вернул ее прямо мне в лицо. Небольшое сотрясение — и я снова в воде. В итоге я все-таки встал на доску, проехался и... снова рухнул, промолотый о камни и кораллы."),
            // TextBlockquote с bold (в надежде, что он обрабатывает Markdown)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 4),
                  ),
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.05),
                ),
                child: MarkdownBody(
                  data:
                      "Я понял, что сёрфинг — это не моё. На сноуборде или скейтборде ты управляешь процессом, а в океане есть только ты и стихия, которая на порядок сильнее. Чтобы управлять волной, нужно **СЛИШКОМ** много тренироваться.",
                  selectable: true,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: bodyTextStyle(context)
                        .copyWith(fontStyle: FontStyle.italic),
                    strong: bodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            FeatureTile(
              icon: Icons.surfing,
              title: "Где учиться сёрфу новичку?",
              content:
                  "Если не хотите таких же травм, как у меня, езжайте в **Велигаму**. Там 'детские' волны, которые идеально подходят для обучения. Сам город очень красивый и вкусный.",
              actionButton: ElevatedButton.icon(
                onPressed: () => launchUrl(
                    Uri.parse('https://maps.app.goo.gl/vHULP6yFapLUkAP28')),
                icon: const Icon(Icons.location_on_outlined),
                label: const Text("Отель в Велигаме"),
              ),
            ),
            const SizedBox(height: 24),
            const ImageCarousel(images: [
              "assets/images/srilanka/adam_peak.webp", // Пик Адама
              "assets/images/srilanka/adam_peak2.webp", // Вид с Пика Адама
              "assets/images/srilanka/dasha_adam_peak.webp", // Даша на Пике Адама
              "assets/images/srilanka/dasha_adam_peak3.webp", // Даша на Пике Адама 3
              "assets/images/srilanka/sunrise_5am_ella_hotel.webp", // Рассвет в Элле
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 3: Экспедиция в Сердце Цейлона (2024)"),
            const TextBody(
                text:
                    "В 2024 году я приехал на Шри-Ланку уже вместе с Дашей. Опираясь на свой первый опыт, я смог показать ей Цейлон с лучшей стороны. Настоящий сок острова — в глубине, в горах и древних местах."),
            FeatureTile(
              icon: Icons.travel_explore,
              title: "Центр острова за 100 долларов",
              content:
                  "Поездка по Элле, Нувара-Элии, к 9-арочному мосту и слоновьему питомнику заняла у нас два дня. Организованный тур с местным гидом оказался гораздо удобнее и выгоднее, чем ехать самому. В цену (за человека!) включено всё: транспорт, проживание в отеле на горе с видом, ужин и завтрак.",
              actionButton: ElevatedButton.icon(
                onPressed: () =>
                    launchUrl(Uri.parse('https://t.me/timurtours')),
                icon: const Icon(Icons.group),
                label: const Text("Гид Тимур (Telegram)"),
              ),
            ),
            // TextBody с bold
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Слоновий детский дом, чайные плантации и, конечно, "),
                  TextSpan(
                      text: "Пик Адама",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(text: "."),
                ],
              ),
            ),
            // TextBlockquote с bold (в надежде, что он обрабатывает Markdown)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 4),
                  ),
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.05),
                ),
                child: MarkdownBody(
                  data:
                      "Каждый раз, глядя на эти виды, я думаю: вот сейчас... Сейчас подумаю о смысле жизни. И вот настает момент, когда ты никуда не торопишься, стоишь, смотришь на массивные горы, утопая глазами в тумане, и думаешь: **еб..ть, а о чем думать-то!** — *Заметки Даши*",
                  selectable: true,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: bodyTextStyle(context)
                        .copyWith(fontStyle: FontStyle.italic),
                    strong: bodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            const TextBody(
                text:
                    "Кстати, в прошлый раз в поездке на экскурсию я познакомился с моей подругой Аней, с которой мы уже много раз встречались в разных уголках планеты (даже в Иордании, о чем есть "),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () =>
                    launchUrl(Uri.parse('https://shastovsky.com/jordan')),
                icon: const Icon(Icons.article_outlined),
                label: const Text("Читать пост об Иордании"),
              ),
            ),
            const SizedBox(height: 24),
            const ImageCarousel(images: [
              "assets/images/srilanka/9arch_bridge.webp", // 9-арочный мост
              "assets/images/srilanka/me_9arch_bridge.webp", // Я на мосту
              "assets/images/srilanka/tea_plantations.webp", // Чайные плантации
              "assets/images/srilanka/dasha_tea_plantations.webp", // Даша на плантациях
              "assets/images/srilanka/waterfall.webp", // Водопад
              "assets/images/srilanka/elephant_school.webp", // Слоновий питомник
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 4: Вся Правда о Еде, Деньгах и Быте"),
            FeatureTile(
              icon: Icons.restaurant_menu,
              title: "Еда: остро, полезно, без разнообразия",
              // ИСПРАВЛЕНИЕ: Content с bold
              content:
                  "Местный рацион — рис, лапша, рыба, овощи. Полезно, но не разнообразно. Еда очень острая, а импортные товары дорогие. Главный шок: **практически нет доставок** и мало заведений с неместной кухней. Нужно готовить самим! Из алкоголя: местный ром — **Аррак** — на мой вкус, полная дрянь, но попробовать стоит.",
              actionButton: ElevatedButton.icon(
                onPressed: () => launchUrl(
                    Uri.parse('https://maps.app.goo.gl/AUJPNYPgxQtTQHKx5')),
                icon: const Icon(Icons.location_on_outlined),
                label: const Text("Вкусный веганский ресторан на берегу"),
              ),
            ),
            const FeatureTile(
              icon: Icons.dangerous_outlined,
              title: "Опасности: не только цунами",
              // ИСПРАВЛЕНИЕ: Content с bold
              content:
                  "Местные почему-то используют пластиковые лопатки для жарки, которые плавятся — нужно тщательно проверять еду, чтобы избежать попадания пластика/фольги. И да, **змеи и скорпионы действительно заползают в туалет** и в дом. Нужно быть внимательным.",
            ),
            FeatureTile(
              icon: Icons.history_edu,
              title: "Музей Цунами: Не просто статистика",
              content:
                  "Впечатляющий музей в Хиккадуве хранит вагон поезда, который волна 2004 года размотала по всему берегу как игрушку. Узнать о масштабах трагедии и о том, как выживают в этой стране - очень важно.",
              actionButton: ElevatedButton.icon(
                // ИНТЕРЕСНАЯ КНОПКА С ВСПЛЫВАЮЩЕЙ ПОДСКАЗКОЙ
                onPressed: () => _showInfoDialog(context,
                    title: "Цунами 2004: Катастрофа в цифрах",
                    markdownContent: _tsunamiInfo),
                icon: const Icon(Icons.info_outline),
                label: const Text("Подробнее о трагедии"),
                style: elevatedButtonStyle(context).copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.red.shade400),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
              ),
            ),
            // ИСПРАВЛЕНИЕ: TextBody с bold
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(text: "Кстати, вы знали, что существует "),
                  TextSpan(
                      text: "сладкая маракуйя",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          "? До приезда сюда, я об этом не знал и был приятно удивлен, потому что кислую есть не могу. Также обязательно зацените местный бренд косметики "),
                  TextSpan(
                      text: "Ceylon Spa",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          ", их магазины невероятно ярко и цветасто декорированы!"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const ImageCarousel(images: [
              "assets/images/srilanka/passionfruit.webp", // Сладкая маракуйя
              "assets/images/srilanka/local_coffee.webp", // Местный кофе
              "assets/images/srilanka/good_pasta_lunch.webp", // Обед с пастой
              "assets/images/srilanka/history_tsunami.webp", // Музей Цунами
              "assets/images/srilanka/spa_ceylon.webp", // Spa Ceylon
              "assets/images/srilanka/insects_home.webp", // "Домашние" насекомые
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(text: "FAQ: Ответы на Главные Вопросы"),

            // 1. Где жить?
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "1. Где лучше всего жить?",
              content:
                  "Если вы турист на короткий срок и без работы — ближе к берегу в любом удобном вам отеле. Если с работой и надолго — лучше подальше виллу снять. Мы жили в [Ora Villas](https://maps.app.goo.gl/xWuMSPFLQydbYY6M7?g_st=ipc).",
            ),
            // 2. Еда?
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "2. Еда там совсем невкусная?",
              content:
                  "Там вкусная еда, но очень острая! Просто нужно проникнуться околоиндийской культурой. Если не любите острое, ищите туристические места. Обязательно попробуйте **сладкую маракуйю**!",
            ),
            // 3. Змеи?
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "3. Змеи и скорпионы заползают в туалет?",
              content:
                  "Даже скорпионы заползают. К сожалению, нужно быть внимательным, особенно в домах в отдалении от побережья. Это местная реальность.",
            ),
            // 4. Про аренду жилья
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "4. Где и как лучше арендовать жилье?",
              content:
                  "Лучше всего искать через **Telegram-чаты** или написать местным, кто поможет с контактами. Booking.com в сезон может быть дороже. Целый этаж апартаментов стоит от **\$400 - \$600** в месяц.",
            ),
            // 5. Про сезон
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "5. Какой сезон лучше и когда не ехать?",
              content:
                  "Лучший сезон — с декабря по март (юго-западное побережье). В начале сезона (ноябрь/декабрь) и в конце (апрель) может быть дождливо. Мы попали в дождливый период в 2024 году.",
            ),
            // 6. Про такси
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "6. На чем передвигаться?",
              content:
                  "Между городами лучше на поезде (до 700LKR) или автобусе(CRAZY-BUSы ездят по побережью - уровень комфорта НАМНОГО ниже поезда, но ездит чаще). Внутри городов — на тук-туках (торгуйтесь!). Для долгого проживания выгодно арендовать байк (~\$150 в месяц).",
            ),
            // 7. Про электричество
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "7. Проблемы с электричеством и счетами?",
              content:
                  "Энергоснабжение нестабильное из-за давних проблем. Счета за электричество могут шокировать: у нас вышло **~23 000 рублей за месяц** на двоих. Используйте разумно свет и кондиционер!",
            ),
            // 8. Про алкоголь
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "8. Алкоголь и местный ром?",
              content:
                  "Алкоголь продается только в отдельных **алкомаркетах** и довольно дорогой. Местный аналог рома — **Аррак** — на мой вкус, полная дрянь, но попробовать один раз можно.",
            ),
            // 9. Про карты и наличные
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "9. Как обналичить деньги?",
              content:
                  "Используйте **менял** (через Telegram-чаты) для перевода с РФ карт. Из банкоматов **Commercial Bank** (нажать 'Без конвертации') и **DFCC Bank** (красный) не берут дополнительную комиссию за снятие с зарубежных карт.",
            ),
            // 10. Про собак
            const FeatureTile(
              icon: Icons.question_answer_outlined,
              title: "10. А как там с собаками?",
              content:
                  "Собак на острове очень много, но они **грубо говоря** домашние. Потому что за ними ухаживают местные жители, а также госдарство. Их кормят, прививают и лечат. А на острове их так много - по причине цунами. \n\n**Эти собаки - маркер, что скоро будет цунами.** Если собаки начинают вести себя беспокойно и убегают с пляжа к центру острова - значит скоро будет цунами. Поэтому местные к ним очень хорошо относятся.",
            ),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Эпилог: ТОП-1 закатов и куда дальше"),
            const TextBody(
                text:
                    "Шри-Ланка — это кардинально другая страна. Аутентичная большая деревня. **Закаты здесь — это, наверное, ТОП-1** из всех стран, где я был. Сюда действительно стоит приехать хотя бы раз, чтобы увидеть это. "),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Подробнее о наших поездках по Грузии и Армении, а также другой тревел-контент — в моем "),
                  _link("Telegram-канале.", "https://t.me/shastovscky"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const ImageCarousel(images: [
              "assets/images/srilanka/sunset_hikka.webp", // Закат в Хиккадуве
              "assets/images/srilanka/sunset_at_villa.webp", // Закат на вилле
              "assets/images/srilanka/dasha_mirissa.webp", // Даша в Мириссе
              "assets/images/srilanka/parrot_rock.webp", // Скала Попугаев, Мирисса
              "assets/images/srilanka/galle_fort.webp", // Форт Галле для атмосферы
              "assets/images/srilanka/me_galle.webp", // Я в Галле
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Сводка: Цены, жилье и бюджет на месяц"),
            // ИСПРАВЛЕНИЕ: TextBody с bold
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Вот мои личные заметки, которые могут помочь тем, кто планирует остаться на острове надолго или просто хочет понять порядок цен. "),
                  TextSpan(
                      text: "Актуальный курс (2024): 1000 LKR ≈ 267 руб.",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // <<< БЮДЖЕТ: FeatureTile с таблицей-Markdown (обновленный) >>>
            const FeatureTile(
              icon: Icons.attach_money,
              title: "Бюджет на месяц (для жизни, на 1 человека)",
              content: '''
### Цены и советы по жизни

*   **Жилье (Аренда виллы/аппартов):**
    *   **Бюджет (этаж):** \$400 - \$600 в месяц.
    *   **Комфорт (дом целиком):** \$800 - \$1200 в месяц.
*   **Коммунальные услуги:**
    *   **Электричество:** Дорого! **~23 000 руб. / месяц** на двоих (2024 г.). Энергоснабжение нестабильное.
*   **Питание (Курс 1000 LKR ≈ 267 руб.):**
    *   **Ротти (местная забегаловка):** 300 - 700 LKR (**~80 - 187 руб.**)
    *   **Средний ужин (на чел. в кафе):** 3000 - 6000 LKR (**~801 - 1602 руб.**)
    *   *Вывод: Очень выгодно готовить самим, продукты на рынках доступны.*
*   **Развлечения:**
    *   **Экскурсия в центр (2 дня):** \$100 с человека — самый выгодный вариант.

| Статья расходов (на 1 чел.) | Сумма (USD) | Примечание |
| :--- | :--- | :--- |
| **Проживание** | \$500 (минимум) | Вкл. часть КУ |
| **Еда (самоготов)** | \$300 | На рынках/Cargills. |
| **Транспорт (Байк)** | \$150 | Аренда байка на месяц + бензин. |
| **Итого:** | **~ \$950 / месяц** | **Для комфортной жизни и работы.** |
''',
            ),

            const TextHeadlineSecondary(text: "Полезные ссылки и контакты"),
            // Кнопки ссылок на места
            const SizedBox(height: 16),
            FeatureTile(
              icon: Icons.house_outlined,
              title: "Жилье, еда и полезные сервисы",
              content:
                  "Проверенные места и контакты для комфортного пребывания.",
              actionButton: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '— Где жили и покупали продукты —',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _linkButton(
                      'Наша вилла в Хиккадуве (Ora Villas)',
                      'https://maps.app.goo.gl/xWuMSPFLQydbYY6M7?g_st=ipc',
                      Icons.hotel),
                  _linkButton(
                      'Местный супермаркет (Cargills)',
                      'https://maps.app.goo.gl/Js5Y21SK1SD9szWx6?g_st=ipc',
                      Icons.local_grocery_store),
                  _linkButton(
                      'Огромный фруктово-овощной рынок (Хиккадува)',
                      'https://maps.app.goo.gl/e1woHTjhAiRSNehf7?g_st=ipc',
                      Icons.shopping_basket),
                  const SizedBox(height: 16),
                  const Text(
                    '— Где ели (Побережье) —',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _linkButton(
                      'Вкусные бургеры (La belle vie, Хиккадува)',
                      'https://maps.app.goo.gl/RbsCgn7LNDfvt1867?g_st=ipc',
                      Icons.fastfood),
                  _linkButton(
                      'Веганский рестик на берегу (Steffi’s Mandala, Хиккадува)',
                      'https://maps.app.goo.gl/AUJPNYPgxQtTQHKx5?g_st=ipc',
                      Icons.coffee),
                  _linkButton(
                      'Приятный местный ресторан (Хиккадува)',
                      'https://maps.app.goo.gl/knGivFE8TWkPfDL5A?g_st=ipc',
                      Icons.restaurant),
                  _linkButton(
                      'Рестик от русского предпринимателя (Kaiyo, Велигама)',
                      'https://maps.app.goo.gl/797HRWzhZqbXCcWw9?g_st=ipc',
                      Icons.restaurant_menu),
                  _linkButton(
                      'Семейный ресторан с местной кухней (Fujisan, Велигама)',
                      'https://maps.app.goo.gl/QoY48ZtFpegdBnVU8?g_st=ipc',
                      Icons.rice_bowl),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FeatureTile(
              icon: Icons.map_outlined,
              title: "Локации и экскурсионные точки",
              content:
                  "Все места, которые стоит посетить (от побережья до гор).",
              actionButton: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _linkButton('Гид по центру острова (Тимур, Telegram)',
                      'https://t.me/timurtours', Icons.person_pin),
                  const SizedBox(height: 16),
                  const Text(
                    '— Побережье и Юг —',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _linkButton(
                      'Буддийский храм (пережил цунами)',
                      'https://maps.app.goo.gl/msaB4bC5hAF58Bdj9?g_st=ipc',
                      Icons.temple_hindu),
                  _linkButton(
                      'Форт Галле (Английская деревушка)',
                      'https://maps.app.goo.gl/R1ctCR7iLYWkX82r7?g_st=ipc',
                      Icons.fort),
                  _linkButton(
                      'Хороший отель в Велигаме (Scenic Bay)',
                      'https://maps.app.goo.gl/vHULP6yFapLUkAP28?g_st=ipc',
                      Icons.hotel_outlined),
                  _linkButton(
                      'Secret Beach (Уединенный пляж)',
                      'https://maps.app.goo.gl/vEHDYEityydGsVqG8?g_st=ipc',
                      Icons.beach_access),
                  _linkButton(
                      'Мирисса Бич (Покупаться, гора попугаев)',
                      'https://maps.app.goo.gl/FTmk9zrmPFxKDJUk6?g_st=ipc',
                      Icons.paragliding),
                  _linkButton(
                      'Музей Цунами (Хиккадува)',
                      'https://maps.app.goo.gl/cYaftMwWcWzvehhL8?g_st=ipc',
                      Icons.museum),
                  const SizedBox(height: 16),
                  const Text(
                    '— Центр (Экскурсионные точки) —',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _linkButton(
                      'Деревня в горах Элла',
                      'https://maps.app.goo.gl/ppYdoqK82KbKwq3DA?g_st=ipc',
                      Icons.apartment),
                  _linkButton(
                      '9-арочный мост (Прогулка)',
                      'https://maps.app.goo.gl/iXDdHcCs9pqDYty7A?g_st=ipc',
                      Icons.badge),
                  _linkButton(
                      'Водопад Равана',
                      'https://maps.app.goo.gl/6SgD8vJv3ywafPSz7?g_st=ipc',
                      Icons.water_drop),
                  _linkButton(
                      'Слоновий заповедник',
                      'https://maps.app.goo.gl/obTfejxDT41anxtb8?g_st=ipc',
                      Icons.pets),
                  _linkButton(
                      'Башня Амбулувава (Вид на весь остров)',
                      'https://maps.app.goo.gl/3tn7VtMeuLQo5PB1A?g_st=ipc',
                      Icons.stairs),
                  _linkButton(
                      'Английская деревня (Нувара-Элия)',
                      'https://maps.app.goo.gl/LhPixjauhQWUeEFA9?g_st=ipc',
                      Icons.golf_course),
                ],
              ),
            ),

            const SizedBox(height: 60),

// <<< КОМПОНЕНТЫ ЗАВЕРШЕНИЯ СТАТЬИ >>>
            const Align(
              alignment: Alignment.center,
              child: Text("Как вам статья?", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            const Center(
              child: ReactionsWidget(
                articleRouteName: PostSriLankaPage.name,
              ),
            ),
            const SizedBox(height: 60),
            divider(context),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Шри-Ланка"),
                Tag(tag: "Путешествия"),
                Tag(tag: "Сёрфинг"),
                Tag(tag: "Цейлон"),
              ]),
            ),
            const SizedBox(height: 20),
            const ShareButtonsBlock(),
            const SizedBox(height: 40),

            const CommentsSection(
              articleRouteName: PostSriLankaPage.name,
            ),
            const SizedBox(height: 60),

            const RelatedArticles(
              currentArticleRouteName: PostSriLankaPage.name,
              category: 'travel', // категория для подбора похожих статей
            ),
            const SizedBox(height: 40),
            // Блок с личными ссылками
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 40.0),
                child: RichText(
                  text: TextSpan(
                    style: bodyTextStyle(context),
                    children: [
                      const TextSpan(
                        text:
                            "Если вам понравилась эта статья, вы можете поддержать меня в моем телеграм канале ",
                      ),
                      _link("@shastovscky", "https://t.me/shastovscky"),
                      const TextSpan(
                        text: " или подписаться на меня в инстаграм ",
                      ),
                      _link("@yellolwapple",
                          "https://instagram.com/yellolwapple"),
                      const TextSpan(
                        text:
                            " (запрещенная в РФ организация), где я делюсь фото и видео из своих поездок.",
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
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Шри-Ланка"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...authorSection(
              context: context,
              imageUrl: "assets/images/avatar_default.webp",
              name: "Автор: Шастовский Даниил",
              bio:
                  "Автор и фотограф этой статьи. Люблю исследовать неочевидные маршруты и делиться практическими советами.",
            ),
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Container(),
            ),
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

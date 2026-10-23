// lib/pages/travel_posts/page_jordan_post.dart

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
// <<< ШАГ 1: Добавляем импорт семантических виджетов >>>
import 'package:minimal/components/semantic_widgets.dart';

class PostJordanPage extends StatefulWidget {
  static const String name = 'jordan';
  const PostJordanPage({super.key});

  @override
  State<PostJordanPage> createState() => _PostJordanPageState();
}

class _PostJordanPageState extends State<PostJordanPage> {
  final List<String> _pageImages = [
    "assets/images/jordan/jordan-banner.webp", // Главная картинка
    "assets/images/avatar_default.webp",
    "assets/images/jordan/breakfast_amman.webp", //
    "assets/images/jordan/activia_arabic.webp", //
    "assets/images/jordan/amman_city_1.webp", //
    "assets/images/jordan/amman_city_2.webp", //
    "assets/images/jordan/amman_city_3.webp", //
    "assets/images/jordan/amman_city_4.webp", //
    "assets/images/jordan/amman_city_5.webp", //
    "assets/images/jordan/amman_city_6.webp", //
    "assets/images/jordan/amman_city_7.webp", //
    "assets/images/jordan/amman_city_8.webp", //
    "assets/images/jordan/amman_city.webp", //
    "assets/images/jordan/camels_mirror_2.webp", //
    "assets/images/jordan/camels_mirror.webp",
    "assets/images/jordan/cats_amman_city_1.webp",
    "assets/images/jordan/cats_amman_city_2.webp",
    "assets/images/jordan/cats_amman_city.webp",
    "assets/images/jordan/cats_dead_sea.webp", //
    "assets/images/jordan/dana_sheeps.webp",
    "assets/images/jordan/dasha_workout.webp",
    "assets/images/jordan/dead_sea_dasha.webp",
    "assets/images/jordan/dead_sea_hotel.webp",
    "assets/images/jordan/dead_sea_me_1.webp",
    "assets/images/jordan/dead_sea_me.webp",
    "assets/images/jordan/dead_sea_view.webp",
    "assets/images/jordan/dead_sea_way.webp",
    "assets/images/jordan/hotel_roof_amman_1.webp",
    "assets/images/jordan/hotel_roof_amman.webp", // Вид с крыши отеля в Аммане
    "assets/images/jordan/i_love_petra.webp",
    "assets/images/jordan/ikea.webp",
    "assets/images/jordan/jordan-banner.webp",
    "assets/images/jordan/kchau.webp",
    "assets/images/jordan/local_donkey.webp",
    "assets/images/jordan/lunch_trip_deadsea.webp", //
    "assets/images/jordan/me_chips.webp", //
    "assets/images/jordan/morning_dead_sea_view.webp", //
    "assets/images/jordan/my_mom_restauran_reciept.webp",
    "assets/images/jordan/panorama.webp",
    "assets/images/jordan/petra_1.webp",
    "assets/images/jordan/petra_2.webp",
    "assets/images/jordan/petra_3.webp",
    "assets/images/jordan/petra_4.webp",
    "assets/images/jordan/petra_5.webp",
    "assets/images/jordan/petra_6.webp", //
    "assets/images/jordan/petra_7.webp",
    "assets/images/jordan/petra_8.webp",
    "assets/images/jordan/petra_al_hazna.webp",
    "assets/images/jordan/petra_coffee.webp",
    "assets/images/jordan/petra_dasha_1.webp",
    "assets/images/jordan/petra_dasha_2.webp",
    "assets/images/jordan/petra_dasha_hazna_1.webp", //
    "assets/images/jordan/petra_dasha_hazna.webp",
    "assets/images/jordan/petra_dasha.webp",
    "assets/images/jordan/petra_donkey.webp",
    "assets/images/jordan/petra_horse.webp",
    "assets/images/jordan/Petra_map.webp",
    "assets/images/jordan/petra_me.webp",
    "assets/images/jordan/petra_sunset.webp",
    "assets/images/jordan/petra_way_to_ad_deir.webp",
    "assets/images/jordan/petra.webp",
    "assets/images/jordan/ranorama_2.webp",
    "assets/images/jordan/samara_finiki.webp",
    "assets/images/jordan/we_are_pickup.webp", //
    "assets/images/jordan/wadi_rum_1.webp",
    "assets/images/jordan/wadi_rum_2.webp",
    "assets/images/jordan/wadi_rum_3.webp",
    "assets/images/jordan/wadi_rum_4.webp",
    "assets/images/jordan/wadi_rum_5.webp",
    "assets/images/jordan/wadi_rum_6.webp",
    "assets/images/jordan/wadi_rum_7.webp",
    "assets/images/jordan/wadi_rum_8.webp",
    "assets/images/jordan/wadi_rum_9.webp", //
    "assets/images/jordan/wadi_rum_camel.webp",
    "assets/images/jordan/wadi_rum_cat_1.webp",
    "assets/images/jordan/wadi_rum_cat_2.webp",
    "assets/images/jordan/wadi_rum_cat.webp",
    "assets/images/jordan/wadi_rum_chill.webp",
    "assets/images/jordan/wadi_rum_dasha.webp",
    "assets/images/jordan/wadi_rum_me_dasha.webp",
    "assets/images/jordan/wadi_rum_me_sandboard.webp",
    "assets/images/jordan/wadi_rum_me.webp",
    "assets/images/jordan/wadi_rum_morning.webp",
    "assets/images/jordan/wadi_rum_road.webp",
    "assets/images/jordan/wadi_rum_stars.webp",
    "assets/images/jordan/wadi_rum_sunset.webp",
    "assets/images/jordan/wadi_rum.webp",
    "assets/images/jordan/way_to_Petra_2.webp",
    "assets/images/jordan/way_to_Petra_3.webp",
    "assets/images/jordan/way_to_petra.webp",
    "assets/images/jordan/we_are.webp", //
    "assets/images/jordan/we_hotel_amman.webp",
  ];

  // <<< ШАГ 2: Добавляем флаг для определения режима рендеринга >>>
  bool _isPrerendering = false;

  // Хелпер для создания пути к превью
  String _getThumbPath(String fullPath) {
    final int extensionIndex = fullPath.lastIndexOf('.webp');
    if (extensionIndex == -1) return fullPath;
    return '${fullPath.substring(0, extensionIndex)}_thumb.webp';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // <<< ИСПРАВЛЕНИЕ: Кэшируем превью-версии >>>
    for (final imagePath in _pageImages) {
      precacheImage(AssetImage(_getThumbPath(imagePath)), context);
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
      title: "Иордания. От Мертвого моря до песков Арракиса",
      description:
          "Честный и подробный гид по путешествию в Иорданию. Цены, отели, Jordan Pass, аренда авто и нетуристические впечатления.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/jordan/jordan-banner.webp",
    );
  }

  // <<< ШАГ 4: Новый метод для генерации семантического контента >>>
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("Иордания. От Мертвого моря до песков Арракиса"),
        SemanticP(
            "Честный гид по стране, недооцененной российскими туристами. Здесь про цены, отели, лайфхаки и, конечно, про запах ослов в Петре."),
        SemanticImg(
            src: "assets/images/jordan/jordan-banner.webp",
            alt: "Пустыня Вади-Рам в Иордании"),
        SemanticH2("Ключевые моменты для подготовки"),
        SemanticP(
            "Jordan Pass — обязательно к покупке. Это ультимативное решение, которое экономит и время, и деньги. Включает в себя стоимость визы (которая отдельно стоит ~55 JOD) и вход почти во все туристические локации, включая дорогую Петру и пустыню Вади-Рам. Мы брали за 75 JOD. Даже если визы отменят, берите Pass — он точно окупится."),
        SemanticP(
            "Аренда авто — свобода передвижения. Брать машину обязательно. Общественный транспорт развит слабо, а такси между городами обойдется в целое состояние. Мы арендовали Hyundai Elantra 2023 года на 7 дней примерно за 310 JOD (~468 USD) + залог 200 JOD (~280 USD). Машины поменьше (Kia Rio) обойдуся вдвое дешевле. Дороги хорошие, но местные водят агрессивно."),
        SemanticP(
            "Деньги: динары, карты и комиссии. Местная валюта — иорданский динар (JOD). Курс примерно 1 JOD ≈ 1.4 USD. Карты принимают в отелях и крупных магазинах, но наличные нужны всегда. Я снимал с карт Таджикистана и Казахстана — любой банкомат берет фиксированную комиссию 5 JOD за операцию, независимо от суммы. Так что выгоднее снимать сразу крупную сумму."),
        SemanticP(
            "Спойлер: весь маршрут, все ссылки, цены и итоговый бюджет поездки вы найдете в конце статьи."),
        SemanticH2("Глава 1: Амман — гостеприимный хаос"),
        SemanticP(
            "Прилетели Jordan Aviation — старый, грязный самолет, в котором в какой-то момент запахло сигаретами. Но долетели. Паспортный контроль прошли мгновенно, единственные вопросы — откуда и название отеля."),
        SemanticP(
            "Такси из аэропорта — самое дорогое в моей жизни: 36 JOD (~50 USD) за 40 минут. Uber не принимал российские карты Visa. Готовьте наличные или ищите альтернативы."),
        SemanticImg(
            src: "assets/images/jordan/we_hotel_amman.webp",
            alt: "Отель в Аммане"),
        SemanticP(
            "Отель в Аммане лучше всего брать в центре. Мы остановились в Gallery Guest House. Сам отель немного староват, но с потрясающей террасой на крыше, ОЧЕНЬ ВКУСНЫМИ завтраками и идеальным расположением. Вокруг — живой, аутентичный арабский район с рынками, кафе и ресторанами, где кипит настоящая жизнь. Центр города, что сказать..."),
        SemanticP(
            "Девушкам одним может быть не очень комфортно из-за повышенного внимания, но в целом люди очень приятные и вежливые. Еда вкусная! Мы пообедали в Faisal cafe restaurant. Обязательно попробуйте маклубу — национальное блюдо из риса с мясом и овощами, которое подают, переворачивая казан."),
        SemanticImg(
            src: "assets/images/jordan/amman_city_3.webp",
            alt: "Улицы города Амман"),
        SemanticH2("Глава 2: Мертвое море — соленая колыбель цивилизации"),
        SemanticP(
            "Дорога из Аммана к Мертвому морю невероятно красива, но удручает количество мусора по обочинам. К сожалению, культура чистоты здесь пока не прижилась. Сам отель охраняется как военная база: заборы, шлагбаумы, сканеры на входе."),
        SemanticP(
            "Остановились в Grand East Hotel за 80JOD на ночь. Четыре звезды с вайбом пятизвездочного отеля из 80-х. Главный плюс — собственный выход к морю. Это критически важно: почти все пляжи частные, и без своего придется платить за вход на чужой."),
        SemanticImg(
            src: "assets/images/jordan/cats_dead_sea.webp",
            alt: "Кот на побережье Мертвого моря"),
        SemanticP(
            "Ощущения от плавания непередаваемые. Вода выталкивает тебя на поверхность, как пробку. Со стороны Иордании это скорее похоже на 'не очень пахнущую лужу', а вот со стороны Израиля берега покрыты кристаллами соли, что гораздо живописнее."),
        SemanticP(
            "Настоятельно рекомендую съездить, пока оно не высохло окончательно. Ученые говорят, это произойдет в ближайшие 50 лет. Будет что рассказать внукам!"),
        SemanticP(
            "Бонус: Эта поездка до петры есть в виде видео на моем YouTube-канале."),
        SemanticA(
            href: "https://youtu.be/Ev-Qy33qEho?si=dtb5nYXpMUgoPoXX",
            text: "Смотреть на YouTube"),
        SemanticImg(
            src: "assets/images/jordan/way_to_petra.webp",
            alt: "Дорога к Петре"),
        SemanticH2("Глава 3: Петра — величие, смешанное с запахом навоза"),
        SemanticP(
            "Визитная карточка Иордании и одно из Новых семи чудес света. Древняя столица Набатейского царства, вырубленная прямо в скалах. Путь к главному сокровищу, Эль-Хазне, лежит через узкий каньон Сик. Это невероятно атмосферная прогулка, где за каждым поворотом ждешь чуда. И оно происходит, когда в просвете скал появляется фасад сокровищницы."),
        SemanticP(
            "Совет: приезжайте в отель накануне вечером, а утром, в 8-10 утра, сразу после завтрака, отправляйтесь ко входу. Так вы избежите толп и полуденной жары. Нам хватило одного полного дня, чтобы обойти все основные точки и нашагать 23 тысячи шагов."),
        SemanticP(
            "Но есть один нюанс, о котором не пишут в путеводителях... ужасный запах. По всей территории, особенно на подъеме к Монастырю (800 ступеней), вас будут преследовать погонщики ослов. К сожалению, за животными никто не убирает. Дорога усыпана ослиным навозом, а в воздухе стоит стойкий запах мочи."),
        SemanticP(
            "На всем пути местные продавцы и 'гиды' очень назойливы. Будьте готовы постоянно говорить 'No, thanks'. Из-за усталости мы начали машинально отвечать так даже на приветливое 'Welcome!'. Несмотря на это, увидеть Петру своими глазами — бесценно. Величие этого места перекрывает все недостатки."),
        SemanticP(
            "Где поесть в Петре? После долгой прогулки обязательно зайдите в My Mom's Recipe Restaurant. Рекомендую взять Мансаф — национальное блюдо из баранины в соусе из ферментированного йогурта. Звучит странно, но на деле — очень вкусно и нежирно."),
        SemanticImg(
            src: "assets/images/jordan/petra_6.webp",
            alt: "Сокровищница Эль-Хазне в Петре"),
        SemanticH2("Глава 4: Пустыня Вади-Рам — хроники Арракиса"),
        SemanticP(
            "Покинув древние стены Петры, мы оказались на распутье. По плану следующей была пустыня, но всего в полутора часах езды манил единственный выход Иордании к морю — Акаба. Решение было принято спонтанно: заедем пообедать, посмотрим на Красное море и оттуда уже в Вади-Рам. Этот крюк изменил все наши планы на остаток поездки."),
        SemanticP(
            "Важный урок: город Акаба и курортная зона на южном побережье — это два разных мира. Мы поехали в город, в то время как все дорогие отели, коралловые рифы и туристическая жизнь для снорклинга и дайвинга находятся южнее, вдоль побережья."),
        SemanticP(
            "Сам город Акаба произвел впечатление скорее портового и пустого городка, нежели курорта. Улицы показались нам пустынными, торговые центры — вымершими. Мы честно обошли несколько в поисках жизни (и магазинов), но без особого успеха. Кульминацией стал мемный поиск H&M, который, как показал навигатор, находился всего в 30 минутах езды... в соседней стране, в израильском Эйлате. Стало ясно, что шоппинг отменяется."),
        SemanticImg(
            src: "assets/images/jordan/petra_dasha_hazna.webp",
            alt: "Фото из Петры"),
        SemanticP(
            "Именно в этот момент, пообедав в местном кафе, мы приняли лучшее решение за всю поездку. Вместо того чтобы искать правильное побережье и отельную жизнь, мы решили полностью погрузиться в то, за чем действительно ехали — в тишину и величие пустыни. Закупившись продуктами в гипермаркете на три дня, мы развернули машину и поехали навстречу марсианским пейзажам Вади-Рам."),
        SemanticP(
            "Логистика заезда в пустыню. Все НЕ очень просто. Вы доезжаете до небольшой деревни на краю заповедника, оставляете машину на специальной парковке, а дальше вас забирает представитель лагеря. Наше приключение началось с поездки в кузове старенького пикапа — с вещами, смехом и подпрыгиваниями на каждой кочке. Это было как в кино!"),
        SemanticP(
            "Первая ночь — магия. Абсолютная тишина, нарушаемая лишь треском костра, и невероятное звездное небо, какого не увидишь в городе. Местная кошка, как нам объяснили, здесь не для уюта, а для ловли змей и скорпионов — полезный член команды."),
        SemanticP(
            "Вечером мы познакомились с большой компанией местных — иорданцев, сирийцев, палестинцев. Многие из них — беженцы, нашедшие в Иордании мирный дом. С нами весь вечер проболтал иорданец Али, отлично говорящий по-русски, пока мы курили местный кальян и пили виски. Алкоголь в Иордании почти нигде не продается, но, как оказалось, местные охотно его пьют, если привезти с собой."),
        SemanticImg(
            src: "assets/images/jordan/wadi_rum_road.webp",
            alt: "Дорога в пустыню Вади-Рам"),
        SemanticP(
            "На второй день мы взяли шестичасовую экскурсию на пикапе по пустыне. С нами была пара очень приятных немцев, которые в какой-то момент с неподдельным удивлением расспрашивали нас про блокировки мессенджеров и сайтов в России."),
        SemanticP(
            "Наш водитель был одновременно и поваром. Он готовил нам традиционную бедуинскую еду прямо на костре в глиняном котелке, мы кормили с рук диких верблюдов, а закончился день на идеальной точке посреди песков, где мы провожали ярко-красный закат, попивая свежезаваренный чай."),
        SemanticImg(
            src: "assets/images/jordan/wadi_rum_9.webp",
            alt: "Пейзаж пустыни Вади-Рам"),
        SemanticP(
            "Третий день был посвящен абсолютному ничегонеделанию. Я катался на сэндборде (как сноуборд, только по дюнам), а вечером мы смотрели «Дюну», снятую в этих самых местах. Это был идеальный отдых для души и мыслей."),
        SemanticImg(
            src: "assets/images/jordan/wadi_rum_me_sandboard.webp",
            alt: "Сэндбординг в Вади-Рам"),
        SemanticH2("Глава 5: Дана и возвращение в Амман"),
        SemanticP(
            "Насытившись пустыней, мы поехали в сторону Аммана, решив заехать в заповедник Дана(просто потому что это было +- на середине пути до Аммана и новый маршрут). Мы заселились в маленький отель в горной деревушке и с удивлением узнали, что основная цель туристов здесь — хайкинг. Управляющий отелем, услышав, что мы не знали об этом, с иронией спросил:"),
        SemanticP("«А нахрена вы сюда вообще приехали?»"),
        SemanticP(
            "Это было смешно и очень точно описывало многих молодых иорданцев, с которыми мы общались — ироничные, веселые ребята, умеющие находить юмор даже в непростых ситуациях... Остановились мы в Dana Horizon Hotel."),
        SemanticImg(
            src: "assets/images/jordan/panorama.webp",
            alt: "Панорама заповедника Дана"),
        SemanticP(
            "На следующий день мы вернулись в Амман, сдали машину и, будучи еще не полностью уставшими, отправились в самый большой ТЦ города закупаться вещами и продуктами на предстоящую рабочую неделю."),
        SemanticH2("Эпилог и будущие планы"),
        SemanticP(
            "Это путешествие по Иордании стало настоящим открытием. Страна, где почти нет русских туристов, но есть невероятные пейзажи, древняя история и очень открытые люди. В планах на следующие выходные — съездить в древний римский город Джераш и, возможно, в Ас-Сальт. Об этом я, скорее всего, напишу отдельный короткий пост в своем телеграм-канале."),
        SemanticA(
            href: "https://t.me/shastovscky",
            text: "Телеграм-канал @shastovscky"),
        SemanticH2(
            "Полный маршрут, цены и ссылки от Даши (love you to the moon and back)"),
        SemanticP(
            "Ниже вы найдете детальный план нашего 9-дневного путешествия по Иордании с указанием всех отелей, кафе, цен и ссылок. Этот маршрут поможет вам спланировать собственное путешествие и избежать неожиданных расходов."),
        SemanticP('''
1. Пятница - Воскресенье: Амман
Отель: Gallery Guest House (с завтраками). Приятный, с террасой и отличным расположением.
Стоимость: 6800 руб. (за 2 ночи).
Еда: Faisal Cafe. Один прием пищи на двоих ~22 JOD (2860 руб.).

2. Воскресенье - Понедельник: Мертвое море
Выехали из Аммана, по пути заехали в Мадабу (город мозаик) и пообедали в Ayola Cafe.
Отель: Grand East Resort (с завтраком и частным пляжем). Обязательно берите отель с пляжем!
Стоимость: 8610 руб. (за ночь).
Ужин: Шведский стол в отеле, 15 JOD на человека (1950 руб.).

3. Понедельник - Среда: Петра
Дорога от Мертвого моря заняла ~3.5 часа чистого времени. Все останавливаются в городе Вади-Муса.
Отель: 7Wonders Hotel by TREND (с завтраками). Был далековато от входа, без машины не рекомендую.
Стоимость: 10100 руб. (за 2 ночи).
Еда:
Кофе: AL Capone Coffee.
Ланч-боксы в Петре: ~18 JOD за двоих (2340 руб.).
Ужин: My Mom's Recipe Restaurant. Обязательно попробуйте Мансаф!

4. Среда - Суббота: Пустыня Вади-Рам
Изначально планировали одну ночь, но остались на три — настолько там было хорошо. Акаба разочаровала.
Отель: Desert Magic Camp & Resort (с завтраками). Машину нужно оставить на парковке, в лагерь везут на пикапе.
Стоимость: 50 JOD (6500 руб.) за 3 ночи на двоих.
Ужин в лагере: 13 JOD на человека (1690 руб.). Мы брали два раза.
Экскурсия по пустыне: 6 часов на пикапе с обедом — 33 JOD на человека (4290 руб.).
Итого в пустыне на двоих: 50 (жилье) + 52 (2 ужина) + 66 (экскурсия) = 168 JOD (21840 руб.).

5. Суббота - Воскресенье: Заповедник Дана
Остановка на полпути в Амман. Место для любителей хайкинга.
Отель: Dana Horizon Hotel (с очень простым завтраком).
Стоимость: 2500 руб. (за ночь).
Дополнительно: Кофе и кальян в отеле обошлись в 36 JOD (4680 руб.).

Итоговый бюджет на 9 дней (на двоих, без авиабилетов):
Jordan Pass: 9100 руб. x 2 = 18200 руб.
Аренда авто: 468 USD (~43000 руб.)
Залог за авто (возвратный): 300 USD (~27600 руб.)
Бензин: 60 JOD (~7800 руб.)
Проживание (Амман, М.море, Петра, В.Рам, Дана): ~34500 руб.
Еда, ужины, экскурсия: ~45000 руб.
Такси из аэропорта: 4500 руб.
Снятие наличных (комиссии): ~2100 руб.
Примерная общая сумма: ~155,000 рублей на двоих.
Это без учета квартиры в Аммане после поездки и прочих личных трат.
'''),
      ],
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

  @override
  Widget build(BuildContext context) {
    // <<< ШАГ 5: Добавляем условную логику в метод build >>>
    if (_isPrerendering) {
      // Оборачиваем в Material и SingleChildScrollView для базовой структуры
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    // Ваш обычный код для UI
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
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
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Иордания"),
              ]),
            ),
            const SizedBox(height: 40),
            // 1. Дата публикации (над заголовком)
            Center(
              child: Text(
                // дата публикации
                DateFormat.yMMMMd('ru_RU').format(DateTime(2025, 10, 27)),
                style: bodyTextStyle(context).copyWith(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 3. Время чтения и счетчик просмотров (под заголовком)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "~25 минут чтения", // примерное время
                  style: subtitleTextStyle(context).copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40), // Увеличиваем отступ перед интро
            Text("Иордания. От Мертвого моря до песков Арракиса",
                style: headlineTextStyle(context), textAlign: TextAlign.center),

            const SizedBox(height: 16),

            Text(
              "Честный гид по стране, недооцененной российскими туристами. Здесь про цены, отели, лайфхаки и, конечно, про запах ослов в Петре.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const ImageCarousel(images: [
              "assets/images/jordan/jordan-banner.webp",
              "assets/images/jordan/camels_mirror_2.webp",
              "assets/images/jordan/hotel_roof_amman.webp",
              "assets/images/jordan/petra_6.webp",
              "assets/images/jordan/petra_dasha_hazna_1.webp",
              "assets/images/jordan/we_are_pickup.webp",
              "assets/images/jordan/wadi_rum_9.webp",
              "assets/images/jordan/wadi_rum_chill.webp",
              "assets/images/jordan/wadi_rum_me_dasha.webp",
              "assets/images/jordan/we_are.webp",
            ]),
            const TextHeadlineSecondary(
                text: "Ключевые моменты для подготовки"),
            const SizedBox(height: 16),
            const FeatureTile(
              icon: Icons.qr_code_scanner,
              title: "Jordan Pass — обязательно к покупке",
              content:
                  "Это ультимативное решение, которое экономит и время, и деньги. Включает в себя стоимость визы (которая отдельно стоит ~55 JOD) и вход почти во все туристические локации, включая дорогую **Петру** и пустыню **Вади-Рам**. Мы брали за 75 JOD. Даже если визы отменят, берите Pass — он точно окупится.",
            ),
            FeatureTile(
              icon: Icons.directions_car,
              title: "Аренда авто — свобода передвижения",
              content:
                  "Брать машину **обязательно**. Общественный транспорт развит слабо, а такси между городами обойдется в целое состояние. Мы арендовали Hyundai Elantra 2023 года на 7 дней примерно за **310 JOD (~468 USD)** + залог **200 JOD (~280 USD)**. Машины поменьше (Kia Rio) обойдутся вдвое дешевле. Дороги хорошие, но местные водят агрессивно.",
              actionButton: ElevatedButton.icon(
                onPressed: () => launchUrl(
                    Uri.parse('https://maps.app.goo.gl/U6vfuGwVfy8kMT2N9')),
                icon: const Icon(Icons.location_on_outlined),
                label: const Text("Наш прокат в Аммане"),
              ),
            ),
            const FeatureTile(
              icon: Icons.attach_money,
              title: "Деньги: динары, карты и комиссии",
              content:
                  "Местная валюта — иорданский динар (JOD). Курс примерно **1 JOD ≈ 1.4 USD**. Карты принимают в отелях и крупных магазинах, но наличные нужны всегда. Я снимал с карт Таджикистана и Казахстана — любой банкомат берет фиксированную комиссию **5 JOD** за операцию, независимо от суммы. Так что выгоднее снимать сразу крупную сумму.",
            ),
            const SizedBox(height: 10),
            const TextBlockquote(
                text:
                    "*Спойлер*: весь маршрут, все ссылки, цены и итоговый бюджет поездки вы найдете в конце статьи."),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 1: Амман — гостеприимный хаос"),
            const TextBody(
                text:
                    "Прилетели Jordan Aviation — старый, грязный самолет, в котором в какой-то момент запахло сигаретами. Но долетели. Паспортный контроль прошли мгновенно, единственные вопросы — откуда и название отеля."),
            const TextBlockquote(
                text:
                    "Такси из аэропорта — самое дорогое в моей жизни: 36 JOD (~50 USD) за 40 минут. Uber не принимал российские карты Visa. Готовьте наличные или ищите альтернативы."),
            const SizedBox(height: 40),
            const ImageCarousel(images: [
              "assets/images/jordan/we_hotel_amman.webp",
              "assets/images/jordan/breakfast_amman.webp",
              "assets/images/jordan/activia_arabic.webp",
              "assets/images/jordan/hotel_roof_amman_1.webp",
              "assets/images/jordan/cats_amman_city.webp",
              "assets/images/jordan/cats_amman_city_1.webp",
              "assets/images/jordan/cats_amman_city_2.webp",
              "assets/images/jordan/amman_city.webp",
              "assets/images/jordan/amman_city_1.webp",
              "assets/images/jordan/amman_city_2.webp",
            ]),
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Отель в Аммане лучше всего брать в центре. Мы остановились в "),
                  _link("Gallery Guest House",
                      "https://maps.app.goo.gl/dYCieCDzGz4DipBc6"),
                  const TextSpan(
                      text:
                          ". Сам отель немного староват, но с потрясающей террасой на крыше, ОЧЕНЬ ВКУСНЫМИ завтраками и идеальным расположением. Вокруг — живой, аутентичный арабский район с рынками, кафе и ресторанами, где кипит настоящая жизнь. Центр города, что сказать..."),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Девушкам одним может быть не очень комфортно из-за повышенного внимания, но в целом люди очень приятные и вежливые.\n\n Еда вкусная! Мы пообедали в "),
                  _link("Faisal cafe restaurant",
                      "https://maps.app.goo.gl/XBsMDFZUmWaWawfaA?g_st=ipc"),
                  const TextSpan(
                      text:
                          ". Обязательно попробуйте маклубу — национальное блюдо из риса с мясом и овощами, которое подают, переворачивая казан."),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Еще немного Аммана:",
                style: subtitleTextStyle(context).copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const ImageCarousel(images: [
              "assets/images/jordan/amman_city_3.webp",
              "assets/images/jordan/amman_city_4.webp",
              "assets/images/jordan/amman_city_5.webp",
              "assets/images/jordan/amman_city_6.webp",
              "assets/images/jordan/amman_city_7.webp",
              "assets/images/jordan/amman_city_8.webp",
              "assets/images/jordan/lunch_trip_deadsea.webp",
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 2: Мертвое море — соленая колыбель цивилизации"),
            const TextBody(
                text:
                    "Дорога из Аммана к Мертвому морю невероятно красива, но удручает количество мусора по обочинам. К сожалению, культура чистоты здесь пока не прижилась. Сам отель охраняется как военная база: заборы, шлагбаумы, сканеры на входе."),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(text: "Остановились в "),
                  _link("Grand East Hotel",
                      "https://maps.app.goo.gl/eJ85WqAwiMidVVYo8"),
                  const TextSpan(
                      text:
                          " за 80JOD на ночь. Четыре звезды с вайбом пятизвездочного отеля из 80-х. Главный плюс — собственный выход к морю. Это критически важно: почти все пляжи частные, и без своего придется платить за вход на чужой."),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ImageCarousel(images: [
              "assets/images/jordan/cats_dead_sea.webp",
              "assets/images/jordan/morning_dead_sea_view.webp",
              "assets/images/jordan/dead_sea_hotel.webp",
              "assets/images/jordan/dead_sea_me.webp",
              "assets/images/jordan/dead_sea_me_1.webp",
              "assets/images/jordan/dead_sea_dasha.webp",
              "assets/images/jordan/dead_sea_view.webp",
              "assets/images/jordan/dasha_workout.webp",
              "assets/images/jordan/morning_dead_sea_view.webp",
            ]),
            const SizedBox(height: 30),
            const TextBody(
                text:
                    "Ощущения от плавания непередаваемые. Вода выталкивает тебя на поверхность, как пробку. Со стороны Иордании это скорее похоже на 'не очень пахнущую лужу', а вот со стороны Израиля берега покрыты кристаллами соли, что гораздо живописнее."),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Настоятельно рекомендую съездить, пока оно не высохло окончательно. Ученые говорят, это произойдет в ближайшие 50 лет. Будет что рассказать внукам! Подробнее о том, почему море такое соленое и почему оно исчезает, можно прочитать "),
                  TextSpan(
                    text: "здесь.",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Почему море Мертвое?",
                          markdownContent:
                              "**Высокая соленость:** Мертвое море — это бессточное озеро, в которое впадает река Иордан и несколько мелких ручьев. Вода из него никуда не вытекает, а только испаряется под жарким солнцем. Минералы и соли, приносимые реками, остаются и накапливаются тысячелетиями. Концентрация соли здесь достигает 34-35%, что почти в 10 раз выше, чем в обычном океане.\n\n**Почему исчезает:** Главная причина — деятельность человека. Воды реки Иордан и других притоков активно разбираются на сельскохозяйственные нужды Израилем и Иорданией. До озера доходит лишь малая часть воды, и уровень испарения стал значительно превышать уровень притока. Каждый год уровень моря падает примерно на 1 метр."),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Бонус: Эта поездка до петры есть в виде видео на моем "),
                  _link("YouTube-канале.",
                      "https://youtu.be/Ev-Qy33qEho?si=dtb5nYXpMUgoPoXX"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Красивые виды по дороге к Петре:",
                style: subtitleTextStyle(context).copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const ImageCarousel(images: [
              "assets/images/jordan/way_to_petra.webp",
              "assets/images/jordan/dead_sea_way.webp",
              "assets/images/jordan/way_to_Petra_2.webp",
              "assets/images/jordan/way_to_Petra_3.webp",
              "assets/images/jordan/local_donkey.webp",
              "assets/images/jordan/camels_mirror_2.webp",
              "assets/images/jordan/camels_mirror.webp",
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 3: Петра — величие, смешанное с запахом навоза"),
            const TextBody(
                text:
                    "Визитная карточка Иордании и одно из Новых семи чудес света. Древняя столица Набатейского царства, вырубленная прямо в скалах. Путь к главному сокровищу, Эль-Хазне, лежит через узкий каньон Сик. Это невероятно атмосферная прогулка, где за каждым поворотом ждешь чуда. И оно происходит, когда в просвете скал появляется фасад сокровищницы."),
            const TextBlockquote(
                text:
                    "Совет: приезжайте в отель накануне вечером, а утром, в 8-10 утра, сразу после завтрака, отправляйтесь ко входу. Так вы избежите толп и полуденной жары. Нам хватило одного полного дня, чтобы обойти все основные точки и нашагать 23 тысячи шагов."),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Но есть один нюанс, о котором не пишут в путеводителях... "),
                  TextSpan(
                    text: "ужасный запах.",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Ложка дегтя (и не только)",
                          markdownContent:
                              "По всей территории, особенно на подъеме к Монастырю (800 ступеней), вас будут преследовать погонщики ослов. К сожалению, за животными никто не убирает. Дорога усыпана ослиным навозом, а в воздухе стоит стойкий запах мочи. Приходится смотреть под ноги, чтобы не вляпаться, вместо того чтобы наслаждаться видами. Это сильно портит впечатление от второй половины пути."),
                  ),
                ],
              ),
            ),
            const TextBody(
                text:
                    "На всем пути местные продавцы и 'гиды' очень назойливы. Будьте готовы постоянно говорить 'No, thanks'. Из-за усталости мы начали машинально отвечать так даже на приветливое 'Welcome!'.\n\nНесмотря на это, увидеть Петру своими глазами — бесценно. Величие этого места перекрывает все недостатки."),
            FeatureTile(
              icon: Icons.restaurant_menu,
              title: "Где поесть в Петре?",
              content:
                  "После долгой прогулки обязательно зайдите в **My Mom's Recipe Restaurant**. Рекомендую взять **Мансаф** — национальное блюдо из баранины в соусе из ферментированного йогурта. Звучит странно, но на деле — очень вкусно и нежирно. (spoiler: Цены на последнем фото ниже)",
              actionButton: ElevatedButton.icon(
                onPressed: () => launchUrl(
                    Uri.parse('https://maps.app.goo.gl/dCkzfovg994v5xss7')),
                icon: const Icon(Icons.location_on_outlined),
                label: const Text("Ресторан на карте"),
              ),
            ),
            const ImageCarousel(images: [
              "assets/images/jordan/petra_6.webp", //
              "assets/images/jordan/i_love_petra.webp",
              "assets/images/jordan/petra.webp",
              "assets/images/jordan/petra_1.webp",
              "assets/images/jordan/petra_2.webp",
              "assets/images/jordan/petra_dasha_1.webp",
              "assets/images/jordan/petra_dasha_2.webp",
              "assets/images/jordan/petra_3.webp",
              "assets/images/jordan/petra_4.webp",
              "assets/images/jordan/petra_5.webp",
              "assets/images/jordan/petra_7.webp",
              "assets/images/jordan/petra_8.webp",
              "assets/images/jordan/petra_al_hazna.webp",
              "assets/images/jordan/petra_coffee.webp",
            ]),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 4: Пустыня Вади-Рам — хроники Арракиса"),
            const TextBody(
                text:
                    "Покинув древние стены Петры, мы оказались на распутье. По плану следующей была пустыня, но всего в полутора часах езды манил единственный выход Иордании к морю — Акаба. Решение было принято спонтанно: заедем пообедать, посмотрим на Красное море и оттуда уже в Вади-Рам. Этот крюк изменил все наши планы на остаток поездки."),
            const TextBlockquote(
                text:
                    "Важный урок: город Акаба и курортная зона на южном побережье — это два разных мира. Мы поехали в город, в то время как все дорогие отели, коралловые рифы и туристическая жизнь для снорклинга и дайвинга находятся южнее, вдоль побережья."),
            const TextBody(
                text:
                    "Сам город Акаба произвел впечатление скорее портового и пустого городка, нежели курорта. Улицы показались нам пустынными, торговые центры — вымершими. Мы честно обошли несколько в поисках жизни (и магазинов), но без особого успеха. Кульминацией стал мемный поиск H&M, который, как показал навигатор, находился всего в 30 минутах езды... в соседней стране, в израильском Эйлате. Стало ясно, что шоппинг отменяется."),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Еще немного фото из Петры:",
                style: subtitleTextStyle(context).copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const ImageCarousel(images: [
              "assets/images/jordan/petra_dasha_hazna.webp",
              "assets/images/jordan/petra_dasha_hazna_1.webp", //
              "assets/images/jordan/petra_dasha.webp",
              "assets/images/jordan/petra_donkey.webp",
              "assets/images/jordan/petra_horse.webp",
              "assets/images/jordan/Petra_map.webp",
              "assets/images/jordan/petra_me.webp",
              "assets/images/jordan/petra_way_to_ad_deir.webp",
              "assets/images/jordan/my_mom_restauran_reciept.webp",
              "assets/images/jordan/petra_sunset.webp",
            ]),
            const SizedBox(height: 40),
            const TextBody(
                text:
                    "Именно в этот момент, пообедав в местном кафе, мы приняли лучшее решение за всю поездку. Вместо того чтобы искать правильное побережье и отельную жизнь, мы решили полностью погрузиться в то, за чем действительно ехали — в тишину и величие пустыни. Закупившись продуктами в гипермаркете на три дня, мы развернули машину и поехали навстречу марсианским пейзажам Вади-Рам."),

            const SizedBox(height: 24),
            FeatureTile(
              icon: Icons.local_parking_outlined,
              title: "Логистика заезда в пустыню",
              content:
                  "Все НЕ очень просто. Вы доезжаете до небольшой деревни на краю заповедника, оставляете машину на специальной парковке, а дальше вас забирает представитель лагеря. Наше приключение началось с поездки в кузове старенького пикапа — с вещами, смехом и подпрыгиваниями на каждой кочке. Это было как в кино!",
              actionButton: ElevatedButton.icon(
                onPressed: () => launchUrl(
                    Uri.parse('https://maps.app.goo.gl/Y1EiqG2HskyqdDCL9')),
                icon: const Icon(Icons.hotel_outlined),
                label: const Text("Наш лагерь в Вади-Рам за 75 JOD(~85 USD)"),
              ),
            ),
            const TextBody(
                text:
                    "Первая ночь — магия. Абсолютная тишина, нарушаемая лишь треском костра, и невероятное звездное небо, какого не увидишь в городе. Местная кошка, как нам объяснили, здесь не для уюта, а для ловли змей и скорпионов — полезный член команды."),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Вечером мы познакомились с большой компанией местных — иорданцев, сирийцев, палестинцев. Многие из них — беженцы, нашедшие в Иордании мирный дом. С нами весь вечер проболтал иорданец Али, отлично говорящий по-русски, пока мы курили местный кальян и пили виски. Алкоголь в Иордании почти нигде не продается, но, как оказалось, местные охотно его пьют, если привезти с собой. Узнать больше про этот опыт можно "),
                  TextSpan(
                    text: "здесь.",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Вечер с нашими соседями по планете",
                          markdownContent:
                              "**Кальян:** В отличие от привычных нам, местный кальян — это чистый, крепкий табак без ароматизаторов. Вкус очень необычный, с привкусом угля и самого табака. \n\n**Люди:** Удивительно, как в одном месте собрались люди из стольких горячих точек. Они делились своими историями, шутили и создавали атмосферу невероятного гостеприимства. Это был не туристический аттракцион, а настоящее погружение в культуру людей, с которыми мы живем так рядом и одновременно тааак далеко..."),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const ImageCarousel(images: [
              "assets/images/jordan/wadi_rum_road.webp",
              "assets/images/jordan/we_are_pickup.webp",
              "assets/images/jordan/wadi_rum_sunset.webp",
              "assets/images/jordan/wadi_rum_chill.webp",
              "assets/images/jordan/wadi_rum_cat.webp",
              "assets/images/jordan/wadi_rum_morning.webp",
              "assets/images/jordan/wadi_rum.webp",
            ]),
            const SizedBox(height: 24),
            const TextBody(
                text:
                    "На второй день мы взяли шестичасовую экскурсию на пикапе по пустыне. С нами была пара очень приятных немцев, которые в какой-то момент с неподдельным удивлением расспрашивали нас про блокировки мессенджеров и сайтов в России."),
            const TextBlockquote(
                text:
                    "Наш водитель был одновременно и поваром. Он готовил нам традиционную бедуинскую еду прямо на костре в глиняном котелке, мы кормили с рук диких верблюдов, а закончился день на идеальной точке посреди песков, где мы провожали ярко-красный закат, попивая свежезаваренный чай."),
            const ImageCarousel(images: [
              "assets/images/jordan/wadi_rum_1.webp",
              "assets/images/jordan/wadi_rum_2.webp",
              "assets/images/jordan/wadi_rum_3.webp",
              "assets/images/jordan/wadi_rum_4.webp",
              "assets/images/jordan/wadi_rum_5.webp",
              "assets/images/jordan/wadi_rum_6.webp",
              "assets/images/jordan/wadi_rum_7.webp",
              "assets/images/jordan/wadi_rum_8.webp",
              "assets/images/jordan/wadi_rum_9.webp", //
            ]),
            const SizedBox(height: 24),
            const TextBody(
                text:
                    "Третий день был посвящен абсолютному ничегонеделанию. Я катался на сэндборде (как сноуборд, только по дюнам), а вечером мы смотрели «Дюну», снятую в этих самых местах. Это был идеальный отдых для души и мыслей."),
            const SizedBox(height: 40),
            const ImageCarousel(images: [
              "assets/images/jordan/wadi_rum_camel.webp",
              "assets/images/jordan/wadi_rum_cat_1.webp",
              "assets/images/jordan/wadi_rum_cat_2.webp",
              "assets/images/jordan/wadi_rum_dasha.webp",
              "assets/images/jordan/wadi_rum_me_dasha.webp",
              "assets/images/jordan/wadi_rum_me_sandboard.webp",
              "assets/images/jordan/wadi_rum_me.webp",
              "assets/images/jordan/wadi_rum_stars.webp",
            ]),
            const SizedBox(height: 24),
            const TextHeadlineSecondary(
                text: "Глава 5: Дана и возвращение в Амман"),
            const TextBody(
                text:
                    "Насытившись пустыней, мы поехали в сторону Аммана, решив заехать в заповедник Дана(просто потому что это было +- на середине пути до Аммана и новый маршрут). Мы заселились в маленький отель в горной деревушке и с удивлением узнали, что основная цель туристов здесь — хайкинг. \n\nУправляющий отелем, услышав, что мы не знали об этом, с иронией спросил:"),
            const TextBlockquote(text: "«А нахрена вы сюда вообще приехали?»"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Это было смешно и очень точно описывало многих молодых иорданцев, с которыми мы общались — ироничные, веселые ребята, умеющие находить юмор даже в непростых ситуациях... Остановились мы в "),
                  _link("Dana Horizon Hotel.",
                      "https://maps.app.goo.gl/n7k5TuDXZ5SsHPYf9"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Еще чуть-чуть рандомных фото для послевкусия:",
                style: subtitleTextStyle(context).copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const ImageCarousel(images: [
              "assets/images/jordan/panorama.webp",
              "assets/images/jordan/ranorama_2.webp",
              "assets/images/jordan/dana_sheeps.webp",
              "assets/images/jordan/we_are.webp", //
              "assets/images/jordan/ikea.webp",
              "assets/images/jordan/samara_finiki.webp",
              "assets/images/jordan/kchau.webp",
              "assets/images/jordan/me_chips.webp", //
            ]),
            const SizedBox(height: 24),
            const TextBody(
                text:
                    "На следующий день мы вернулись в Амман, сдали машину и, будучи еще не полностью уставшими, отправились в самый большой ТЦ города закупаться вещами и продуктами на предстоящую рабочую неделю."),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(text: "Эпилог и будущие планы"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Это путешествие по Иордании стало настоящим открытием. Страна, где почти нет русских туристов, но есть невероятные пейзажи, древняя история и очень открытые люди. В планах на следующие выходные — съездить в древний римский город Джераш и, возможно, в Ас-Сальт. Об этом я, скорее всего, напишу отдельный короткий пост в своем "),
                  _link("телеграм-канале.", "https://t.me/shastovscky"),
                ],
              ),
            ),
            // <<< НОВЫЙ БЛОК: Детальный план и бюджет поездки >>>
            const SizedBox(height: 110),
            const TextHeadlineSecondary(
                text:
                    "Полный маршрут, цены и ссылки от Даши (love you to the moon and back)"),
            const TextBody(
                text:
                    "Ниже вы найдете детальный план нашего 9-дневного путешествия по Иордании с указанием всех отелей, кафе, цен и ссылок. Этот маршрут поможет вам спланировать собственное путешествие и избежать неожиданных расходов."),
            const SizedBox(height: 10),
            const FeatureTile(
              icon: Icons.map_outlined,
              title:
                  "Наш 9-дневный маршрут с бюджетом (нажмите, чтобы развернуть)",
              // Параметр `children` полностью убран.
              content: '''
### 1. Пятница - Воскресенье: Амман
*   **Отель:** [Gallery Guest House](https://maps.app.goo.gl/FQBag39EPXjrFbof6) (с завтраками). *Приятный, с террасой и отличным расположением.*
*   **Стоимость:** 6800 руб. (за 2 ночи).
*   **Еда:** [Faisal Cafe](https://maps.app.goo.gl/TXTKkUyJVP4oNZQd9). *Один прием пищи на двоих ~22 JOD (2860 руб.).*

### 2. Воскресенье - Понедельник: Мертвое море
*Выехали из Аммана, по пути заехали в **Мадабу** (город мозаик) и пообедали в [Ayola Cafe](https://maps.app.goo.gl/XozmJyqrNYfYXQGM9).*
*   **Отель:** [Grand East Resort](https://maps.app.goo.gl/hsDoZFbo4jhg8T2z9) (с завтраком и частным пляжем). *Обязательно берите отель с пляжем!*
*   **Стоимость:** 8610 руб. (за ночь).
*   **Ужин:** Шведский стол в отеле, 15 JOD на человека (1950 руб.).

### 3. Понедельник - Среда: Петра
*Дорога от Мертвого моря заняла ~3.5 часа чистого времени. Все останавливаются в городе **Вади-Муса**.*
*   **Отель:** [7Wonders Hotel by TREND](https://maps.app.goo.gl/1N3ENaZdh2qkNt9b8) (с завтраками). *Был далековато от входа, без машины не рекомендую.*
*   **Стоимость:** 10100 руб. (за 2 ночи).
*   **Еда:**
    *   Кофе: [AL Capone Coffee](https://maps.app.goo.gl/KgEdP8fx2grtSVdL9).
    *   Ланч-боксы в Петре: ~18 JOD за двоих (2340 руб.).
    *   Ужин: [My Mom's Recipe Restaurant](https://maps.app.goo.gl/zgAGNNWWkijhxKJw5). *Обязательно попробуйте **Мансаф**!*

### 4. Среда - Суббота: Пустыня Вади-Рам
*Изначально планировали одну ночь, но остались на три — настолько там было хорошо. Акаба разочаровала.*
*   **Отель:** [Desert Magic Camp & Resort](https://maps.app.goo.gl/XaNctvRPbQykYRrG9) (с завтраками). *Машину нужно оставить на парковке, в лагерь везут на пикапе.*
*   **Стоимость:** 50 JOD (6500 руб.) за 3 ночи на двоих.
*   **Ужин в лагере:** 13 JOD на человека (1690 руб.). Мы брали два раза.
*   **Экскурсия по пустыне:** 6 часов на пикапе с обедом — 33 JOD на человека (4290 руб.).
*   **Итого в пустыне на двоих:** 50 (жилье) + 52 (2 ужина) + 66 (экскурсия) = **168 JOD (21840 руб.)**.

### 5. Суббота - Воскресенье: Заповедник Дана
*Остановка на полпути в Амман. Место для любителей хайкинга.*
*   **Отель:** [Dana Horizon Hotel](https://maps.app.goo.gl/hxkiX3oq82H4B4hd6) (с очень простым завтраком).
*   **Стоимость:** 2500 руб. (за ночь).
*   **Дополнительно:** Кофе и кальян в отеле обошлись в 36 JOD (4680 руб.).

### Итоговый бюджет на 9 дней (на двоих, без авиабилетов):

*   **Jordan Pass:** 9100 руб. x 2 = **18200 руб.**
*   **Аренда авто:** 468 USD (~43000 руб.)
*   **Залог за авто (возвратный):** 300 USD (~27600 руб.)
*   **Бензин:** 60 JOD (~7800 руб.)
*   **Проживание (Амман, М.море, Петра, В.Рам, Дана):** ~34500 руб.
*   **Еда, ужины, экскурсия:** ~45000 руб.
*   **Такси из аэропорта:** 4500 руб.
*   **Снятие наличных (комиссии):** ~2100 руб.

#### **Примерная общая сумма: ~155,000 рублей на двоих.**
*Это без учета квартиры в Аммане после поездки и прочих личных трат.*
''',
            ),
            const SizedBox(height: 60),

// <<< НОВЫЙ БЛОК: Реакции >>>
            const Align(
              alignment: Alignment.center,
              child: Text("Как вам статья?", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            const Center(
              child: ReactionsWidget(
                articleRouteName: PostJordanPage.name,
              ),
            ),
            const SizedBox(height: 60),
            divider(context),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Иордания"),
                Tag(tag: "Путешествия"),
                Tag(tag: "Петра"),
                Tag(tag: "Вади-Рам"),
              ]),
            ),
            const SizedBox(height: 20),
            const ShareButtonsBlock(),
            const SizedBox(height: 40),

// <<< НОВЫЙ БЛОК: Комментарии >>>
            const CommentsSection(
              articleRouteName: PostJordanPage.name,
            ),
            const SizedBox(height: 60),

            const RelatedArticles(
              currentArticleRouteName: PostJordanPage.name,
              category: 'travel', // категория для подбора похожих статей
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Иордания"),
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

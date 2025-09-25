// lib/data/seo_tools_data.dart
import 'package:minimal/models/service_model.dart';

final List<SeoToolSection> seoToolSections = [
  // --- ВНУТРЕННЯЯ ОПТИМИЗАЦИЯ ---
  SeoToolSection(name: "Внутренняя оптимизация", categories: [
    SeoToolCategory(name: "Работа с текстами", services: [
      SeoToolService(
          name: "Text.ru",
          url: "https://text.ru/",
          comment: "Проверка уникальности"),
      SeoToolService(
          name: "Glavred",
          url: "https://glvrd.ru/",
          comment: "Читаемость и чистота текста"),
      SeoToolService(
          name: "Arsenkin Filter",
          url: "https://arsenkin.ru/tools/filter/",
          comment: "Проверка переоптимизации"),
      SeoToolService(
          name: "Text-HTML",
          url: "https://text-html.ru/",
          comment: "Автоверстальщик текста"),
      SeoToolService(
          name: "Serpstat AI Detector",
          url: "https://serpstat.com/page/ai-content-detection/",
          comment: "Проверка текста на AI"),
      SeoToolService(
          name: "GPTKit",
          url: "https://gptkit.ai/?via=toology",
          comment: "Проверка текста на AI"),
      SeoToolService(
          name: "GigaCheck",
          url: "https://developers.sber.ru/portal/products/gigacheck",
          comment: "AI-детектор текстов GigaCheck"),
      SeoToolService(
          name: "Yandex Speller",
          url: "https://yandex.ru/dev/speller/",
          comment: "Проверка орфографии"),
      SeoToolService(
          name: "Miratext Checker",
          url: "https://miratext.ru/keywords-checker/",
          comment: "Проверка вхождений ключей"),
      SeoToolService(
          name: "WordHTML",
          url: "https://wordhtml.com/",
          comment: "Автоверстальщик для текста"),
      SeoToolService(
          name: "Readable",
          url: "https://readable.com/",
          comment: "Проверка по SEO-параметрам"),
      SeoToolService(
          name: "SurferSEO",
          url: "https://surferseo.com/",
          comment: "Оптимизация страниц (LSI)"),
      SeoToolService(
          name: "Turgenev",
          url: "https://turgenev.ashmanov.com/",
          comment: "Анализ текстов"),
      SeoToolService(
          name: "Hemingway App",
          url: "https://hemingwayapp.com/",
          comment: "Анализ текстов (Eng)"),
    ]),
    SeoToolCategory(name: "Работа с семантикой", services: [
      SeoToolService(
          name: "Topvisor",
          url: "https://topvisor.com/",
          comment: "Съем позиций по запросам"),
      SeoToolService(
          name: "Arsenkin SP",
          url: "https://arsenkin.ru/tools/sp/",
          comment: "Сбор LSI и подсветок"),
      SeoToolService(
          name: "Semtools guru",
          url:
              "https://semtools.guru/ru/blog/23-spiska-minus-slov-dlya-yandeks-direkta/",
          comment: "Подборки минус-слов"),
      SeoToolService(
          name: "Semrush Keyword Magic",
          url: "https://www.semrush.com/analytics/keywordmagic/start",
          comment: "Работа с ключами (бурж)"),
      SeoToolService(
          name: "Arsenkin Clustering",
          url: "https://arsenkin.ru/tools/clustering/",
          comment: "Кластеризация запросов"),
      SeoToolService(
          name: "KWFinder",
          url: "https://mangools.com/kwfinder/",
          comment: "Сбор семантики"),
      SeoToolService(
          name: "Word Keeper",
          url: "https://word-keeper.ru/",
          comment: "Парсинг ключей"),
      SeoToolService(
          name: "Semrush",
          url: "https://www.semrush.com/",
          comment: "Сбор семантики, анализ"),
    ]),
    SeoToolCategory(name: "Работа с мета-тегами", services: [
      SeoToolService(
          name: "ChatGPT",
          url: "https://chat.openai.com/",
          comment: "Генерация мета-тегов"),
      SeoToolService(
          name: "Google Gemini",
          url: "https://gemini.google.com/",
          comment: "Генерация мета-тегов"),
    ]),
    SeoToolCategory(name: "Работа со структурой сайта", services: [
      SeoToolService(
          name: "Arsenkin Structure",
          url: "https://arsenkin.ru/tools/analysis-structure/",
          comment: "Выгрузка структуры сайта"),
    ]),
    SeoToolCategory(name: "Прочее", services: [
      SeoToolService(
          name: "Advego Translit",
          url: "https://advego.com/yandex-translit-online/",
          comment: "Генератор ЧПУ"),
      SeoToolService(
          name: "Line Editor",
          url: "https://lineeditor.ru/",
          comment: "Работа со списками"),
      SeoToolService(
          name: "Text Tools",
          url: "https://texttools.ru/remove-unwanted-characters",
          comment: "Удаление лишних символов"),
      SeoToolService(
          name: "Reformator",
          url: "https://www.artlebedev.ru/reformator/about/",
          comment: "Реформатор текста"),
      SeoToolService(
          name: "Valentin.app",
          url: "https://valentin.app/",
          comment: "Проверка SERP (бурж)"),
      SeoToolService(
          name: "Arsenkin Relevant URL",
          url: "https://arsenkin.ru/tools/relevant-url/",
          comment: "Определение релевантной страницы"),
      SeoToolService(
          name: "Arsenkin Check Top",
          url: "https://arsenkin.ru/tools/check-top/",
          comment: "Выгрузка ТОП-10"),
      SeoToolService(
          name: "Labrika",
          url: "https://labrika.ru/",
          comment: "Аудит сайта, расширение СЯ"),
      SeoToolService(
          name: "Rush Analytics",
          url: "https://www.rush-analytics.ru/",
          comment: "SERP монитор, анализ текстов"),
      SeoToolService(
          name: "Serpstat",
          url: "https://serpstat.com/ru/",
          comment: "Исследование рынка и контента"),
    ]),
  ]),
  // --- ВНЕШНЯЯ ОПТИМИЗАЦИЯ ---
  SeoToolSection(name: "Внешняя оптимизация", categories: [
    SeoToolCategory(name: "Работа с crowd ссылками", services: [
      SeoToolService(
          name: "Linkbuilder",
          url: "https://linkbuilder.su/",
          comment: "Биржа для закупки ссылок"),
      SeoToolService(
          name: "GoGetLinks Crowd",
          url: "https://www.gogetlinks.net/crowd",
          comment: "Биржа для закупки ссылок"),
      SeoToolService(
          name: "Kwork",
          url: "https://kwork.ru/",
          comment: "Крауд-маркетинг (бурж)"),
    ]),
    SeoToolCategory(name: "Работа со статейными ссылками", services: [
      SeoToolService(
          name: "CheckTrust",
          url: "https://checktrust.ru/",
          comment: "Проверка качества ссылок"),
      SeoToolService(
          name: "Miralinks",
          url: "https://www.miralinks.ru/",
          comment: "Биржа для закупки ссылок"),
      SeoToolService(
          name: "GoGetLinks",
          url: "https://www.gogetlinks.net/",
          comment: "Биржа для закупки ссылок"),
      SeoToolService(
          name: "Sitechecker Ahrefs Rank",
          url: "https://sitechecker.pro/ru/ahrefs-rank/",
          comment: "Быстрая проверка по Ahrefs"),
    ]),
    SeoToolCategory(name: "Работа с ссылочным профилем", services: [
      SeoToolService(
          name: "Megaindex",
          url: "https://ru.megaindex.com/backlinks",
          comment: "Анализ ссылок"),
      SeoToolService(
          name: "Ahrefs",
          url: "https://ahrefs.com/",
          comment: "Анализ ссылочного профиля"),
    ]),
    SeoToolCategory(name: "Прочее", services: [
      SeoToolService(
          name: "Tier1 Shop", url: "https://tier1.shop/", comment: "PBN"),
      SeoToolService(
          name: "SEOQuick Converter",
          url: "https://seoquick.com.ua/converting-urls-to-domains/",
          comment: "Конвертация URL в домены"),
    ]),
  ]),
  // --- ТЕХНИЧЕСКАЯ ЧАСТЬ ---
  SeoToolSection(name: "Техническая часть", categories: [
    SeoToolCategory(name: "Работа с кодом сайта", services: [
      SeoToolService(
          name: "W3C Validator",
          url: "https://validator.w3.org/",
          comment: "Валидатор кода HTML"),
      SeoToolService(
          name: "W3C CSS Validator",
          url: "https://jigsaw.w3.org/css-validator/",
          comment: "Валидатор CSS"),
      SeoToolService(
          name: "PageSpeed Insights",
          url: "https://pagespeed.web.dev/",
          comment: "Проверка скорости и ошибок"),
    ]),
    SeoToolCategory(name: "Работа с микроразметкой", services: [
      SeoToolService(
          name: "Schema Validator",
          url: "https://validator.schema.org/",
          comment: "Анализ микроразметки"),
      SeoToolService(
          name: "JSON-LD Playground",
          url: "https://json-ld.org/",
          comment: "Работа с JSON-LD"),
      SeoToolService(
          name: "Schema Markup Generator",
          url: "https://technicalseo.com/tools/schema-markup-generator/",
          comment: "Генератор микроразметки"),
    ]),
    SeoToolCategory(name: "Прочее", services: [
      SeoToolService(
          name: "Tech SEO Tools",
          url: "https://technicalseo.com/tools/",
          comment: "Очень много SEO-инструментов"),
      SeoToolService(
          name: "ImgLarger WebP",
          url: "https://imglarger-nextjs.vercel.app/converter/png-to-webp",
          comment: "Конвертер в WebP формат"),
      SeoToolService(
          name: "100zona Sitemap",
          url: "https://tools.100zona.com/sitemaps.html",
          comment: "Извлечение ссылок из Sitemap"),
      SeoToolService(
          name: "Redirect Checker",
          url: "https://redirectchecker.com/",
          comment: "Проверка редиректов"),
      SeoToolService(
          name: "PixelPlus Indexing API",
          url:
              "https://wiki.pixelplus.ru/stati/indexing-api-v-google/",
          comment: "Инструкция по Indexing API"),
    ]),
  ]),
];

// lib/data/design_patterns_data.dart
import 'package:flutter/material.dart';
import 'package:minimal/models/design_pattern_model.dart';

const List<DesignPattern> designPatterns = [
  // --- CREATIONAL PATTERNS ---
  DesignPattern(
    title: "Singleton",
    tagline: "Один экземпляр на всё приложение.",
    icon: Icons.looks_one,
    color: Colors.blue,
    explanation:
        "Паттерн Singleton гарантирует, что у класса есть только один экземпляр, и предоставляет глобальную точку доступа к нему. Идеально подходит для управления общим состоянием, подключениями к базе данных или сервисами логирования.",
    codeSnippet: '''
class AppCache {
  // Приватный конструктор
  AppCache._privateConstructor();

  // Статический единственный экземпляр
  static final AppCache _instance = AppCache._privateConstructor();

  // Фабричный конструктор для доступа
  factory AppCache() {
    return _instance;
  }

  // Пример данных
  final Map<String, String> _cache = {};

  void setData(String key, String value) {
    _cache[key] = value;
  }

  String? getData(String key) {
    return _cache[key];
  }
}

void main() {
  var cache1 = AppCache();
  var cache2 = AppCache();

  cache1.setData("user_id", "123");
  
  // cache1 и cache2 - это один и тот же объект
  print(cache2.getData("user_id")); // Выведет: 123
  print(identical(cache1, cache2)); // Выведет: true
}
''',
  ),
  DesignPattern(
    title: "Factory Method",
    tagline: "Делегирование создания объектов.",
    icon: Icons.build_circle,
    color: Colors.green,
    explanation:
        "Паттерн Factory Method определяет интерфейс для создания объекта, но оставляет подклассам решение о том, какой класс инстанцировать. Это позволяет классу делегировать создание экземпляров своим подклассам. Очень полезно, когда нужно создавать разные типы объектов в зависимости от условий.",
    codeSnippet: '''
abstract class Document {
  void open();
}

class TextDocument implements Document {
  @override
  void open() => print("Открыт текстовый документ.");
}

class ImageDocument implements Document {
  @override
  void open() => print("Открыто изображение.");
}

// Абстрактный создатель (Factory)
abstract class DocumentFactory {
  Document createDocument();
}

class TextDocumentFactory extends DocumentFactory {
  @override
  Document createDocument() => TextDocument();
}

class ImageDocumentFactory extends DocumentFactory {
  @override
  Document createDocument() => ImageDocument();
}

void main() {
  DocumentFactory factory = ImageDocumentFactory();
  Document doc = factory.createDocument();
  doc.open(); // Выведет: Открыто изображение.
}
''',
  ),
  // --- STRUCTURAL PATTERNS ---
  DesignPattern(
    title: "Adapter",
    tagline: "Преобразование интерфейсов.",
    icon: Icons.transform,
    color: Colors.orange,
    explanation:
        "Паттерн Adapter позволяет объектам с несовместимыми интерфейсами работать вместе. Он действует как 'переходник' между двумя классами. Часто используется для интеграции старого кода или сторонних библиотек в новую систему без изменения их исходного кода.",
    codeSnippet: '''
// Существующий класс с несовместимым интерфейсом
class OldJsonService {
  String getJsonData() => '{"data": "старые данные"}';
}

// Целевой интерфейс, который использует наше приложение
abstract class NewDataService {
  Map<String, dynamic> fetchData();
}

// Адаптер
class JsonAdapter implements NewDataService {
  final OldJsonService _oldService;

  JsonAdapter(this._oldService);

  @override
  Map<String, dynamic> fetchData() {
    print("Адаптер конвертирует JSON...");
    // Просто для примера, в реальности здесь будет парсинг
    return {"data": "новые данные из старых"};
  }
}

void main() {
  var oldService = OldJsonService();
  var adapter = JsonAdapter(oldService);
  var data = adapter.fetchData();
  print(data); // Выведет: {data: новые данные из старых}
}
''',
  ),
  // --- BEHAVIORAL PATTERNS ---
  DesignPattern(
    title: "Observer",
    tagline: "Подписка на уведомления.",
    icon: Icons.notifications_active,
    color: Colors.red,
    explanation:
        "Паттерн Observer создает механизм подписки, позволяющий одним объектам следить и реагировать на события, происходящие в других объектах. Когда состояние 'субъекта' меняется, все 'наблюдатели' автоматически уведомляются и обновляются. Это основа реактивного программирования и используется в BLoC, Provider и др.",
    codeSnippet: '''
// Субъект
class NewsPublisher {
  final List<NewsSubscriber> _subscribers = [];

  void subscribe(NewsSubscriber subscriber) => _subscribers.add(subscriber);
  void unsubscribe(NewsSubscriber subscriber) => _subscribers.remove(subscriber);

  void notify(String news) {
    for (var sub in _subscribers) {
      sub.update(news);
    }
  }
}

// Наблюдатель (интерфейс)
abstract class NewsSubscriber {
  void update(String news);
}

// Конкретные наблюдатели
class EmailSubscriber implements NewsSubscriber {
  @override
  void update(String news) => print("EMAIL: Новая статья! \$news");
}

class SMSSubscriber implements NewsSubscriber {
  @override
  void update(String news) => print("SMS: Срочные новости! \$news");
}

void main() {
  var publisher = NewsPublisher();
  var emailSub = EmailSubscriber();
  var smsSub = SMSSubscriber();

  publisher.subscribe(emailSub);
  publisher.subscribe(smsSub);

  publisher.notify("Flutter 4.0 анонсирован!");
  // Выведет:
  // EMAIL: Новая статья! Flutter 4.0 анонсирован!
  // SMS: Срочные новости! Flutter 4.0 анонсирован!
}
''',
  ),
];

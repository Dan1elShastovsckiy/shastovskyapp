# Flutter Minimal Website

Краткая карта проекта для разработчиков и ИИ-агентов — в [start.md](start.md).
Минималистичный персональный сайт-портфолио, разработанный с использованием Flutter Web.

## 📱 Особенности

- Адаптивный дизайн для всех устройств
- Минималистичный черно-белый интерфейс
- Блог с путешествиями и фотографиями
- Портфолио проектов
- Интеграция с социальными сетями
- Оптимизирован для веб

## 🛠 Технологии

- Flutter Web
- Responsive Framework
- URL Launcher
- Google Fonts

## 🚀 Установка

1. Убедитесь что у вас установлен Flutter:
```bash
flutter --version
```

2. Клонируйте репозиторий:
```bash
git clone https://github.com/Dan1elShastovsckiy/shastovskyapp/
```

3. Перейдите в директорию проекта:
```bash
cd shastovskyapp
```

4. Установите зависимости:
```bash
flutter pub get --enforce-lockfile
```

5. Запустите проект:
```bash
flutter run -d chrome
```

## Сборка и production-деплой

GitHub Actions запускается при push в `main` репозитория `Dan1elShastovsckiy/shastovskyapp`: проверяет Dart-код, собирает Flutter Web и предварительно рендерит публичные URL. Runner передаёт ограниченному SSH-приёмнику короткоживущую ссылку на артефакт GitHub Actions; сервер скачивает сборку напрямую и атомарно переключает релиз. При ошибке сервер возвращает предыдущий релиз. Деплой сохраняет серверные файлы и хранит текущий и предыдущий релизы.

Для Actions используются переменные `DEPLOY_HOST=83.136.235.196`, `DEPLOY_USER=shastovsky-deploy`, `DEPLOY_KNOWN_HOSTS` и секрет `DEPLOY_SSH_KEY`. Не добавляйте в GitHub пользовательский или root SSH-ключ. Nginx обслуживает активную версию из `/var/www/shastovsky/current`; исходные server-owned файлы, подтверждения домена, `robots.txt`, `sitemap.xml` и `uploads/` не входят в Git и должны сохраняться при обновлении.

## 📂 Структура проекта

```
lib/
  ├── components/     # Повторно используемые компоненты
  ├── pages/         # Страницы приложения
  ├── utils/         # Вспомогательные функции
  └── main.dart      # Точка входа приложения
```

## 🔧 Конфигурация

Для изменения контента отредактируйте:
- `lib/pages/` - содержимое страниц
- `lib/components/blog.dart` - навигационное меню
- `web/index.html` - мета-теги и SEO

## 📝 Лицензия

Copyright 2025 Daniil Shastovskii

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## 👤 Автор

- GitHub: [@Dan1elShastovsckiy](https://github.com/Dan1elShastovsckiy)
- Telegram: [@shastovscky](https://t.me/shastovscky)
- Instagram: [@yellolwapple](https://instagram.com/yellolwapple)

## 🤝 Содействие

Приветствуются Pull Requests. Для крупных изменений, пожалуйста, сначала создайте Issue для обсуждения.

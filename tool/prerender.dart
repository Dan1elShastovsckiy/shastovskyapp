// tool/prerender.dart

import 'package:prerender/prerender.dart' as prerender;

void main(List<String> args) async {
  // Диагностическое сообщение, чтобы мы видели, что скрипт запускается
  print('[INFO] Starting prerender script...');

  try {
    await prerender.prerender(
      // Указываем путь к собранному веб-приложению
      buildTarget: 'build/web',
      
      // Список всех страниц для генерации HTML
      routes: [
        '/',
        '/marocco',
        '/georgia-part1',
        '/about',
        '/portfolio',
        '/about-app',
        '/contacts',
        '/under_construction',
      ],
      // Если на вашем Mac Chrome установлен в стандартную папку,
      // этот параметр не обязателен. Раскомментируйте его, если скрипт не найдет Chrome.
      // executable: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    );
    print('[SUCCESS] Prerender script finished successfully!');
  } catch (e) {
    print('[ERROR] An error occurred during prerendering:');
    print(e);
  }
}

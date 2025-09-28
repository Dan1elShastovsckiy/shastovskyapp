/*// lib/pages/page_js_sandbox.dart

import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/languages/javascript.dart' as lang_js;
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/pages/pages.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class JsSandboxPage extends StatefulWidget {
  static const String name = 'try-coding/js-sandbox';
  const JsSandboxPage({super.key});

  @override
  State<JsSandboxPage> createState() => _JsSandboxPageState();
}

class _JsSandboxPageState extends State<JsSandboxPage> {
  late CodeController _jsController;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title: "Песочница JavaScript | Блог Даниила Шастовского",
      description:
          "Интерактивная песочница для JavaScript. Пишите и выполняйте JS-код прямо в браузере.",
    );

    _jsController = CodeController(
      language: lang_js.javascript,
      text: '''
// Напишите свой JavaScript код
// Используйте 'DOMContentLoaded', чтобы скрипт ждал загрузки HTML
document.addEventListener('DOMContentLoaded', (event) => {
  const button = document.getElementById('myButton');
  const output = document.getElementById('output');

  if (button && output) {
    let count = 0;
    button.addEventListener('click', () => {
      count++;
      const message = `Кнопка нажата \${count} раз.`;
      output.innerText = message;
      // Вывод в консоль разработчика (F12)
      console.log(message); 
    });
  }
});
''',
    );

    // <<< КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ: Убираем вызов setBackgroundColor >>>
    _webViewController = WebViewController();

    _runJs();
  }

  void _runJs() {
    final fullHtml = """
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { 
              font-family: sans-serif; 
              padding: 20px; 
              box-sizing: border-box; 
              background-color: #f0f0f0;
              color: #333;
              margin: 0;
            }
            button { margin-bottom: 20px; padding: 8px 16px; border-radius: 8px; border: none; cursor: pointer; }
            #output { font-weight: bold; }
            @media (prefers-color-scheme: dark) {
              body {
                background-color: #1e1e1e;
                color: #f0f0f0;
              }
            }
          </style>
        </head>
        <body>
          <h3>Результат выполнения:</h3>
          <button id="myButton">Выполнить JS внутри WebView</button>
          <hr>
          <div id="output">Результат будет здесь...</div>
          <script>${_jsController.text}<\/script>
        </body>
      </html>
    """;

    _webViewController.loadHtmlString(fullHtml);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Код отправлен на выполнение. Откройте консоль (F12) для просмотра логов.'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _jsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 800;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: MaxWidthBox(
            maxWidth: 1600,
            child: Column(
              children: [
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(
                      text: "Попробуй кодить", routeName: '/try-coding'),
                  BreadcrumbItem(text: "Песочница JS"),
                ]),
                const SizedBox(height: 24),
                Text("Песочница: JavaScript",
                    style: headlineTextStyle(context)),
                const SizedBox(height: 24),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CodeTheme(
                    data: CodeThemeData(
                        styles: isDark ? atomOneDarkTheme : atomOneLightTheme),
                    child: CodeField(
                      controller: _jsController,
                      expands: true,
                      textStyle: bodyTextStyle(context)
                          .copyWith(fontFamily: 'monospace'),
                      lineNumberStyle: LineNumberStyle(
                          textStyle: bodyTextStyle(context)
                              .copyWith(color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _runJs,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Выполнить JS"),
                  style: elevatedButtonStyle(context),
                ),
                const SizedBox(height: 16),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Превью:",
                      style: headlineSecondaryTextStyle(context)),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: WebViewWidget(controller: _webViewController),
                ),
                const SizedBox(height: 40),
                divider(context),
                const Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
/*
_buildExampleCard(
                  context: context,
                  title: "Конвертер цветов HEX ↔ RGB",
                  description:
                      "Интерактивный инструмент для конвертации цветов между форматами HEX и RGB с предпросмотром.",
                  htmlCode: _example4HtmlWithJsSafe,
                  cssCode: _example4Css,
                ),

                // Безопасная версия HTML для конвертера цветов (без проблемных символов)
const _example4HtmlWithJsSafe = '''
<div class="converter">
    <h1>Конвертер цветов HEX ↔ RGB</h1>
    <div class="input-group">
        <label for="hex-input">HEX цвет (например, #4CAF50):</label>
        <input type="text" id="hex-input" placeholder="#4CAF50" maxlength="7">
    </div>
    <div class="input-group">
        <label>RGB цвет:</label>
        <div class="rgb-inputs">
            <input type="number" id="r-input" placeholder="R" min="0" max="255">
            <input type="number" id="g-input" placeholder="G" min="0" max="255">
            <input type="number" id="b-input" placeholder="B" min="0" max="255">
        </div>
    </div>
    <div class="color-preview" id="color-preview"></div>
    <div class="result" id="result">Введите цвет для конвертации...</div>
    <button onclick="copyToClipboard()">Скопировать результат</button>
</div>

<script>
    const hexInput = document.getElementById('hex-input');
    const rInput = document.getElementById('r-input');
    const gInput = document.getElementById('g-input');
    const bInput = document.getElementById('b-input');
    const colorPreview = document.getElementById('color-preview');
    const resultDiv = document.getElementById('result');

    function hexToRgb(hex) {
        hex = hex.replace('#', '');
        if (hex.length !== 6) return null;
        const r = parseInt(hex.substring(0, 2), 16);
        const g = parseInt(hex.substring(2, 4), 16);
        const b = parseInt(hex.substring(4, 6), 16);
        if (isNaN(r) || isNaN(g) || isNaN(b)) return null;
        return { r, g, b };
    }

    function rgbToHex(r, g, b) {
        if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255) return null;
        return '#' + [r, g, b].map(x => {
            const hex = x.toString(16);
            return hex.length === 1 ? '0' + hex : hex;
        }).join('').toUpperCase();
    }

    function updatePreview() {
        let color, resultText;
        if (document.activeElement === hexInput && hexInput.value.length === 7) {
            const rgb = hexToRgb(hexInput.value);
            if (rgb) {
                color = hexInput.value;
                resultText = 'HEX: ' + color + ' → RGB: rgb(' + rgb.r + ', ' + rgb.g + ', ' + rgb.b + ')';
                rInput.value = rgb.r;
                gInput.value = rgb.g;
                bInput.value = rgb.b;
            } else { resultText = 'Неверный HEX формат'; }
        } else if ([rInput, gInput, bInput].includes(document.activeElement)) {
            const r = parseInt(rInput.value) || 0;
            const g = parseInt(gInput.value) || 0;
            const b = parseInt(bInput.value) || 0;
            const hexColor = rgbToHex(r, g, b);
            if (hexColor) {
                color = hexColor;
                resultText = 'RGB: rgb(' + r + ', ' + g + ', ' + b + ') → HEX: ' + hexColor;
                hexInput.value = hexColor;
            } else { resultText = 'RGB значения должны быть от 0 до 255';}
        }
        if (color) {
            colorPreview.style.backgroundColor = color;
            resultDiv.textContent = resultText;
            resultDiv.style.color = '#333';
        } else if (resultText) {
            resultDiv.textContent = resultText;
            resultDiv.style.color = '#e74c3c';
        }
    }

    hexInput.addEventListener('input', function(e) {
        let value = e.target.value;
        if (value.startsWith('#')) {
            value = '#' + value.slice(1).replace(/[^0-9A-Fa-f]/g, '').toUpperCase();
        } else {
            value = '#' + value.replace(/[^0-9A-Fa-f]/g, '').toUpperCase();
        }
        e.target.value = value.slice(0, 7);
        updatePreview();
    });

    [rInput, gInput, bInput].forEach(input => {
        input.addEventListener('input', function() {
            if (this.value > 255) this.value = 255;
            if (this.value < 0) this.value = 0;
            updatePreview();
        });
    });

    function copyToClipboard() {
        const textToCopy = resultDiv.textContent;
        if (textToCopy && !textToCopy.includes('Введите') && !textToCopy.includes('Неверный')) {
            navigator.clipboard.writeText(textToCopy).then(() => {
                const originalText = resultDiv.textContent;
                resultDiv.textContent = 'Скопировано в буфер обмена!';
                setTimeout(() => { resultDiv.textContent = originalText; }, 2000);
            });
        }
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        hexInput.value = '#4CAF50';
        updatePreview();
    });
</script>
''';

const _example4Css = '''
.converter {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
h1 {
    color: #333;
    text-align: center;
    margin-bottom: 20px;
    font-size: 1.4em;
}
.input-group { margin-bottom: 15px; }
label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #555;
}
input {
    width: 100%;
    padding: 10px;
    border: 2px solid #ddd;
    border-radius: 5px;
    font-size: 16px;
    box-sizing: border-box;
}
input:focus {
    border-color: #4CAF50;
    outline: none;
}
.rgb-inputs {
    display: flex;
    gap: 10px;
}
.rgb-inputs input { text-align: center; }
.color-preview {
    width: 100%;
    height: 60px;
    border-radius: 5px;
    margin: 15px 0;
    border: 2px solid #ddd;
    transition: background-color 0.3s ease;
}
.result {
    background-color: #f9f9f9;
    padding: 12px;
    border-radius: 5px;
    margin-top: 15px;
    font-family: 'Courier New', monospace;
    word-break: break-all;
    min-height: 20px;
}
button {
    background-color: #4CAF50;
    color: white;
    padding: 12px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
    width: 100%;
    margin-top: 10px;
    transition: background-color 0.3s ease, transform 0.1s ease;
}
button:hover { background-color: #45a049; }
button:active { transform: scale(0.98); }
''';
*/

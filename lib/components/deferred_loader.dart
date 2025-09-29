// /lib/components/deferred_loader.dart

import 'package:flutter/material.dart';

// Функция-тип для загрузки библиотеки
typedef LibraryLoader = Future<void> Function();
// Функция-тип для создания виджета после загрузки
typedef WidgetBuilder = Widget Function();

class DeferredLoader extends StatefulWidget {
  final LibraryLoader libraryLoader;
  final WidgetBuilder widgetBuilder;
  // Добавим title, чтобы показывать его в AppBar во время загрузки
  final String? title;

  const DeferredLoader({
    super.key,
    required this.libraryLoader,
    required this.widgetBuilder,
    this.title,
  });

  @override
  State<DeferredLoader> createState() => _DeferredLoaderState();
}

class _DeferredLoaderState extends State<DeferredLoader> {
  Future<void>? _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = widget.libraryLoader();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Ошибка загрузки страницы: ${snapshot.error}'));
          }
          // Если все хорошо, строим нужный виджет
          return widget.widgetBuilder();
        } else {
          // Пока идет загрузка, показываем "пустую" страницу с индикатором
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title ?? "Загрузка..."),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

// lib/components/image_carousel.dart

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

// <<< РЕШЕНИЕ ДЛЯ ТАЧПАДА >>>
// Этот класс отключает свайп мышью/тачпадом.
class _DesktopTouchScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
      };
}

// Этот виджет НЕ меняется
class _FullScreenImageViewer extends StatefulWidget {
  final List<String> imageFullPaths;
  final int initialIndex;

  const _FullScreenImageViewer({
    required this.imageFullPaths,
    required this.initialIndex,
  });

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getThumbPath(String fullPath) {
    final int extensionIndex = fullPath.lastIndexOf('.webp');
    if (extensionIndex == -1) {
      return fullPath;
    }
    return '${fullPath.substring(0, extensionIndex)}_thumb.webp';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.85),
      insetPadding: const EdgeInsets.all(0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScrollConfiguration(
            behavior: _DesktopTouchScrollBehavior(),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.imageFullPaths.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final String originalPath = widget.imageFullPaths[index];
                final String thumbPath = _getThumbPath(originalPath);

                return InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Image.asset(
                    originalPath,
                    fit: BoxFit.contain,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) return child;
                      return Image.asset(thumbPath, fit: BoxFit.contain);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(thumbPath, fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.white, size: 50));
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          if (widget.imageFullPaths.length > 1)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.all(16)),
                onPressed: _currentIndex > 0
                    ? () => _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut)
                    : null,
              ),
            ),
          if (widget.imageFullPaths.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.all(16)),
                onPressed: _currentIndex < widget.imageFullPaths.length - 1
                    ? () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut)
                    : null,
              ),
            ),
          if (widget.imageFullPaths.length > 1)
            Positioned(
              bottom: 20,
              child: Row(
                children: List.generate(
                    widget.imageFullPaths.length,
                    (index) => Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.white.withAlpha(128),
                            border: Border.all(
                                color: Colors.black.withAlpha(128), width: 1),
                          ),
                        )),
              ),
            ),
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
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _autoPlayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.images.length <= 1) return;
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isDisposed || !mounted) {
        timer.cancel();
        return;
      }

      // <<< ФИНАЛЬНОЕ ИСПРАВЛЕНИЕ №1: Добавляем try-catch >>>
      // Это "ловушка" для ошибки, которая возникает во время навигации.
      // Она предотвратит креш и позволит навигации завершиться.
      try {
        if (!_controller.hasClients) {
          timer.cancel();
          return;
        }

        int currentPage = _controller.page!.round();
        int nextPage = (currentPage + 1) % widget.images.length;

        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        // Эта ошибка ожидаема во время быстрой навигации.
        // Мы просто отменяем таймер и ничего не делаем.
        timer.cancel();
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _showFullScreen(BuildContext context, int initialIndex) {
    _stopAutoPlay();
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => _FullScreenImageViewer(
          imageFullPaths: widget.images, initialIndex: initialIndex),
    ).then((_) {
      if (mounted) {
        _startAutoPlay();
      }
    });
  }

  String _getThumbPath(String fullPath) {
    final int extensionIndex = fullPath.lastIndexOf('.webp');
    if (extensionIndex == -1) return fullPath;
    return '${fullPath.substring(0, extensionIndex)}_thumb.webp';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) {
        if (!mounted) return;
        setState(() => _showButtons = true);
        _stopAutoPlay();
      },
      onExit: (_) {
        if (!mounted) return;
        setState(() => _showButtons = false);
        _startAutoPlay();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          // <<< ФИНАЛЬНОЕ ИСПРАВЛЕНИЕ №2: Возвращаем ScrollConfiguration >>>
          child: ScrollConfiguration(
            behavior: _DesktopTouchScrollBehavior(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  // physics: const NeverScrollableScrollPhysics(), // Можно раскомментировать для полной блокировки свайпов
                  controller: _controller,
                  itemCount: widget.images.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final thumbPath = _getThumbPath(widget.images[index]);
                    return GestureDetector(
                      onTap: () => _showFullScreen(context, index),
                      child: Image.asset(
                        thumbPath,
                        fit: BoxFit.cover,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null) {
                            return child;
                          }
                          return Container(color: theme.colorScheme.surface);
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text('Ошибка загрузки'));
                        },
                      ),
                    );
                  },
                ),
                // ... остальной код (кнопки и индикаторы) без изменений ...
                if (widget.images.length > 1)
                  AnimatedOpacity(
                    opacity: _showButtons ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            padding: const EdgeInsets.all(16)),
                        onPressed: _currentPage > 0
                            ? () => _controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut)
                            : null,
                      ),
                    ),
                  ),
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
                            padding: const EdgeInsets.all(16)),
                        onPressed: _currentPage < widget.images.length - 1
                            ? () => _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut)
                            : null,
                      ),
                    ),
                  ),
                if (widget.images.length > 1)
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.images.length,
                        (index) => GestureDetector(
                          onTap: () => _controller.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut),
                          child: Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withAlpha(128),
                              border: Border.all(
                                  color: Colors.black.withAlpha(128), width: 1),
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
      ),
    );
  }
}

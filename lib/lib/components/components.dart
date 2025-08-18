import 'package:flutter/material.dart';
export 'image_carousel.dart';

export 'blog.dart';
export 'color.dart';
export 'spacing.dart';
export 'text.dart';
export 'typography.dart';

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  side: const BorderSide(color: Colors.black),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0),
  ),
  elevation: 0,
);

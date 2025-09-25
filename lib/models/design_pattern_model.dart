// lib/models/design_pattern_model.dart
import 'package:flutter/material.dart';

class DesignPattern {
  final String title;
  final String tagline;
  final String explanation;
  final String codeSnippet;
  final IconData icon;
  final Color color;

  const DesignPattern({
    required this.title,
    required this.tagline,
    required this.explanation,
    required this.codeSnippet,
    required this.icon,
    required this.color,
  });
}

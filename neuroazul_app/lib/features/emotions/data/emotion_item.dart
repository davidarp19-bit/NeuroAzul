import 'package:flutter/material.dart';

class EmotionItem {
  final String id;
  final String label;
  final IconData icon;

  const EmotionItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

const emotionItems = [
  EmotionItem(
    id: 'happy',
    label: 'Alegría',
    icon: Icons.sentiment_very_satisfied_outlined,
  ),
  EmotionItem(
    id: 'sad',
    label: 'Tristeza',
    icon: Icons.sentiment_dissatisfied_outlined,
  ),
  EmotionItem(
    id: 'angry',
    label: 'Enojo',
    icon: Icons.sentiment_very_dissatisfied_outlined,
  ),
];

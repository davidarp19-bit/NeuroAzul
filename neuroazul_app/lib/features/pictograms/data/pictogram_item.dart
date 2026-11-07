import 'package:flutter/material.dart';

class PictogramItem {
  final String id;
  final String label;
  final IconData icon;

  const PictogramItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

const pictogramItems = [
  PictogramItem(id: 'house', label: 'Casa', icon: Icons.home_outlined),
  PictogramItem(id: 'food', label: 'Comida', icon: Icons.restaurant_outlined),
  PictogramItem(id: 'school', label: 'Escuela', icon: Icons.school_outlined),
  PictogramItem(id: 'water', label: 'Agua', icon: Icons.water_drop_outlined),
  PictogramItem(id: 'bed', label: 'Dormir', icon: Icons.bed_outlined),
  PictogramItem(
    id: 'play',
    label: 'Jugar',
    icon: Icons.sports_esports_outlined,
  ),
];

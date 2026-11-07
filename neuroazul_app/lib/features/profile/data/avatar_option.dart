import 'package:flutter/material.dart';

class AvatarOption {
  final String key;
  final String name;
  final IconData icon;

  const AvatarOption({
    required this.key,
    required this.name,
    required this.icon,
  });
}

const avatarOptions = [
  AvatarOption(
    key: 'avatar_1',
    name: 'Explorador',
    icon: Icons.explore_outlined,
  ),
  AvatarOption(key: 'avatar_2', name: 'Estrella', icon: Icons.star_outline),
  AvatarOption(
    key: 'avatar_3',
    name: 'Sonrisa',
    icon: Icons.sentiment_satisfied_alt_outlined,
  ),
  AvatarOption(
    key: 'avatar_4',
    name: 'Aventura',
    icon: Icons.rocket_launch_outlined,
  ),
];

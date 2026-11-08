import 'package:flutter/material.dart';

class RoutineStep {
  final String id;
  final String label;
  final IconData icon;
  final int correctPosition;

  const RoutineStep({
    required this.id,
    required this.label,
    required this.icon,
    required this.correctPosition,
  });
}

const morningHygieneSteps = [
  RoutineStep(
    id: 'wake_up',
    label: 'Levantarse',
    icon: Icons.wb_sunny_outlined,
    correctPosition: 1,
  ),
  RoutineStep(
    id: 'brush_teeth',
    label: 'Cepillarse los dientes',
    icon: Icons.cleaning_services_outlined,
    correctPosition: 2,
  ),
  RoutineStep(
    id: 'wash_face',
    label: 'Lavarse la cara',
    icon: Icons.water_drop_outlined,
    correctPosition: 3,
  ),
  RoutineStep(
    id: 'comb_hair',
    label: 'Peinarse',
    icon: Icons.face_retouching_natural_outlined,
    correctPosition: 4,
  ),
];

const feedingRoutineSteps = [
  RoutineStep(
    id: 'wash_hands',
    label: 'Lavarse las manos',
    icon: Icons.wash_outlined,
    correctPosition: 1,
  ),
  RoutineStep(
    id: 'sit_at_table',
    label: 'Sentarse a la mesa',
    icon: Icons.chair_outlined,
    correctPosition: 2,
  ),
  RoutineStep(
    id: 'eat_food',
    label: 'Comer los alimentos',
    icon: Icons.restaurant_outlined,
    correctPosition: 3,
  ),
  RoutineStep(
    id: 'clean_up',
    label: 'Recoger después de comer',
    icon: Icons.cleaning_services_outlined,
    correctPosition: 4,
  ),
];

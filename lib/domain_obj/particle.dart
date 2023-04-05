import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_physics_engine_test/domain_obj/momentum.dart';
import 'package:flutter_physics_engine_test/domain_obj/physical_objects.dart';
import 'package:flutter_physics_engine_test/domain_obj/position.dart';

@immutable
class Particle extends PhysicalObjects {
  final double radius;

  Particle({
    required this.radius,
    required super.currentPosition,
    required super.momentum,
    required super.mass,
  }) : super(
          paths: [
            Path()
              ..arcTo(
                  Rect.fromCircle(
                    center: Offset(currentPosition.x, currentPosition.y),
                    radius: radius,
                  ),
                  10,
                  2 * pi,
                  true)
          ],
          paints: [
            Paint()..color = Colors.black,
          ],
        );

  @override
  Particle copyWith({
    Position? currentPosition,
    Momentum? momentum,
    double? mass,
  }) =>
      Particle(
        radius: radius,
        currentPosition: currentPosition ?? this.currentPosition,
        momentum: momentum ?? this.momentum,
        mass: mass ?? this.mass,
      );

  @override
  PhysicalObjects move(
    PhysicalObjects old,
    Position moveTo,
    Momentum newMomentum,
  ) =>
      old.copyWith(
        currentPosition: moveTo,
        momentum: newMomentum,
      );

  @override
  List<Object?> get props => [
        radius,
        currentPosition,
        momentum,
        mass,
        paths,
        paints,
      ];
}

import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_physics_engine_test/domain_obj/momentum.dart';
import 'package:flutter_physics_engine_test/domain_obj/position.dart';

abstract class PhysicalObjects extends Equatable {
  final Position currentPosition;
  final double mass;
  final Momentum momentum;
  final List<Path> paths;
  final List<Paint> paints;

  PhysicalObjects copyWith({
    Position? currentPosition,
    Momentum? momentum,
    double? mass,
  });

  PhysicalObjects move(
    PhysicalObjects old,
    Position moveTo,
    Momentum newMomentum,
  );

  const PhysicalObjects({
    required this.currentPosition,
    required this.momentum,
    required this.mass,
    required this.paths,
    required this.paints,
  });
}

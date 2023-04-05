import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_physics_engine_test/domain_obj/physical_objects.dart';
import 'package:flutter_physics_engine_test/domain_obj/position.dart';

import 'package:tuple/tuple.dart';

import '../../domain_obj/momentum.dart';

class Field extends StatefulWidget {
  final List<PhysicalObjects> initialObjects;
  final Position? attractionPoint;
  final double? attractionSize;
  final double referenceRadius;

  const Field({
    required this.initialObjects,
    required this.referenceRadius,
    this.attractionPoint,
    this.attractionSize,
    Key? key,
  }) : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<PhysicalObjects> objects = [];

  @override
  void initState() {
    super.initState();
    objects = widget.initialObjects;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        List<PhysicalObjects> newList = List.generate(
          objects.length,
          (index) {
            final PhysicalObjects target = objects[index];
            return target.calculateAttract(
              widget.attractionPoint,
              widget.attractionSize,
            );
          },
        );
        objects = newList;
        final Tuple2<List<Path>, List<Paint>> unzippedTemp = objects.unZipPaintsNPaths();

        return CustomPaint(
          painter: _Painter(
            unzippedTemp.item1,
            unzippedTemp.item2,
            widget.attractionPoint,
          ),
        );
      },
    );
  }
}

extension _MakeCalAttracts on PhysicalObjects {
  PhysicalObjects calculateAttract(Position? attractPosition, double? attractionSize) {
    if (attractPosition == null) {
      return copyWith(
        currentPosition: Position(
          currentPosition.x + momentum.dx,
          currentPosition.y + momentum.dy,
        ),
      );
    }
    final double diffX = attractPosition.x.tryGetDiff(currentPosition.x);
    final double diffY = attractPosition.y.tryGetDiff(currentPosition.y);
    final double theta = atan(diffY.abs() / diffX.abs());
    double diffRadius = sqrt(diffX * diffX + diffY * diffY);
    diffRadius = diffRadius < 1 ? 1 : diffRadius;
    final double attractionForce = ((attractionSize! * mass) / pow(diffRadius, 2)) * 10;
    final double attractionX = sin(theta) * attractionForce;
    final double attractionY = cos(theta) * attractionForce;
    print("attractionForce: $attractionForce, attractionX: $attractionX, attractionY: $attractionY");
    final double newDeltaX = currentPosition.x > attractPosition.x
        ? attractionX
        : currentPosition.x == attractPosition.x
            ? 0
            : -attractionX;
    final double newDeltaY = currentPosition.y > attractPosition.y
        ? attractionY
        : currentPosition.y == attractPosition.y
            ? 0
            : -attractionY;
    final Momentum newMomentum = Momentum(
      momentum.dx + newDeltaX,
      momentum.dy + newDeltaY,
    );
    final PhysicalObjects next = copyWith(
      currentPosition: Position(
        currentPosition.x + newMomentum.dx,
        currentPosition.y + newMomentum.dy,
      ),
      momentum: newMomentum,
    );
    return next;
  }
}

extension _MakeTryGetDiffer on double? {
  tryGetDiff(double foo) {
    if (this == null) return 0;
    return (this! - foo);
  }
}

extension _MakeUnzipper on List<PhysicalObjects> {
  Tuple2<List<Path>, List<Paint>> unZipPaintsNPaths() {
    final temp = Tuple2(<Path>[], <Paint>[]);
    for (var particle in this) {
      temp.item1.addAll(particle.paths);
      temp.item2.addAll(particle.paints);
    }
    return temp;
  }
}

class _Painter extends CustomPainter {
  final Position? attractPoint;
  final List<Path> pathList;
  final List<Paint> paintList;

  _Painter(this.pathList, this.paintList, [this.attractPoint]);

  @override
  void paint(Canvas canvas, Size size) {
    if (attractPoint != null) {
      canvas.drawCircle(Offset(attractPoint!.x, attractPoint!.y), 3, Paint()..color = Colors.red);
    }
    for (var i = 0; i < pathList.length; i++) {
      canvas.drawPath(pathList[i], paintList[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

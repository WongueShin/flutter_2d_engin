import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_physics_engine_test/domain_obj/momentum.dart';
import 'package:flutter_physics_engine_test/domain_obj/particle.dart';
import 'package:flutter_physics_engine_test/domain_obj/position.dart';
import 'package:flutter_physics_engine_test/view/field/field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MainScreen(title: 'Flutter Physics Engine'),
    );
  }
}

class MainScreen extends StatelessWidget {
  final String title;

  const MainScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final initialMomentum = Momentum(Random().nextDouble() * 10, Random().nextDouble() * 10);
    print('initialMomentum: $initialMomentum');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Field(
          attractionPoint: Position(size.width / 2, size.height / 2),
          attractionSize: 300,
          referenceRadius: sqrt(pow(size.height / 2, 2) + pow(size.width / 2, 2)),
          initialObjects: [
            Particle(
              radius: 5,
              currentPosition: Position(Random().nextDouble() * size.width, Random().nextDouble() * size.height),
              momentum: initialMomentum,
              mass: 10,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final double x;
  final double y;

  const Position(this.x, this.y);

  @override
  List<Object> get props => [x, y];

  @override
  String toString() => """Position{x: $x, y: $y}""";
}
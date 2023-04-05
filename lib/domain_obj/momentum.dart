import 'package:equatable/equatable.dart';

class Momentum extends Equatable {
  final double dx;
  final double dy;

  const Momentum(this.dx, this.dy);

  @override
  List<Object> get props => [dx, dy];

  @override
  String toString() => """Momentum{x: $dx, y: $dy}""";
}

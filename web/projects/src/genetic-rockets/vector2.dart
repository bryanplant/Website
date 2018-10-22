import 'package:json_annotation/json_annotation.dart';
import 'dart:math';

part 'vector2.g.dart';

@JsonSerializable()

class Vector2 extends Object with _$Vector2SerializerMixin {
  double x;
  double y;

  Vector2(double x, double y) {
    this.x = x;
    this.y = y;
  }

  factory Vector2.fromJson(Map<String, dynamic> json) => _$Vector2FromJson(json);

  double get length => distanceTo(Vector2(0.0, 0.0));

  void add(Vector2 other) {
    x += other.x;
    y += other.y;
  }

  double distanceTo(Vector2 other) {
    double dx = x - other.x;
    double dy = y - other.y;

    return sqrt(dx * dx + dy * dy);
  }

  double setFrom(Vector2 other) {
    x = other.x;
    y = other.y;
  }

  Vector2 normalized() {
    double length = distanceTo(Vector2(0.0, 0.0));
    if (length == 0.0) {
      return Vector2(0.0, 0.0);
    }
    double d = 1.0 / length;
    return Vector2(x*d, y*d);
  }

  void scale(double factor) {
    x *= factor;
    y *= factor;
  }
}
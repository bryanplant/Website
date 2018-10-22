// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vector2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vector2 _$Vector2FromJson(Map<String, dynamic> json) {
  return new Vector2(
      (json['x'] as num)?.toDouble(), (json['y'] as num)?.toDouble());
}

abstract class _$Vector2SerializerMixin {
  double get x;
  double get y;
  Map<String, dynamic> toJson() => <String, dynamic>{'x': x, 'y': y};
}

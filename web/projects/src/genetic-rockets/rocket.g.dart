// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rocket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rocket _$RocketFromJson(Map<String, dynamic> json) {
  return new Rocket((json['dna'] as List)
      ?.map((e) =>
          e == null ? null : new Vector2.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

abstract class _$RocketSerializerMixin {
  Vector2 get pos;
  Vector2 get vel;
  Vector2 get acc;
  Vector2 get grav;
  int get width;
  int get height;
  int get numGenes;
  int get curGene;
  int get nextGeneTime;
  int get nextGeneCounter;
  List<Vector2> get dna;
  double get fitness;
  bool get completed;
  bool get crashed;
  double get closestDistance;
  double get completedTime;
  double get mutationRate;
  double get crossoverRate;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'pos': pos,
        'vel': vel,
        'acc': acc,
        'grav': grav,
        'width': width,
        'height': height,
        'numGenes': numGenes,
        'curGene': curGene,
        'nextGeneTime': nextGeneTime,
        'nextGeneCounter': nextGeneCounter,
        'dna': dna,
        'fitness': fitness,
        'completed': completed,
        'crashed': crashed,
        'closestDistance': closestDistance,
        'completedTime': completedTime,
        'mutationRate': mutationRate,
        'crossoverRate': crossoverRate
      };
}

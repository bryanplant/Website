import 'dart:html';
import 'dart:math';
import 'vector2.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rocket.g.dart';

@JsonSerializable()

class Rocket extends Object with _$RocketSerializerMixin implements Comparable<Rocket> {
  Vector2 pos;
  Vector2 vel;
  Vector2 acc;
  Vector2 grav;
  int width, height;
  int numGenes;
  int curGene;
  int nextGeneTime;
  int nextGeneCounter;
  List<Vector2> dna;
  double fitness;
  bool completed;
  bool crashed;
  double closestDistance; //closest distance to goal during iteration
  double completedTime;
  double mutationRate;
  double crossoverRate;

  Rocket(List<Vector2> dna) {
    curGene = 0;
    numGenes = 100;
    nextGeneTime = 3;
    nextGeneCounter = 0;
    completed = false;
    crashed = false;
    closestDistance = double.maxFinite;
    mutationRate = 0.01;
    crossoverRate = 0.99;
    pos = new Vector2(window.innerWidth / 2, window.innerHeight - 50.toDouble());
    vel = new Vector2(0.0, -.5); //start rocket with upwards velocity
    acc = new Vector2(0.0, 0.0);
    grav = new Vector2(0.0, 0.025);
    width = 15;
    height = 40;
    if (dna == null) {
      this.dna = new List<Vector2>(numGenes);
      for (int i = 0; i < numGenes; i++) {
        this.dna[i] = randomGene();
      }
    } else {
      this.dna = dna;
    }
  }

  factory Rocket.fromJson(Map<String, dynamic> json) => _$RocketFromJson(json);

  //calculate rocket's fitness based on distance to target
  void calculateFitness(Vector2 target) {
    double dist = pos.distanceTo(target);
    fitness = 0.0;

    //calculate fitness value for total distance
    if (dist < 1000) fitness += (1000 - dist) / 10;

    //calculate fitness value for closest distance
    if (closestDistance < 1000) fitness += .5 * ((1000 - closestDistance) / 10);

    //calculate fitness value for completing faster
    if (completed) {
      fitness += 100 * (numGenes / completedTime);
    }
  }

  //update rocket
  void update(Vector2 target, int targetRadius, List<Rectangle> obstacles) {
    if (!completed && pos.distanceTo(target) < targetRadius) {
      completed = true;
      completedTime = curGene + 1 / ((nextGeneTime + 1) - nextGeneCounter);
      pos.setFrom(target);
      closestDistance = 0.0;
    }

    if (!completed && !crashed) {
      acc.setFrom(dna.elementAt(curGene));
      acc.add(grav);
      vel.add(acc);

      if (vel.length > 7.5)
        vel = vel.normalized()..scale(7.5); //max velocity of rocket
      pos.add(vel);

      //check if collided with obstacles
      Point point = new Point(pos.x, pos.y);
      for (Rectangle r in obstacles) {
        if (r.containsPoint(point)) {
          crashed = true;
        }
      }

      //check if collided with window edges
      if (pos.y > window.innerHeight ||
          pos.y < 0 ||
          pos.x < 0 ||
          pos.x > window.innerWidth) {
        crashed = true;
      }

      //update closest position
      if (pos.distanceTo(target) < closestDistance)
        closestDistance = pos.distanceTo(target);
    }

    nextGeneCounter++;
    if (nextGeneCounter >= nextGeneTime) {
      //move to next gene
      if (curGene < dna.length - 1) curGene++;
      nextGeneCounter = 0;
    }
  }

  //draw rocket to canvas
  void draw(CanvasRenderingContext2D c2d) {
    c2d.translate(pos.x, pos.y);
    Vector2 heading = vel.normalized();
    double angle = atan2(heading.y, heading.x);
    c2d.rotate(angle + pi / 2);

    c2d.fillStyle = 'rgba(255, 255, 255, 0.5)';
    c2d.beginPath();
    c2d.lineTo(-width / 2, -height / 2);
    c2d.lineTo(-width / 2, 0);
    c2d.lineTo(-width, height / 2);
    c2d.lineTo(-width / 2, height / 2);
    c2d.lineTo(width / 2, height / 2);
    c2d.lineTo(width, height / 2);
    c2d.lineTo(width / 2, 0);
    c2d.lineTo(width / 2, -height / 2);
    c2d.lineTo(0, -height - height / 6);
    c2d.lineTo(-width / 2, -height / 2);
    c2d.closePath();
    c2d.fill();

    c2d.fillStyle = 'rgba(255,165,0,0.5)';
    c2d.beginPath();
    c2d.lineTo(-width / 2, height / 2);
    c2d.lineTo(-width / 2, 3 * height / 4);
    c2d.lineTo(-width / 2 + width / 3, 5 * height / 8);
    c2d.lineTo(0, 3 * height / 4);
    c2d.lineTo(-width / 2 + 2 * width / 3, 5 * height / 8);
    c2d.lineTo(width / 2, 3 * height / 4);
    c2d.lineTo(width / 2, height / 2);
    c2d.closePath();
    c2d.fill();

    c2d.setTransform(1, 0, 0, 1, 0, 0);
  }

  Vector2 randomGene() {
    Random rand = new Random();
    return new Vector2((rand.nextDouble() - .5), (rand.nextDouble() - .5));
  }

  int compareTo(Rocket that) {
    if (this.fitness < that.fitness) return -1;
    return 1;
  }
}
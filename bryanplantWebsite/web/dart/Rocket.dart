import 'RocketDNA.dart';
import 'dart:html';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Rocket{
  Vector2 pos;
  Vector2 vel;
  Vector2 acc;
  Vector2 grav;
  int width, height;
  int numGenes = 90;
  int nextGene = 0;
  int nextGeneCounter = 0;
  RocketDNA dna;
  double fitness;

  Rocket(double x, double y){
    pos = new Vector2(x, y);
    vel = new Vector2(0.0, -.5);
    acc = new Vector2(0.0, 0.0);
    grav = new Vector2(0.0, 0.005);
    width = 15;
    height = 40;
    dna = new RocketDNA(numGenes);
  }

  void calculateFitness(Vector2 target){
    double dist = pos.distanceTo(target);
    this.fitness = 1/dist;
  }

  void update(){
    acc.setFrom(dna.genes.elementAt(nextGene));
    acc.add(grav);
    vel.add(acc);
    if(vel.length > 4)
      vel = vel.normalized()*4.0;
    pos.add(vel);
    nextGeneCounter++;
    if(nextGeneCounter >= 5) {
      if (nextGene < dna.genes.length - 1)
        nextGene++;
      nextGeneCounter = 0;
    }
  }

  void draw(CanvasRenderingContext2D c2d){
    c2d.translate(pos.x+width/2, pos.y+height/2);
    Vector2 heading = vel.normalized();
    double angle = atan2(heading.y, heading.x);
    c2d.rotate(angle+PI/2);

    c2d.fillStyle = 'rgba(255, 255, 255, 0.5)';
    c2d.beginPath();
    c2d.lineTo(-width/2, -height/2);
    c2d.lineTo(-width/2, 0);
    c2d.lineTo(-width, height/2);
    c2d.lineTo(-width/2, height/2);
    c2d.lineTo(width/2, height/2);
    c2d.lineTo(width, height/2);
    c2d.lineTo(width/2, 0);
    c2d.lineTo(width/2, -height/2);
    c2d.lineTo(0, -height-height/6);
    c2d.lineTo(-width/2, -height/2);
    c2d.closePath();
    c2d.fill();

    c2d.fillStyle = 'rgba(255,165,0,0.5)';
    c2d.beginPath();
    c2d.lineTo(-width/2, height/2);
    c2d.lineTo(-width/2, 3*height/4);
    c2d.lineTo(-width/2+width/3, 5*height/8);
    c2d.lineTo(0, 3*height/4);
    c2d.lineTo(-width/2+2*width/3, 5*height/8);
    c2d.lineTo(width/2, 3*height/4);
    c2d.lineTo(width/2, height/2);
    c2d.closePath();
    c2d.fill();

    c2d.setTransform(1, 0, 0, 1, 0, 0);
  }
}
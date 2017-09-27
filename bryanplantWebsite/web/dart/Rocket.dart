import 'RocketDNA.dart';
import 'dart:html';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Rocket{
  Vector2 pos;  //vector containing position of star
  Vector2 vel;  //vector containing velocity of star
  Vector2 acc;  //vector containing acceleration of star
  Vector2 grav; //vector to simulate gravity
  int width, height;   //width and height of rocket
  int numGenes = 90;   //how many genes in DNA
  int nextGene = 0;    //what the next gene is
  int nextGeneCounter = 0;  //determines if nextGene should be incremented
  RocketDNA dna;  //DNA of rocket
  double fitness; //rocket's fitness

  //create new rocket
  Rocket(double x, double y){
    pos = new Vector2(x, y);
    vel = new Vector2(0.0, -.5);  //start rocket with upwards velocity
    acc = new Vector2(0.0, 0.0);
    grav = new Vector2(0.0, 0.005);
    width = 15;
    height = 40;
    dna = new RocketDNA(numGenes);
  }

  //calculate rocket's fitness based on distance to target
  void calculateFitness(Vector2 target){
    double dist = pos.distanceTo(target);
    this.fitness = 1/dist;
  }

  //update rocket
  void update(){
    acc.setFrom(dna.genes.elementAt(nextGene)); //set acceleration based on gene
    acc.add(grav);  //add gravity to acceleration vector
    vel.add(acc);   //add acceleration to velocity vector
    if(vel.length > 4)
      vel = vel.normalized()*4.0; //max velocity of rocket
    pos.add(vel); //add velocity to position vector
    nextGeneCounter++;
    if(nextGeneCounter >= 5) {  //move to next gene
      if (nextGene < dna.genes.length - 1)
        nextGene++;
      nextGeneCounter = 0;
    }
  }

  //draw rocket to canvas
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
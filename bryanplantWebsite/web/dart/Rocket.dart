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
  int numGenes = 50;   //how many genes in DNA
  int nextGene = 0;    //what the next gene is
  int nextGeneCounter = 0;  //determines if nextGene should be incremented
  RocketDNA dna;  //DNA of rocket
  double fitness; //rocket's fitness
  bool completed = false;
  bool crashed = false;
  int completedTime;

  //create new rocket
  Rocket.randDNA(double x, double y){
    pos = new Vector2(x, y);
    vel = new Vector2(0.0, -.5);  //start rocket with upwards velocity
    acc = new Vector2(0.0, 0.0);
    grav = new Vector2(0.0, 0.05);
    width = 15;
    height = 40;
    dna = new RocketDNA.giveNum(numGenes);
  }

  Rocket.givenDNA(double x, double y, RocketDNA dna){
    pos = new Vector2(x, y);
    vel = new Vector2(0.0, -.5);  //start rocket with upwards velocity
    acc = new Vector2(0.0, 0.0);
    grav = new Vector2(0.0, 0.005);
    width = 15;
    height = 40;
    this.dna = dna;
  }

  //calculate rocket's fitness based on distance to target
  void calculateFitness(Vector2 target){
    double dist = pos.distanceTo(target);
    if(dist == 0){
      this.fitness = 50.0;
    }
    else {
      this.fitness = 50 / (dist/(window.innerWidth/100));
    }
    if(completed){
      fitness += (numGenes/completedTime)*20;
    }
    if(crashed){
      fitness /= 10;
    }
  }

  //update rocket
  void update(Vector2 target, int targetRadius){
    if(!completed && pos.distanceTo(target) < targetRadius){
      completed = true;
      completedTime = nextGene;
      pos = target.clone();
    }

    Point point = new Point(pos.x, pos.y);

    if(pos.y > window.innerHeight || pos.y < 0 || pos.x < 0 || pos.x > window.innerWidth){
      crashed = true;
    }

    if(!completed && !crashed) {
      acc.setFrom(
          dna.genes.elementAt(nextGene)); //set acceleration based on gene
      acc.add(grav); //add gravity to acceleration vector
      vel.add(acc); //add acceleration to velocity vector
      if (vel.length > 4)
        vel = vel.normalized() * 4.0; //max velocity of rocket
      pos.add(vel); //add velocity to position vector
    }




    nextGeneCounter++;
    if (nextGeneCounter >= 10) { //move to next gene
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
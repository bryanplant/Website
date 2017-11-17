import 'dart:html';
import 'dart:math';
import 'package:vector_math/vector_math.dart'; // ignore: uri_does_not_exist

class Rocket implements Comparable<Rocket>{
  Random rand = new Random();
  Vector2 pos;  //vector containing position of star
  Vector2 vel;  //vector containing velocity of star
  Vector2 acc;  //vector containing acceleration of star
  Vector2 grav; //vector to simulate gravity
  int width, height;   //width and height of rocket
  int numGenes = 100;   //how many genes in DNA
  int curGene = 0;    //what the next gene is
  int nextGeneTime = 3;
  int nextGeneCounter = 0;  //determines if nextGene should be incremented
  List<Vector2> dna;
  double fitness; //rocket's fitness
  bool completed = false;
  bool crashed = false;
  double closestDistance = double.MAX_FINITE; //closest distance to goal during iteration
  double completedTime;
  double crashedTime;

  //create new rocket
  Rocket(double x, double y, List<Vector2> dna){
    pos = new Vector2(x, y);
    vel = new Vector2(0.0, -.5);  //start rocket with upwards velocity
    acc = new Vector2(0.0, 0.0);
    grav = new Vector2(0.0, 0.025);
    width = 15;
    height = 40;
    if(dna == null) {
      this.dna = new List<Vector2>(numGenes);
      for (int i = 0; i < numGenes; i++) { //set each gene to a random set of values
        this.dna[i] = randomGene();
      }
    }
    else{
      this.dna = dna;
    }
  }

  //calculate rocket's fitness based on distance to target
  void calculateFitness(Vector2 target){
    double dist = pos.distanceTo(target);
    double distY = (pos.y-target.y).abs();
    fitness = 0.0;

    //calculate fitness value for total distance
    if(dist != 0) {
      this.fitness += 200 / (sqrt(dist)+4);
    }
    else{
      this.fitness += 40;
    }

    //calculate fitness value for closest distance
    if(closestDistance != 0) {
      this.fitness += 100 / (sqrt(dist)+4);
    }
    else{
      this.fitness += 20;
    }

    //calculate fitness value for completing faster
    if(completed){
      fitness += 5*(numGenes/completedTime);
    }

    //calculate fitness value for crashing later
    if(crashed){
      fitness += 0.5*(numGenes/(numGenes-crashedTime));
    }
  }

  //update rocket
  void update(Vector2 target, int targetRadius, List<Rectangle> obstacles){
    if(!completed && pos.distanceTo(target) < targetRadius){
      completed = true;
      completedTime = curGene + 1/((nextGeneTime+1)-nextGeneCounter);
      pos = target.clone();
      closestDistance = 0.0;
    }

    if(!completed && !crashed) {
      acc.setFrom(dna.elementAt(curGene)); //set acceleration based on gene
      acc.add(grav); //add gravity to acceleration vector
      vel.add(acc); //add acceleration to velocity vector
      if (vel.length > 7.5)
        vel = vel.normalized() * 7.5; //max velocity of rocket
      pos.add(vel); //add velocity to position vector

      //check if collided with obstacles
      Point point = new Point(pos.x, pos.y);
      for (Rectangle r in obstacles){
        if(r.containsPoint(point)){
          crashed = true;
          crashedTime = curGene + 1/((nextGeneTime+1)-nextGeneCounter);
        }
      }

      //check if collided with window edges
      if(pos.y > window.innerHeight || pos.y < 0 || pos.x < 0 || pos.x > window.innerWidth){
        crashed = true;
        crashedTime = curGene + 1/((nextGeneTime+1)-nextGeneCounter);
      }

      //update closest position
      if(pos.distanceTo(target) < closestDistance)
        closestDistance = pos.distanceTo(target);
    }

    nextGeneCounter++;
    if (nextGeneCounter >= nextGeneTime) { //move to next gene
      if (curGene < dna.length - 1)
        curGene++;
      nextGeneCounter = 0;
    }
  }

  //draw rocket to canvas
  void draw(CanvasRenderingContext2D c2d){
    c2d.translate(pos.x, pos.y);
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

  Vector2 randomGene(){
    return new Vector2((rand.nextDouble()-.5), (rand.nextDouble()-.5));
  }

  int compareTo(Rocket that){
    if(this.fitness < that.fitness)
      return -1;
    return 1;
  }
}
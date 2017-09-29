import 'dart/Rocket.dart';
import 'dart/RocketDNA.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:collection';
import 'package:vector_math/vector_math.dart';

import 'dart/Star.dart';
import 'dart/StarColor.dart';


Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");        //HTML Canvas
CanvasRenderingContext2D c2d = canvas.getContext('2d'); //CanvasRenderContext

Queue stars = new Queue();  //contains star objects
int maxStars = 20;          //max number of stars to be on screen

Duration newStarTimer = new Duration(milliseconds: 200);  //how long until a new star should be created
DateTime lastTime = new DateTime.now();                   //stores time since last update

//list of colors that stars can be
List<StarColor> possibleColors = [new StarColor(155, 176, 255), new StarColor(170, 191, 255), new StarColor(202, 215, 255), new StarColor(248, 247, 255),
                                  new StarColor(255, 244, 234), new StarColor(255, 210, 161), new StarColor(255, 204, 111)];

int numRockets = 40;
List<Rocket> rockets = new List<Rocket>(numRockets);    //contains rocket objects

int targetRadius = 25;  //radius of target
Vector2 target = new Vector2(canvas.width/2, 2.0*targetRadius); //location of target

double maxFit = 0.0; //contains fitness for best rocket
double averageFit = 0.0;

Rectangle obstacle = new Rectangle(window.innerWidth/3, (2*window.innerHeight)/5, window.innerWidth/3, 50);

void main() {
  canvas.width = window.innerWidth;   //set width to width of browser window
  canvas.height = window.innerHeight; //set height to height of browser window

  //resize canvas and update target position when the browser window is resized
  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    target.x = canvas.width/2;
  });

  //create max number of stars without fading in
  for(int i = 0; i < maxStars; i++){
    newStar(false);
  }

  //create first generation of rockets
  for(int i = 0; i < rockets.length; i++){
    rockets[i] = new Rocket.randDNA(window.innerWidth / 2, window.innerHeight - 50.toDouble());
  }

  //update and draw approximately 60 times per second
  new Timer.periodic(new Duration(milliseconds: 17), (Timer t) {
    update();
    draw();
  });
}

//adds a new random star to the queue
//if fade == true, the star will fade in
void newStar(bool fade){
  int width = rand.nextInt(30) + 10;

  int x, y;
  bool valid;
  do{
    valid = true;
    x = rand.nextInt(canvas.width - width * 2) + width;
    y = rand.nextInt(canvas.height - width * 2) + width;
    for(Star star in stars){
      if ((x - star.x).abs() < star.width && (y - star.y).abs() < star.width) {
        valid = false;
        break;
      }
    }
  }while(!valid);
  StarColor color = possibleColors.elementAt(rand.nextInt(possibleColors.length));
  var r = color.r;
  var g = color.g;
  var b = color.b;
  Star star = new Star(x, y, width, r, g, b);
  stars.addLast(star);
  if(fade)
    star.fadingIn = true;
}

//updates stars and rockets
void update() {
  //create a new star if it has been the correct amount of time since last star created
  if(new DateTime.now().difference(lastTime) > newStarTimer) {
    newStar(true);
    lastTime = new DateTime.now();
  }

  //sets first elements of queue to fade out depending on how
  //many stars need to be deleted
  int fadingStars = stars.length-maxStars;
  for(int i = 0; i < fadingStars; i++){
    stars.elementAt(i).fadingOut = true;
  }

  //update stars
  for(Star s in stars){
    s.update();
  }

  //remove stars from queue if they are faded
  var source = stars.toList();
  for (int i = 0; i < source.length; i++){
    stars.removeWhere((s) => s.faded);
  }

  //update rocket
  for(Rocket r in rockets) {
    r.update(target, targetRadius, obstacle);
  }

  //create new generation if rockets are out of genes
  if(rockets[0].nextGene == rockets[0].numGenes-1)
    createNewGeneration();
}

void createNewGeneration(){
    //find the max fitness value
    maxFit = 0.0;
    double totalFit = 0.0;
    for(int i = 0; i < numRockets; i++) {
      rockets[i].calculateFitness(target);
      totalFit += rockets[i].fitness;
      if(rockets[i].fitness > maxFit)
        maxFit = rockets[i].fitness;
    }
    averageFit = totalFit/numRockets;

    //add each rockets DNA to the genePool a certain number of times
    //depending on each rocket's fitness
    List<RocketDNA> genePool = new List();
    for(int i = 0; i < numRockets; i++) {
      print(rockets[i].fitness);
      for(int j = 0; j < rockets[i].fitness*100; j++){
        genePool.add(rockets[i].dna);
      }
    }
    print("");

    for(int i = 0; i < numRockets; i++) {
      RocketDNA dna1 = genePool[rand.nextInt(genePool.length)];
      RocketDNA dna2 = genePool[rand.nextInt(genePool.length)];
      RocketDNA newDNA = dna1.splice(dna2);
      newDNA.mutate();
      rockets[i] = new Rocket.givenDNA(window.innerWidth/2, window.innerHeight - 50.0, newDNA);
    }
}

//draw everything to the canvas
void draw(){
  c2d.clearRect(0, 0, window.innerWidth, window.innerHeight); //clear screen
  for(Star s in stars){ //draw stars to canvas
    s.draw(c2d);
  }


  //draw target
  c2d.fillStyle = 'red';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius, 0, 2 * PI);
  c2d.stroke();
  c2d.fill();
  c2d.fillStyle = 'white';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius/1.5, 0, 2 * PI);
  c2d.stroke();
  c2d.fill();
  c2d.fillStyle = 'red';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius/4, 0, 2 * PI);
  c2d.stroke();
  c2d.fill();

  for(Rocket r in rockets) { //draw rockets to canvas
    r.draw(c2d);
  }

  c2d.fillStyle = 'white';
  c2d.fillRect(obstacle.left, obstacle.top, obstacle.width, obstacle.height);

  c2d.font = "14px sans-serif";
  c2d.textAlign = 'center';
  c2d.fillStyle = 'white';
  c2d.fillText("Target", window.innerWidth/2, 20);

  c2d.font = "12px sans-serif";
  c2d.fillStyle = 'white';
  c2d.textAlign = 'left';
  c2d.fillText("Average Fitness of Generation: " + averageFit.toStringAsFixed(4), 20, window.innerHeight-20);

  c2d.font = "12px sans-serif";
  c2d.fillStyle = 'white';
  c2d.textAlign = 'left';
  c2d.fillText("Max Fitness of Generation:         " + maxFit.toStringAsFixed(4), 20, window.innerHeight-40);

  c2d.font = "48px sans-serif";
  c2d.textAlign = 'center';
  c2d.fillStyle = 'white';
  c2d.fillText("Bryan Plant", window.innerWidth/2, window.innerHeight/4);
}




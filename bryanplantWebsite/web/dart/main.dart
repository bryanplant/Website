import 'Rocket.dart';
import 'RocketDNA.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:collection';
import 'package:vector_math/vector_math.dart';

import 'Star.dart';
import 'StarColor.dart';


Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");        //HTML Canvas
CanvasRenderingContext2D c2d = canvas.getContext('2d'); //CanvasRenderContext
HtmlElement nameHeader = querySelector('#name');
HtmlElement infoHeader = querySelector('#info');
HtmlElement menuHeader = querySelector('#menu');

List<Rectangle> obstacles = [new Rectangle(nameHeader.parent.offsetLeft+nameHeader.offsetLeft, nameHeader.parent.offsetTop+nameHeader.offsetTop, nameHeader.clientWidth, nameHeader.clientHeight),
                             new Rectangle(infoHeader.parent.offsetLeft+infoHeader.offsetLeft, infoHeader.parent.offsetTop+infoHeader.offsetTop, infoHeader.clientWidth, infoHeader.clientHeight),
                             new Rectangle(menuHeader.parent.offsetLeft+menuHeader.offsetLeft, menuHeader.parent.offsetTop+menuHeader.offsetTop, menuHeader.clientWidth, menuHeader.clientHeight)];

Queue stars = new Queue();  //contains star objects
int maxStars = 20;          //max number of stars to be on screen

Duration newStarTimer = new Duration(milliseconds: 200);  //how long until a new star should be created
DateTime lastTime = new DateTime.now();                   //stores time since last update

//list of colors that stars can be
List<StarColor> possibleColors = [new StarColor(155, 176, 255), new StarColor(170, 191, 255), new StarColor(202, 215, 255), new StarColor(248, 247, 255),
                                  new StarColor(255, 244, 234), new StarColor(255, 210, 161), new StarColor(255, 204, 111)];

int numRockets = 40;
List<Rocket> rockets = new List<Rocket>(numRockets);    //contains rocket objects

int targetRadius = 35;  //radius of target
Vector2 target = new Vector2(canvas.width/2, 2.0*targetRadius); //location of target

double maxFit = 0.0; //contains fitness for best rocket
double averageFit = 0.0;

int genNum = 1;

void main() {
  canvas.width = window.innerWidth;   //set width to width of browser window
  canvas.height = window.innerHeight; //set height to height of browser window

  //resize canvas and update target position when the browser window is resized
  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    target.x = canvas.width/2;
    obstacles = [new Rectangle(nameHeader.parent.offsetLeft+nameHeader.offsetLeft, nameHeader.parent.offsetTop+nameHeader.offsetTop, nameHeader.clientWidth, nameHeader.clientHeight),
    new Rectangle(infoHeader.parent.offsetLeft+infoHeader.offsetLeft, infoHeader.parent.offsetTop+infoHeader.offsetTop, infoHeader.clientWidth, infoHeader.clientHeight),
    new Rectangle(menuHeader.parent.offsetLeft+menuHeader.offsetLeft, menuHeader.parent.offsetTop+menuHeader.offsetTop, menuHeader.clientWidth, menuHeader.clientHeight)];
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
  bool allDone = true;
  for(Rocket r in rockets) {
    r.update(target, targetRadius, obstacles);
    if (!r.crashed && !r.completed){
       allDone = false;
    }
  }

  if(allDone){
    createNewGeneration();
  }

  //create new generation if rockets are out of genes
  if(rockets[0].nextGene == rockets[0].numGenes-1)
    createNewGeneration();
}

void createNewGeneration(){
  genNum++;
  //find the max fitness value
  maxFit = 0.0;
  double totalFit = 0.0;
  double fastestTime = 1000.0;
  int fastestRocket=-1;
  for(int i = 0; i < numRockets; i++) {
    rockets[i].calculateFitness(target);
    totalFit += rockets[i].fitness;
    if(rockets[i].fitness > maxFit)
      maxFit = rockets[i].fitness;

    if(rockets[i].completed) {
      if (rockets[i].completedTime < fastestTime) {
        fastestTime = rockets[i].completedTime;
        fastestRocket = i;
      }
    }
  }
  averageFit = totalFit/numRockets;

  if(fastestRocket != -1) {
    rockets[fastestRocket].fitness += 25;
    print(rockets[fastestRocket].fitness);
  }

  //add each rockets DNA to the genePool a certain number of times
  //depending on each rocket's fitness
  List<RocketDNA> genePool = new List();
  for(int i = 0; i < numRockets; i++) {
    for (int j = 0; j < rockets[i].fitness * 100; j++) {
      genePool.add(rockets[i].dna);
    }
  }

  for(int i = 0; i < numRockets; i++) {
    RocketDNA dna1 = genePool[rand.nextInt(genePool.length)];
    RocketDNA dna2 = dna1;
    while(dna2.equals(dna1)) {
      dna2 = genePool[rand.nextInt(genePool.length)];
    }

    RocketDNA newDNA;
    if(rand.nextInt(2) == 0)
      newDNA = dna1.crossover(dna2);
    else
      newDNA = dna2.crossover(dna1);
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

/*  c2d.fillStyle = 'rgba(255, 0, 0, .2)';
  for(Rectangle r in obstacles) {
    c2d.fillRect(r.left, r.top, r.width, r.height);
  }*/

  c2d.font = "12px sans-serif";
  c2d.fillStyle = 'white';
  c2d.textAlign = 'left';
  c2d.fillText("Generation Number: " + genNum.toString(), 20, window.innerHeight-60);
  c2d.fillText("Max Fitness of Generation: " + maxFit.toStringAsFixed(4), 20, window.innerHeight-40);
  c2d.fillText("Average Fitness of Generation: " + averageFit.toStringAsFixed(4), 20, window.innerHeight-20);
}




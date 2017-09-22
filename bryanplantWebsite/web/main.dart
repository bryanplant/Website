import 'dart/Rocket.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:collection';

import 'dart/Star.dart';
import 'dart/StarColor.dart';

import 'package:vector_math/vector_math.dart';

Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");
CanvasRenderingContext2D c2d = canvas.getContext('2d');

Queue stars = new Queue();
int maxStars = 20;

Duration newStarTimer = new Duration(milliseconds: 200);
DateTime lastTime = new DateTime.now();

List<StarColor> possibleColors = [new StarColor(155, 176, 255), new StarColor(170, 191, 255), new StarColor(202, 215, 255), new StarColor(248, 247, 255),
                                  new StarColor(255, 244, 234), new StarColor(255, 210, 161), new StarColor(255, 204, 111)];

List<Rocket> rockets = new List<Rocket>(30);

int targetRadius = 25;
Vector2 target = new Vector2(canvas.width/2, 2.0*targetRadius);

double mostFit = 0.0;

void main() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    target.x = canvas.width/2;
  });

  for(int i = 0; i < maxStars; i++){
    newStar(false);
  }

  for(int i = 0; i < rockets.length; i++){
    rockets[i] = new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble());
  }


  new Timer.periodic(new Duration(milliseconds: 17), (Timer t) {
    update();
    draw();
  });
}

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

void update() {
  if(new DateTime.now().difference(lastTime) > newStarTimer) {
    newStar(true);
    lastTime = new DateTime.now();
  }

  int fadingStars = stars.length-maxStars;
  for(int i = 0; i < fadingStars; i++){
    stars.elementAt(i).fadingOut = true;
  }

  for(Star s in stars){
    s.update();
  }

  var source = stars.toList();
  for (int i = 0; i < source.length; i++){
    stars.removeWhere((s) => s.faded);
  }

  for(Rocket r in rockets) {
    r.update();
  }

  if(rockets[0].nextGene == rockets[0].numGenes-1) {
    mostFit = 0.0;
    for (int i = 0; i < rockets.length; i ++) {
      rockets[i].calculateFitness(target);
      if(rockets[i].fitness > mostFit)
        mostFit = rockets[i].fitness;
      rockets[i] = new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble());
    }
  }
}

void draw(){
  c2d.clearRect(0, 0, window.innerWidth, window.innerHeight);
  for(Star s in stars){
    s.draw(c2d);
  }

  for(Rocket r in rockets) {
    r.draw(c2d);
  }

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

  c2d.font = "14px sans-serif";
  c2d.textAlign = 'center';
  c2d.fillStyle = 'white';
  c2d.fillText("Target", window.innerWidth/2, 20);

  c2d.font = "12px sans-serif";
  c2d.fillStyle = 'white';
  c2d.textAlign = 'left';
  c2d.fillText("Max Fitness of Generation: " + mostFit.toStringAsFixed(4), 20, window.innerHeight-20);

  c2d.font = "48px sans-serif";
  c2d.textAlign = 'center';
  c2d.fillStyle = 'white';
  c2d.fillText("Bryan Plant", window.innerWidth/2, window.innerHeight/4);
}




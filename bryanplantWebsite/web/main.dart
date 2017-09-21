import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:collection';

import 'dart/Star.dart';
import 'dart/StarColor.dart';

Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");
CanvasRenderingContext2D c2d = canvas.getContext('2d');
String backgroundColor = '#091223';

Queue stars = new Queue();
int maxStars = 15;
List<Star> toRemove = new List();

Duration newStarTimer = new Duration(milliseconds: 200);
DateTime lastTime = new DateTime.now();

List<StarColor> possibleColors = [new StarColor(155, 176, 255), new StarColor(170, 191, 255), new StarColor(202, 215, 255), new StarColor(248, 247, 255),
                                  new StarColor(255, 244, 234), new StarColor(255, 210, 161), new StarColor(255, 204, 111)];

void main() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  });

  for(int i = 0; i < maxStars; i++){
    newStar(false);
  }

  new Timer.periodic(new Duration(milliseconds: 20), (Timer t) {
    update();
    draw(window.innerWidth, window.innerHeight);
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
  double a = width/(40/width);
  Star star = new Star(x, y, width, r, g, b, a);
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
}

void draw(int width, int height){
  c2d.clearRect(0, 0, width, height);
  drawBackground();
  for(Star s in stars){
    s.draw(c2d);
  }

  c2d.font = "48px sans-serif";
  c2d.textAlign = 'center';
  c2d.fillStyle = 'white';
  c2d.fillText("Bryan Plant", window.innerWidth/2, window.innerHeight/4);
}

void drawBackground() {
  c2d.fillStyle = backgroundColor;
  c2d.fillRect(0, 0, canvas.width, canvas.height);
}




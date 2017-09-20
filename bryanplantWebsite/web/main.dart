import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:collection';

import 'dart/Star.dart';

Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");
CanvasRenderingContext2D c2d = canvas.getContext('2d');
String backgroundColor = '#091223';

Queue stars = new Queue();
int maxStars = 25;
Duration newStarTimer = new Duration(milliseconds: 200);
DateTime lastTime = new DateTime.now();

void drawScreen() {
  c2d.fillStyle = backgroundColor;
  c2d.fillRect(0, 0, canvas.width, canvas.width);
  c2d.font = "48px sans-serif";
  c2d.fillStyle = 'white';
  c2d.fillText("Bryan Plant", 50, 50);
}

void main() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  drawScreen();

  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    drawScreen();

    for(Star star in stars){
      star.draw(c2d);
    }
  });

  for(int i = 0; i < maxStars; i++){
    newStar(false);
  }

  new Timer.periodic(new Duration(milliseconds: 17), (Timer t) => update());
  ;
}

void update(){
  if(new DateTime.now().difference(lastTime) > newStarTimer) {
    newStar(true);
    lastTime = new DateTime.now();
  }

  if(stars.length > maxStars)
    stars.removeLast().fadeOut(c2d, backgroundColor);
}

void newStar(bool fade){
  int width = rand.nextInt(50) + 20;

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
      else if(x < 320 && y < 75) {
        valid = false;
        break;
      }
    }
  }while(!valid);
  int r = rand.nextInt(255);
  int g = rand.nextInt(255);
  int b = rand.nextInt(255);
  Star star = new Star(x, y, width, r, g, b);
  stars.addFirst(star);
  if(fade)
    star.fadeIn(c2d);
  else
    star.draw(c2d);
}


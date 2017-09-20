import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart/Star.dart';
import 'dart:collection';

Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");
CanvasRenderingContext2D c2d = canvas.getContext('2d');
Queue stars = new Queue();
int maxStars = 20;
String backgroundColor = '#091223';

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



  const newStarTime = const Duration(milliseconds:200);

  new Timer.periodic(newStarTime, (Timer t) => newStar());
}

void newStar(){
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
  fadeStarIn(star);

  if(stars.length > maxStars)
    fadeStarOut();
}

void deleteStar(){
  Star star = stars.removeLast();
  c2d.fillStyle = backgroundColor;
  c2d.fillRect(star.x-star.width/2, star.y-star.width/2, star.width, star.width);
}

void fadeStarIn(Star star){
  star.alpha = .05;
  star.draw(c2d);

  new Timer(new Duration(milliseconds: 75), () {
    star.alpha = .1;
    star.draw(c2d);
  });
  new Timer(new Duration(milliseconds: 150), () {
    star.alpha = .2;
    star.draw(c2d);
  });
  new Timer(new Duration(milliseconds: 225), () {
    star.alpha = 1.0;
    star.draw(c2d);
  });
}

void fadeStarOut(){
  Star star = stars.removeLast();
  c2d.fillStyle = backgroundColor;
  c2d.fillRect(star.x-star.width/2, star.y-star.width/2, star.width, star.width);
  star.alpha = .2;
  star.draw(c2d);
  new Timer(new Duration(milliseconds: 75), () {
    c2d.fillStyle = backgroundColor;
    c2d.fillRect(star.x-star.width/2, star.y-star.width/2, star.width, star.width);
    star.alpha = .1;
    star.draw(c2d);
  });
  new Timer(new Duration(milliseconds: 150), () {
    c2d.fillStyle = backgroundColor;
    c2d.fillRect(star.x-star.width/2, star.y-star.width/2, star.width, star.width);
    star.alpha = .05;
    star.draw(c2d);
  });
  new Timer(new Duration(milliseconds: 225), () {
    c2d.fillStyle = backgroundColor;
    c2d.fillRect(star.x-star.width/2, star.y-star.width/2, star.width, star.width);
  });
}




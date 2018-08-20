import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';


Random rand;
CanvasElement canvas; //HTML Canvas
CanvasRenderingContext2D c2d; //CanvasRenderContext
Timer updateTimer;

double x, y;

void main() {
  init(); //initialize canvas and window listener
}

void init() {
  x = 250.0;
  y = 1000.0;

  canvas = querySelector("#canvas");
  c2d = canvas.getContext('2d');
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  updateTimer = new Timer.periodic(new Duration(milliseconds: 33), (Timer t) {
    update();
  });

  //resize canvas and update target position when the browser window is resized
  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  });

  window.animationFrame.then(draw);
}

void update() {
  y -= 10;
}

draw(num delta) {
  c2d.clearRect(0, 0, window.innerWidth, window.innerHeight);

  double width = 15.0;
  double height = 40.0;

  c2d.translate(x, y);

  c2d.fillStyle = 'rgba(255, 255, 255, 0.5)';
  c2d.beginPath();
  c2d.lineTo(-width / 2, -height / 2);
  c2d.lineTo(-width / 2, 0);
  c2d.lineTo(-width, height / 2);
  c2d.lineTo(-width / 2, height / 2);
  c2d.lineTo(width / 2, height / 2);
  c2d.lineTo(width, height / 2);
  c2d.lineTo(width / 2, 0);
  c2d.lineTo(width / 2, -height / 2);
  c2d.lineTo(0, -height - height / 6);
  c2d.lineTo(-width / 2, -height / 2);
  c2d.closePath();
  c2d.fill();

  c2d.fillStyle = 'rgba(255,165,0,0.5)';
  c2d.beginPath();
  c2d.lineTo(-width / 2, height / 2);
  c2d.lineTo(-width / 2, 3 * height / 4);
  c2d.lineTo(-width / 2 + width / 3, 5 * height / 8);
  c2d.lineTo(0, 3 * height / 4);
  c2d.lineTo(-width / 2 + 2 * width / 3, 5 * height / 8);
  c2d.lineTo(width / 2, 3 * height / 4);
  c2d.lineTo(width / 2, height / 2);
  c2d.closePath();
  c2d.fill();

  c2d.setTransform(1, 0, 0, 1, 0, 0);

  window.animationFrame.then(draw);
}






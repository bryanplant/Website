import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';


Random rand;
CanvasElement canvas; //HTML Canvas
CanvasRenderingContext2D c2d; //CanvasRenderContext
Timer updateTimer;

Vector2 pos;
Vector2 vel;

void main() {
  init(); //initialize canvas and window listener
}

void init() {
  canvas = querySelector("#canvas");
  c2d = canvas.getContext('2d');
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  pos = new Vector2(canvas.width / 2, 1000.0);
  vel = new Vector2(0.0, -5.0);

  updateTimer = new Timer.periodic(new Duration(milliseconds: 33), (Timer t) {
    update();
  });

  //resize canvas and update target position when the browser window is resized
  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  });

  window.onKeyDown.listen(handleKeypress);

  window.animationFrame.then(draw);
}

void update() {
  pos += vel;
}

void handleKeypress(KeyboardEvent e) {
  switch(e.keyCode) {
    case KeyCode.RIGHT:
      vel.x = 5.0;
      break;
    case KeyCode.DOWN:
      vel.y = 5.0;
      break;
    case KeyCode.LEFT:
      vel.x = -5.0;
      break;
    case KeyCode.UP:
      vel.y = -5.0;
      break;
  }
}

draw(num delta) {
  c2d.clearRect(0, 0, window.innerWidth, window.innerHeight);

  double width = 15.0;
  double height = 40.0;

  c2d.translate(pos.x, pos.y);
  Vector2 heading = vel.normalized();
  double angle = atan2(heading.y, heading.x);
  c2d.rotate(angle + pi / 2);

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

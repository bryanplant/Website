import 'dart:async';
import 'dart:html';

class Star{
  int x;
  int y;
  int width;
  int r, g, b;
  double alpha;

  Star(int x, int y, int width, int r, int g, int b){
    this.x = x;
    this.y = y;
    this.width = width;
    this.r = r;
    this.g = g;
    this.b = b;
    alpha = 1.0;
  }

  void draw(CanvasRenderingContext2D c2d){
    c2d.fillStyle = 'rgba($r, $g, $b, $alpha)';
    c2d.beginPath();
    c2d.lineTo(x, y-width/2);
    c2d.lineTo(x+width/8, y-width/8);
    c2d.lineTo(x+width/2, y);
    c2d.lineTo(x+width/8, y+width/8);
    c2d.lineTo(x, y+width/2);
    c2d.lineTo(x-width/8, y+width/8);
    c2d.lineTo(x-width/2, y);
    c2d.lineTo(x-width/8, y-width/8);
    c2d.closePath();
    c2d.fill();

  }

  void fadeIn(CanvasRenderingContext2D c2d){
    alpha = .05;
    draw(c2d);

    new Timer(new Duration(milliseconds: 75), () {
      alpha = .1;
      draw(c2d);
    });
    new Timer(new Duration(milliseconds: 150), () {
      alpha = .2;
      draw(c2d);
    });
    new Timer(new Duration(milliseconds: 225), () {
      alpha = 1.0;
      draw(c2d);
    });
  }

  void fadeOut(CanvasRenderingContext2D c2d, String backgroundColor){
    delete(c2d, backgroundColor);
    alpha = .2;
    draw(c2d);
    new Timer(new Duration(milliseconds: 75), () {
      delete(c2d, backgroundColor);
      alpha = .1;
      draw(c2d);
    });
    new Timer(new Duration(milliseconds: 150), () {
      delete(c2d, backgroundColor);
      alpha = .05;
      draw(c2d);
    });
    new Timer(new Duration(milliseconds: 225), () {
      delete(c2d, backgroundColor);
    });
  }

  void delete(CanvasRenderingContext2D c2d, String backgroundColor){
    c2d.fillStyle = backgroundColor;
    c2d.fillRect(x-width/2, y-width/2, width, width);
  }
}
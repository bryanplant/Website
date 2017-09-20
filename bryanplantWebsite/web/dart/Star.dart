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

  draw(CanvasRenderingContext2D c2d){
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
}
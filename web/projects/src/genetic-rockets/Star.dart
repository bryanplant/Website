import 'dart:html';

class Star {
  int x;
  int y;
  int width;
  int r, g, b;
  double alpha;
  bool fadingOut = false;
  bool fadingIn = false;
  bool faded = false;
  int fadeOutStep = 0;
  int fadeInStep = 0;

  Star(int x, int y, int width, int r, int g, int b) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.r = r;
    this.g = g;
    this.b = b;
    this.alpha = 1.0;
  }

  void update() {
    //if star is fading in slowly increase alpha value
    if (fadingIn) {
      switch (fadeInStep) {
        case 0:
          alpha = .05;
          break;
        case 3:
          alpha = .1;
          break;
        case 5:
          alpha = .2;
          break;
        case 7:
          alpha = .3;
          break;
        case 9:
          fadingIn = false;
          break;
      }
      fadeInStep++;
    }
    //if star is fading out slowly decrease alpha value
    else if (fadingOut) {
      switch (fadeOutStep) {
        case 0:
          alpha = .3;
          break;
        case 1:
          alpha = .2;
          break;
        case 3:
          alpha = .1;
          break;
        case 4:
          alpha = .05;
          break;
        case 5:
          alpha = 0.0;
          faded = true;
          break;
      }
      fadeOutStep++;
    }
    //otherwise set the alpha value corresponding to the width of the star
    else {
      alpha = 1.0 / (40 / width) + .25;
      if (alpha > 1.0)
        alpha = 1.0;
    }
  }

  //draw the star to the canvas
  void draw(CanvasRenderingContext2D c2d) {
    c2d.fillStyle = 'rgba($r, $g, $b, $alpha)';
    c2d.beginPath();
    c2d.lineTo(x, y - width / 2);
    c2d.lineTo(x + width / 8, y - width / 8);
    c2d.lineTo(x + width / 2, y);
    c2d.lineTo(x + width / 8, y + width / 8);
    c2d.lineTo(x, y + width / 2);
    c2d.lineTo(x - width / 8, y + width / 8);
    c2d.lineTo(x - width / 2, y);
    c2d.lineTo(x - width / 8, y - width / 8);
    c2d.closePath();
    c2d.fill();
  }
}
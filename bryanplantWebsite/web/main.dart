import "dart:html";
import "dart:math";
import "dart:async";

Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");
CanvasRenderingContext2D c2d = canvas.getContext('2d');

void main() {
  int numStars = 1000;
  int numStarsDrawn = 0;
  List<int> starX = new List(numStars);
  List<int> starY = new List(numStars);
  List<int> starWidth = new List(numStars);
  List<String> starColor = new List(numStars);

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  drawScreen() {
    c2d.fillStyle = 'black';
    c2d.fillRect(0, 0, canvas.width, canvas.width);
    c2d.font = "48px sans-serif";
    c2d.fillStyle = 'white';
    c2d.fillText("Bryan Plant", 50, 50);
  }

  drawScreen();

  drawStar(int x, int y, int starWidth, String color){
    c2d.fillStyle = color;
    c2d.beginPath();
    c2d.lineTo(x, y-starWidth/2);
    c2d.lineTo(x+starWidth/8, y-starWidth/8);
    c2d.lineTo(x+starWidth/2, y);
    c2d.lineTo(x+starWidth/8, y+starWidth/8);
    c2d.lineTo(x, y+starWidth/2);
    c2d.lineTo(x-starWidth/8, y+starWidth/8);
    c2d.lineTo(x-starWidth/2, y);
    c2d.lineTo(x-starWidth/8, y-starWidth/8);
    c2d.closePath();
    c2d.fill();
  }

  deleteRect(int x, int y, int width){
    c2d.fillStyle = 'black';
    c2d.fillRect(x-width/2, y-width/2, width, width);
  }

  Future draw(int x, int y, int starWidth, String color){
    return new Future.delayed(const Duration(milliseconds: 250), () => drawStar(x, y, starWidth, color));
  }

  Future delete(int x, int y, int width){
    return new Future.delayed(const Duration(milliseconds: 3000), () => deleteRect(x, y, width));
  }

  Future run() async {
    for (int i = 0; i < numStars; i ++) {
      int r = rand.nextInt(255);
      int g = rand.nextInt(255);
      int b = rand.nextInt(255);
      int x;
      int y;
      int width = rand.nextInt(50)+20;
      bool valid = false;
      while (!valid) {
        valid = true;
        x = rand.nextInt(canvas.width - width*2) + width;
        y = rand.nextInt(canvas.height - width*2) + width;
        for (int j = 0; j < i; j++) {
          if ((x - starX[j]).abs() < starWidth[j] && (y - starY[j]).abs() < starWidth[j]) {
            valid = false;
            break;
          }
        }
      }
      starX[i] = x;
      starY[i] = y;
      starWidth[i] = width;
      String color = "rgb($r,$g,$b)";
      starColor[i] = color;
      await draw(x, y, width, color);
      delete(x, y, width);
      numStarsDrawn++;
    }

    window.onResize.listen((_) {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    });
  }

  window.onResize.listen((e){
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    drawScreen();

    for(int i = 0; i < numStarsDrawn; i++){
      drawStar(starX[i], starY[i], starWidth[i], starColor[i]);
    }
  });

  run();
}


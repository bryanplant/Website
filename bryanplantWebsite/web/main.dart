import "dart:html";
import "dart:math";
import "dart:async";

Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");
CanvasRenderingContext2D c2d = canvas.getContext('2d');

void main() {
  int numStars = 1000;
  List<int> starX = new List(numStars);
  List<int> starY = new List(numStars);

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  c2d.fillStyle = 'gray';
  c2d.fillRect(0, 0, canvas.width, canvas.width);

  drawStar(int x, int y, String color, int i){
    c2d.fillStyle = color;
    c2d.beginPath();
    c2d.arc(x, y, 10, 0, 2*PI, false);
    c2d.closePath();
    c2d.fill();

    c2d.fillStyle = 'black';
    c2d.fillRect(20, 5, 250, 23);
    c2d.fillStyle = 'white';
    c2d.font = '24px serif';
    c2d.fillText("Number of Circles: " + (i+1).toString(), 25, 25);
  }

  deleteRect(int x, int y){
    c2d.fillStyle = 'gray';
    c2d.fillRect(x-10, y-10, 20, 20);
  }

  Future draw(int x, int y, String color, int i){
    return new Future.delayed(const Duration(milliseconds: 100), () => drawStar(x, y, color, i));
  }

  Future delete(int x, int y){
    return new Future.delayed(const Duration(milliseconds: 3000), () => deleteRect(x, y));
  }

  Future run() async {
    for (int i = 0; i < numStars; i ++) {
      int r = rand.nextInt(255);
      int g = rand.nextInt(255);
      int b = rand.nextInt(255);
      int x;
      int y;
      bool valid = false;
      while (!valid) {
        valid = true;
        x = rand.nextInt(canvas.width - 20);
        y = rand.nextInt(canvas.height - 20);
        for (int j = 0; j < i; j++) {
          if ((x - starX[j]).abs() < 20 && (y - starY[j]).abs() < 20) {
            valid = false;
            break;
          }
        }
        starX[i] = x;
        starY[i] = y;
      }
      String color = "rgb($r,$g,$b)";
      await draw(x, y, color, i);
      //delete(x, y);
    }

    window.onResize.listen((_) {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    });
  }

  run();
}


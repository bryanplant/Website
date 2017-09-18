import "dart:html";
import "dart:math";
import "dart:async";

Random rand;
CanvasElement canvas = querySelector("#canvas");
CanvasRenderingContext2D c2d = canvas.getContext('2d');

Future main() async {
  rand = new Random();

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  c2d.fillStyle = 'gray';
  c2d.fillRect(0, 0, canvas.width, canvas.width);

  drawRect(int x, int y, String color){
    c2d.fillStyle = color;
    c2d.beginPath();
    c2d.arc(x, y, 10, 0, 2*PI, false);
    c2d.closePath();
    c2d.fill();
  }

  deleteRect(int x, int y){
    c2d.fillStyle = 'gray';
    c2d.fillRect(x-10, y-10, 20, 20);
  }

  Future draw(int x, int y, String color){
    return new Future.delayed(const Duration(milliseconds: 250), () => drawRect(x, y, color));
  }

  Future delete(int x, int y){
    return new Future.delayed(const Duration(milliseconds: 3000), () => deleteRect(x, y));
  }

  for(int i = 0; i < 100; i ++) {
    var r = rand.nextInt(255);
    var g = rand.nextInt(255);
    var b = rand.nextInt(255);
    var x = rand.nextInt(canvas.width-20);
    var y = rand.nextInt(canvas.height-20);
    String color = "rgb($r,$g,$b)";
    await draw(x, y, color);
    delete(x, y);
  }

  window.onResize.listen((_){
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  });
}


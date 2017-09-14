import "dart:html";
import "dart:math";
import "dart:async";

Random rand;
CanvasElement canvas;
CanvasRenderingContext2D c2d;


Future main() async {
  rand = new Random();
  canvas = querySelector("#canvas");
  c2d = canvas.getContext('2d');
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;


  drawRect(String color){
    c2d.fillStyle = color;
    c2d.fillRect(rand.nextInt(canvas.width-35), rand.nextInt(canvas.height-35), 30, 30);
  }

  Future draw(String color) async{
    return new Future.delayed(const Duration(milliseconds: 250), () => drawRect(color));
  }

  for(int i = 0; i < 100; i ++) {
    var r = rand.nextInt(255);
    var g = rand.nextInt(255);
    var b = rand.nextInt(255);
    String color = "rgb($r,$g,$b)";
    await draw(color);
  }

  window.onResize.listen((_){
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  });
}


import "dart:html";
import "dart:math";
var rand;
List<DivElement> box;

void main() {
  rand = new Random();

  var height = window.innerHeight.toString() + "px";
  querySelector("#wrapper").style.height = height;

  window.onResize.listen((Event e){
    var height = window.innerHeight.toString() + "px";
    querySelector("#wrapper").style.height = height;
  });

  box = [querySelector("#box1"), querySelector("#box2"), querySelector("#box3"), querySelector("#box4"),
         querySelector("#box5"), querySelector("#box6"), querySelector("#box7"), querySelector("#box8"),
         querySelector("#box9"), querySelector("#box10"), querySelector("#box11"), querySelector("#box12"),
         querySelector("#box13"), querySelector("#box14"), querySelector("#box15"), querySelector("#box16")];

  for(int i=0; i < box.length; i++){
    box[i].style.float = "left";
    box[i].style.width = "25%";
    box[i].style.height = "25%";
    box[i].style.backgroundColor = "blue";

    box[i].onMouseOver.listen((MouseEvent e){
      var r = rand.nextInt(255);
      var g = rand.nextInt(255);
      var b = rand.nextInt(255);
      String color = "rgb($r,$g,$b)";
      box[i].style.backgroundColor = color;
    });
  }
}


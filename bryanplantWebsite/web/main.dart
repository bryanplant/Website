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
}


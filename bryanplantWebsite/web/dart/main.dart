import 'RocketPopulation.dart';
import 'StarPopulation.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';


Random rand = new Random();
CanvasElement canvas = querySelector("#canvas");        //HTML Canvas
CanvasRenderingContext2D c2d = canvas.getContext('2d'); //CanvasRenderContext
InputElement speedSlider = querySelector('#slider');  //HTML slider

HtmlElement nameHeader = querySelector('#name');        //HTML obstacles
HtmlElement infoHeader = querySelector('#info');
HtmlElement menuHeader = querySelector('#menu');

//rectangles associated with HTML obstacles
List<Rectangle> obstacles = [new Rectangle(nameHeader.parent.offsetLeft+nameHeader.offsetLeft, nameHeader.parent.offsetTop+nameHeader.offsetTop, nameHeader.clientWidth, nameHeader.clientHeight),
                             new Rectangle(infoHeader.parent.offsetLeft+infoHeader.offsetLeft, infoHeader.parent.offsetTop+infoHeader.offsetTop, infoHeader.clientWidth, infoHeader.clientHeight),
                             new Rectangle(menuHeader.parent.offsetLeft+menuHeader.offsetLeft, menuHeader.parent.offsetTop+menuHeader.offsetTop, menuHeader.clientWidth, menuHeader.clientHeight)];

StarPopulation stars = new StarPopulation(20);        //star population
RocketPopulation rockets = new RocketPopulation(50);  //rocket population

int targetRadius = 35;  //radius of target
Vector2 target = new Vector2(canvas.width/2, 2.0*targetRadius); //location of target

Timer drawTimer;
Timer updateTimer;
int normalUpdateTime = 33;

void main() {
  init(); //initialize canvas and window listener
  stars.init(canvas); //initialize star population

  //initialize updateTimer
  updateTimer = new Timer.periodic(new Duration(milliseconds: 33), (Timer t) {
    update();
  });

  //draw approximately 30 times per second
  window.animationFrame.then(draw);
  /*drawTimer = new Timer.periodic(new Duration(milliseconds: 33), (Timer t) {
    draw();
  });*/
}

void init(){
  canvas.width = window.innerWidth;   //set width to width of browser window
  canvas.height = window.innerHeight; //set height to height of browser window

  //resize canvas and update target position when the browser window is resized
  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    target.x = canvas.width/2;
    obstacles = [new Rectangle(nameHeader.parent.offsetLeft+nameHeader.offsetLeft, nameHeader.parent.offsetTop+nameHeader.offsetTop, nameHeader.clientWidth, nameHeader.clientHeight),
    new Rectangle(infoHeader.parent.offsetLeft+infoHeader.offsetLeft, infoHeader.parent.offsetTop+infoHeader.offsetTop, infoHeader.clientWidth, infoHeader.clientHeight),
    new Rectangle(menuHeader.parent.offsetLeft+menuHeader.offsetLeft, menuHeader.parent.offsetTop+menuHeader.offsetTop, menuHeader.clientWidth, menuHeader.clientHeight)];
  });

  speedSlider.onInput.listen((e) {
    //update label
    querySelector('#sliderLabel').text = 'Speed: ' + speedSlider.value;

    //update updateTimer
    updateTimer.cancel();
    updateTimer = new Timer.periodic(new Duration(milliseconds: (normalUpdateTime~/double.parse(speedSlider.value))), (Timer t) {
      update();
    });
  });
}

//updates stars and rockets
void update() {
  stars.update(canvas); //update stars
  rockets.update(target, targetRadius, obstacles);  //update rockets
}

//draw everything to the canvas
draw(num delta){
  c2d.clearRect(0, 0, window.innerWidth, window.innerHeight); //clear screen

  stars.draw(c2d); //draw stars

  //draw target
  c2d.fillStyle = 'red';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius, 0, 2 * PI);
  c2d.stroke();
  c2d.fill();
  c2d.fillStyle = 'white';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius/1.5, 0, 2 * PI);
  c2d.stroke();
  c2d.fill();
  c2d.fillStyle = 'red';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius/4, 0, 2 * PI);
  c2d.stroke();
  c2d.fill();

  rockets.draw(c2d);  //draw rockets

  //draw text info about population
  c2d.font = "12px sans-serif";
  c2d.fillStyle = 'white';
  c2d.textAlign = 'left';
  c2d.fillText("Generation Number: " + rockets.genNum.toString(), 20, window.innerHeight-60);
  c2d.fillText("Max Fitness of Last Generation:        " + rockets.maxFit.toStringAsFixed(4), 20, window.innerHeight-40);
  c2d.fillText("Average Fitness of Last Generation: " + rockets.averageFit.toStringAsFixed(4), 20, window.innerHeight-20);

  window.animationFrame.then(draw);
}






import 'RocketPopulation.dart';
import 'StarPopulation.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';


Random rand;
CanvasElement canvas; //HTML Canvas
CanvasRenderingContext2D c2d; //CanvasRenderContext
InputElement speedSlider; //HTML slider

HtmlElement nameHeader; //HTML obstacles
HtmlElement infoHeader;
HtmlElement navBarHeader;

List<Rectangle> obstacles; //rectangles associated with HTML obstacles

StarPopulation stars; //star population
RocketPopulation rockets; //rocket population

int targetRadius; //radius of target
Vector2 target; //location of target

Timer drawTimer;
Timer updateTimer;
int normalUpdateTime;

void main() {
  init(); //initialize canvas and window listener
  stars.init(canvas); //initialize star population
}

void init() {
  rand = new Random();
  canvas = querySelector("#canvas");
  c2d = canvas.getContext('2d');
  speedSlider = querySelector('#slider');
  nameHeader = querySelector('#name');
  infoHeader = querySelector('#info');
  navBarHeader = querySelector('#navBar');

  canvas.width = window.innerWidth; //set width to width of browser window
  canvas.height = window.innerHeight; //set height to height of browser window

  stars = new StarPopulation(20);
  rockets = new RocketPopulation(50);

  obstacles = [
    new Rectangle(
      nameHeader.parent.offsetLeft + nameHeader.offsetLeft,
      nameHeader.parent.offsetTop + nameHeader.offsetTop,
      nameHeader.clientWidth, nameHeader.clientHeight),
    new Rectangle(infoHeader.parent.offsetLeft + infoHeader.offsetLeft,
      infoHeader.parent.offsetTop + infoHeader.offsetTop,
      infoHeader.clientWidth, infoHeader.clientHeight),
    new Rectangle(navBarHeader.parent.offsetLeft + navBarHeader.offsetLeft,
      navBarHeader.parent.offsetTop + navBarHeader.offsetTop,
      navBarHeader.clientWidth, navBarHeader.clientHeight)
  ];

  targetRadius = 35;
  target = new Vector2(canvas.width / 2, 2.0 * targetRadius);

  normalUpdateTime = 33;

  //initialize updateTimer
  updateTimer = new Timer.periodic(new Duration(milliseconds: 33), (Timer t) {
    update();
  });

  //detect slider change
  speedSlider.onMouseMove.listen((e) {
    var speed = speedSlider.value;
    var label = querySelector('#sliderLabel');

    if (double.parse(speed) != double.parse(
        label.text.substring(6))) { //check if there has been a change
      //update label
      label.text = 'Speed: ' + speed;

      //update updateTimer
      updateTimer.cancel();
      updateTimer = new Timer.periodic(new Duration(
          milliseconds: (normalUpdateTime ~/
              double.parse(speedSlider.value))), (Timer t) {
        update();
      });
    }
  });

  //detect slider change for IE
  speedSlider.onInput.listen((e) {
    var speed = speedSlider.value;
    var label = querySelector('#sliderLabel');

    if (double.parse(speed) != double.parse(
        label.text.substring(6))) { //check if there has been a change
      //update label
      label.text = 'Speed: ' + speed;

      //update updateTimer
      updateTimer.cancel();
      updateTimer = new Timer.periodic(new Duration(
          milliseconds: (normalUpdateTime ~/
              double.parse(speedSlider.value))), (Timer t) {
        update();
      });
    }
  });

  //resize canvas and update target position when the browser window is resized
  window.onResize.listen((e) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    target.x = canvas.width / 2;
    obstacles = [new Rectangle(
        nameHeader.parent.offsetLeft + nameHeader.offsetLeft,
        nameHeader.parent.offsetTop + nameHeader.offsetTop,
        nameHeader.clientWidth, nameHeader.clientHeight),
    new Rectangle(infoHeader.parent.offsetLeft + infoHeader.offsetLeft,
        infoHeader.parent.offsetTop + infoHeader.offsetTop,
        infoHeader.clientWidth, infoHeader.clientHeight),
    new Rectangle(navBarHeader.parent.offsetLeft + navBarHeader.offsetLeft,
        navBarHeader.parent.offsetTop + navBarHeader.offsetTop,
        navBarHeader.clientWidth, navBarHeader.clientHeight)
    ];
  });

  //draw to screen on animation frame
  window.animationFrame.then(draw);
}

//updates stars and rockets
void update() {
  stars.update(canvas); //update stars
  rockets.update(target, targetRadius, obstacles); //update rockets
}

//draw everything to the canvas
draw(num delta) {
  c2d.clearRect(0, 0, window.innerWidth, window.innerHeight); //clear screen

  stars.draw(c2d); //draw stars

  //draw target
  c2d.fillStyle = 'red';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius, 0, 2 * pi);
  c2d.stroke();
  c2d.fill();
  c2d.fillStyle = 'white';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius / 1.5, 0, 2 * pi);
  c2d.stroke();
  c2d.fill();
  c2d.fillStyle = 'red';
  c2d.beginPath();
  c2d.arc(target.x, target.y, targetRadius / 4, 0, 2 * pi);
  c2d.stroke();
  c2d.fill();

  rockets.draw(c2d); //draw rockets

  //draw text info about population
  c2d.font = "10pt sans-serif";
  c2d.fillStyle = 'white';
  c2d.textAlign = 'left';
  c2d.fillText("Generation Number: " + rockets.genNum.toString(), 20,
      window.innerHeight - 60);
  c2d.fillText("Max Fitness of Last Generation:        " +
      rockets.maxFit.toStringAsFixed(4), 20, window.innerHeight - 40);
  c2d.fillText("Average Fitness of Last Generation: " +
      rockets.averageFit.toStringAsFixed(4), 20, window.innerHeight - 20);

  window.animationFrame.then(draw);
}






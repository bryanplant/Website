import 'rocket_population.dart';
import 'star_population.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';


Random rand;
CanvasElement canvas;
CanvasRenderingContext2D c2d;
InputElement speedSlider;

 //HTML obstacles
HtmlElement nameHeader;
HtmlElement infoHeader;
List<Rectangle> obstacles;

StarPopulation stars;
RocketPopulation rockets;

int targetRadius;
Vector2 target;

Timer drawTimer;
Timer updateTimer;
int normalUpdateTime;

void main() {
  init();
  stars.init(canvas);
}

void init() {
  rand = new Random();
  canvas = querySelector("#canvas");
  c2d = canvas.getContext('2d');
  speedSlider = querySelector('#slider');
  nameHeader = querySelector('#name');
  infoHeader = querySelector('#info');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

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
        label.text.substring(6))) {
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
        label.text.substring(6))) {
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
    ];
  });

  //draw to screen on animation frame
  window.animationFrame.then(draw);
}

//updates stars and rockets
void update() {
  stars.update(canvas);
  rockets.update(target, targetRadius, obstacles);
}

//draw everything to the canvas
draw(num delta) {
  c2d.clearRect(0, 0, window.innerWidth, window.innerHeight);

  stars.draw(c2d);

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

  rockets.draw(c2d);

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






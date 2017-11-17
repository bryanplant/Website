import 'Star.dart';
import 'StarColor.dart';
import 'dart:collection';
import 'dart:html';
import 'dart:math';

class StarPopulation{
  Random rand;
  Queue stars = new Queue();  //contains star objects
  int maxStars;          //max number of stars to be on screen

  Duration newStarTimer = new Duration(milliseconds: 200);  //how long until a new star should be created
  DateTime lastTime = new DateTime.now();                   //stores time since last update

  //list of colors that stars can be
  List<StarColor> possibleColors = [new StarColor(155, 176, 255), new StarColor(170, 191, 255), new StarColor(202, 215, 255), new StarColor(248, 247, 255),
  new StarColor(255, 244, 234), new StarColor(255, 210, 161), new StarColor(255, 204, 111)];

  StarPopulation(int maxStars){
    try{
      rand = new Random.secure();
    }
    catch(exception){
      rand = new Random();
    }

    this.maxStars = maxStars;
  }

  void init(CanvasElement canvas){
    //create max number of stars without fading in
    for(int i = 0; i < maxStars; i++) {
      newStar(false, canvas);
    }
  }

  void update(CanvasElement canvas){
    //create a new star if it has been the correct amount of time since last star created
    if(new DateTime.now().difference(lastTime) > newStarTimer) {
      newStar(true, canvas);
      lastTime = new DateTime.now();
    }

    //sets first elements of queue to fade out depending on how
    //many stars need to be deleted
    int fadingStars = stars.length-maxStars;
    for(int i = 0; i < fadingStars; i++){
      stars.elementAt(i).fadingOut = true;
    }

    //update stars
    for(Star s in stars){
      s.update();
    }

    //remove stars from queue if they are faded
    var source = stars.toList();
    for (int i = 0; i < source.length; i++){
      stars.removeWhere((s) => s.faded);
    }
  }

  //draw stars to canvas
  void draw(CanvasRenderingContext2D c2d){
    for(Star s in stars){
      s.draw(c2d);
    }
  }

  //adds a new random star to the queue
  //if fade == true, the star will fade in
  void newStar(bool fade, CanvasElement canvas){
    int width = rand.nextInt(30) + 10;

    int x, y;
    bool valid;
    do{
      valid = true;
      x = rand.nextInt(canvas.width - width * 2) + width;
      y = rand.nextInt(canvas.height - width * 2) + width;
      for(Star star in stars){
        if ((x - star.x).abs() < star.width && (y - star.y).abs() < star.width) {
          valid = false;
          break;
        }
      }
    }while(!valid);
    StarColor color = possibleColors.elementAt(rand.nextInt(possibleColors.length));
    var r = color.r;
    var g = color.g;
    var b = color.b;
    Star star = new Star(x, y, width, r, g, b);
    stars.addLast(star);
    if(fade)
      star.fadingIn = true;
  }
}
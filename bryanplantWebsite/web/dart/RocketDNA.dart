import 'dart:math';
import 'package:vector_math/vector_math.dart';

class RocketDNA{
  Random random = new Random();
  List<Vector2> genes;

  RocketDNA(int num){
    genes = new List<Vector2>(num);
    for(int i = 0; i < num; i++){
      genes[i] = new Vector2(((random.nextDouble()*2)-1)/10, ((random.nextDouble()*2)-1)/10);
    }
  }
}
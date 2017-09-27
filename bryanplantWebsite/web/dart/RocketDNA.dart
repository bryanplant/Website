import 'dart:math';
import 'package:vector_math/vector_math.dart';

//DNA contains genes which correspond to forces to be applied to the rocket
class RocketDNA{
  Random random = new Random();
  List<Vector2> genes;  //vector containing genes

  RocketDNA(int num){
    genes = new List<Vector2>(num);
    for(int i = 0; i < num; i++){ //set each gene to a random set of values
      genes[i] = new Vector2(((random.nextDouble()*2)-1)/10, ((random.nextDouble()*2)-1)/10);
    }
  }
}
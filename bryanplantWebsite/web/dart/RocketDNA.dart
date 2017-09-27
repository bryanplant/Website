import 'dart:math';
import 'package:vector_math/vector_math.dart';

//DNA contains genes which correspond to forces to be applied to the rocket
class RocketDNA{
  Random rand = new Random();
  List<Vector2> genes;  //vector containing genes

  RocketDNA.giveNum(int num){
    genes = new List<Vector2>(num);
    for(int i = 0; i < num; i++){ //set each gene to a random set of values
      genes[i] = new Vector2(((rand.nextDouble()*2)-1)/10, ((rand.nextDouble()*2)-1)/10);
    }
  }

  RocketDNA.giveGenes(List<Vector2> genes){
    this.genes = new List<Vector2>(genes.length);
    for(int i = 0; i < genes.length; i++){
      this.genes[i] = genes[i];
    }
  }

  RocketDNA splice(RocketDNA that){
    int center = rand.nextInt(this.genes.length);
    List<Vector2> newGenes = new List(this.genes.length);
    for(int i = 0; i < this.genes.length; i++){
      if(i < center)
        newGenes[i] = this.genes[i];
      else
        newGenes[i] = that.genes[i];
    }
    return new RocketDNA.giveGenes(newGenes);
  }

  void mutate(){
    for(int i = 0; i < this.genes.length; i++){
      if(rand.nextInt(50) == 0){
        this.genes[i] = new Vector2(((rand.nextDouble()*2)-1)/10, ((rand.nextDouble()*2)-1)/10);
      }
    }
  }
}
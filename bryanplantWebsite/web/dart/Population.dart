import 'Rocket.dart';
import 'RocketDNA.dart';
import 'dart:html';

import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Population{
  Random rand = new Random();
  List<Rocket> rockets = new List<Rocket>();
  int size;
  static int genNum = 0;
  double maxFit;
  double averageFit;
  bool allDone;

  Population(int size){
    this.size = size;
  }

  void add(Rocket rocket){
    rockets.add(rocket);
  }

  void update(Vector2 target, int targetRadius, List<Rectangle> obstacles){
    allDone = true;
    for(Rocket r in rockets) {
      r.update(target, targetRadius, obstacles);
      if (!r.crashed && !r.completed) {
        allDone = false;
      }
    }
    if(rockets[0].nextGene == rockets[0].numGenes-1)
      allDone = true;
  }

  void draw(CanvasRenderingContext2D c2d){
    for(Rocket r in rockets){
      r.draw(c2d);
    }
  }

  Population newGeneration(Vector2 target) {
    genNum++;
    Population newGen = new Population(this.size);
    if (this.rockets.length == 0) {
      for (int i = 0; i < size; i ++) {
        newGen.add(new Rocket.randDNA(window.innerWidth / 2, window.innerHeight - 50.toDouble()));
        print("Called");
      }
      return newGen;
    }
    else {
      newGen = select(target);
      newGen = crossover();
      newGen = mutate();
      //return newGen;
      for (int i = 0; i < size; i++) {
        RocketDNA dna1 = genePool[rand.nextInt(genePool.length)];
        RocketDNA dna2 = dna1;
        while (dna2.equals(dna1)) {
          dna2 = genePool[rand.nextInt(genePool.length)];
        }

        RocketDNA newDNA;
        if (rand.nextInt(2) == 0)
          newDNA = dna1.crossover(dna2);
        else
          newDNA = dna2.crossover(dna1);
        newDNA.mutate();
        rockets[i] = new Rocket.givenDNA(
            window.innerWidth / 2, window.innerHeight - 50.0, newDNA);
      }
      return newGen;
    }
  }

  Population select(target){
    //find the max fitness value
    Population parents = new Population(size);
    maxFit = 0.0;
    double totalFit = 0.0;
    double fastestTime = 1000.0;
    int fastestRocket = -1;
    for (int i = 0; i < size; i++) {
      rockets[i].calculateFitness(target);
      totalFit += rockets[i].fitness;
      if (rockets[i].fitness > maxFit)
      maxFit = rockets[i].fitness;

      if (rockets[i].completed) {
        if (rockets[i].completedTime < fastestTime) {
          fastestTime = rockets[i].completedTime;
          fastestRocket = i;
       }
      }
    }
    averageFit = totalFit / size;

    if (fastestRocket != -1) {
      rockets[fastestRocket].fitness += 25;
      print(rockets[fastestRocket].fitness);
    }

    rockets.sort((a, b) => a.compareTo(b));

    for(int i = 0; i < size; i++){
      rockets[i].fitness = i.toDouble();
    }

    List<Rocket> pool = new List<Rocket>();
    for(int i = 0; i < size; i++){
      for(int j = 0; j < rockets[i].fitness.toInt(); j++){
        pool.add(rockets[i]);
      }
    }

    for(int i = 0; i < size; i++){
      int index = rand.nextInt(pool.length);
      parents.add(rockets[index]);
    }
  }

  Population crossover(){

  }

  Population mutate(){

  }
}
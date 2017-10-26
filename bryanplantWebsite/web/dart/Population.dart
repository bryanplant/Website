import 'Rocket.dart';
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
        newGen.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), null));
      }
      return newGen;
    }
    else {
      newGen = select(target);
      newGen = crossover(newGen);
      newGen = mutate(newGen);

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
      parents.add(pool[index]);
    }
    return parents;
  }

  Population crossover(Population parents){
    Population offspring = new Population(size);
    while(!parents.rockets.isEmpty){
      Rocket parent1 = parents.rockets[0];
      Rocket parent2 = parents.rockets[rand.nextInt(parents.rockets.length-1)+1];
      List<Vector2> dna1 = new List<Vector2>();
      List<Vector2> dna2 = new List<Vector2>();
      for (int i = 0; i < rockets[0].numGenes; i++) {
        if(rand.nextInt(2) == 0){
          dna1.add(parent1.dna[i]);
          dna2.add(parent2.dna[i]);
        }
        else{
          dna1.add(parent2.dna[i]);
          dna2.add(parent1.dna[i]);
        }
      }
      print(parents.rockets.length);
      offspring.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), dna1));
      offspring.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), dna2));
      parents.rockets.remove(parent1);
      parents.rockets.remove(parent2);
    }
    return offspring;
  }

  Population mutate(Population population){
    Population mutated = new Population(size);
    for(Rocket r in population.rockets){
      for(Vector2 gene in r.dna) {
        if (rand.nextInt(population.rockets[0].numGenes) == 0) {
          gene += new Vector2(rand.nextDouble()/20, rand.nextDouble()/20);
        }
      }
      mutated.add(r);
    }
    return mutated;
  }
}
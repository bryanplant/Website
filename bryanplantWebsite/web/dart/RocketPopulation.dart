import 'Rocket.dart';
import 'dart:html';

import 'dart:math';
import 'package:vector_math/vector_math.dart';

class RocketPopulation{
  Random rand = new Random();
  List<Rocket> rockets = new List<Rocket>();
  int size;
  int genNum = 0;
  double maxFit = 0.0;
  double averageFit = 0.0;
  bool allDone;

  RocketPopulation(int size){
    this.size = size;
    newGeneration();
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

    if(rockets[0].curGene == rockets[0].numGenes-1)
      allDone = true;

    if(allDone){
      newGeneration(target);
    }
  }

  void draw(CanvasRenderingContext2D c2d){
    for(Rocket r in rockets){
      r.draw(c2d);
    }
  }

  void newGeneration([Vector2 target]) {
    genNum++;
    if (rockets.length == 0) {
      for (int i = 0; i < size; i ++) {
        rockets.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), null));
      }
    }
    else {
      calcFitness(target);

      List<Rocket> parents = select();
      List<Rocket> offspring = uniformCrossover(parents);
      List<Rocket> newGen = mutate(offspring);

      rockets = newGen;
    }
  }

  void calcFitness(Vector2 target){
    maxFit = 0.0;
    double totalFit = 0.0;

    //calculate average fitness and maxFitness
    for (int i = 0; i < size; i++) {
      rockets[i].calculateFitness(target);
      totalFit += rockets[i].fitness;
      if (rockets[i].fitness > maxFit)
        maxFit = rockets[i].fitness;
    }
    averageFit = totalFit / size;

    rockets.sort((a, b) => a.compareTo(b));

    for(int i = 0; i < size; i++){
      rockets[i].fitness = i.toDouble() + 1;
    }
  }

  List<Rocket> select(){
    //find the max fitness value
    List<Rocket> parents = new List<Rocket>();
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

  List<Rocket> centerCrossover(List<Rocket> parents){
    List<Rocket> offspring = new List<Rocket>();

    while(!parents.isEmpty){
      Rocket parent1 = parents[0];
      Rocket parent2 = parents[rand.nextInt(parents.length-1)+1];
      List<Vector2> dna1 = new List<Vector2>();
      List<Vector2> dna2 = new List<Vector2>();

      int center = rand.nextInt(parent1.dna.length);
      for(int i = 0; i < parent1.dna.length; i++){
        if(i < center){
          dna1.add(parent1.dna[i]);
          dna2.add(parent2.dna[i]);
        }
        else{
          dna1.add(parent2.dna[i]);
          dna2.add(parent1.dna[i]);
        }
      }

      offspring.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), dna1));
      offspring.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), dna2));
      parents.remove(parent1);
      parents.remove(parent2);
    }
    return offspring;
  }

  List<Rocket> uniformCrossover(List<Rocket> parents){
    List<Rocket> offspring = new List<Rocket>();

    while(!parents.isEmpty){
      Rocket parent1 = parents[0];
      Rocket parent2 = parents[rand.nextInt(parents.length-1)+1];
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
      offspring.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), dna1));
      offspring.add(new Rocket(window.innerWidth / 2, window.innerHeight - 50.toDouble(), dna2));
      parents.remove(parent1);
      parents.remove(parent2);
    }
    return offspring;
  }

  List<Rocket> mutate(List<Rocket> population){
    List<Rocket> mutated = new List<Rocket>();
    for(Rocket r in population){
      for(int i = 0; i < r.numGenes; i++) {
        if (rand.nextInt(r.numGenes) == 0) {
          r.dna[i] = r.randomGene();
        }
      }
      mutated.add(r);
    }
    return mutated;
  }
}
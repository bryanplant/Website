import 'dart:async';
import 'dart:convert';

import 'rocket.dart';
import 'dart:html';

import 'dart:math';
import 'vector2.dart';
import 'package:http/browser_client.dart';

class RocketPopulation {
  Random rand = new Random();
  List<Rocket> rockets = new List<Rocket>();
  int size;
  int genNum = 0;
  double maxFit = 0.0;
  double averageFit = 0.0;
  bool allDone;
  bool generating = false;
  bool online = true;

  RocketPopulation(int size) {
    this.size = size;
    newGeneration();
  }

  void add(Rocket rocket) {
    rockets.add(rocket);
  }

  void update(Vector2 target, int targetRadius, List<Rectangle> obstacles) {
    allDone = true;
    for (Rocket r in rockets) {
      r.update(target, targetRadius, obstacles);
      if (!r.crashed && !r.completed) {
        allDone = false;
      }
    }

    if (rockets[0].curGene == rockets[0].numGenes - 1)
      allDone = true;

    if (allDone && !generating) {
      newGeneration(target);
    }
  }

  void draw(CanvasRenderingContext2D c2d) {
    for (Rocket r in rockets) {
      r.draw(c2d);
    }
  }

  Future newGeneration([Vector2 target]) async {
    genNum++;
    if (rockets.length == 0) {
      for (int i = 0; i < size; i ++) {
        rockets.add(new Rocket(null));
      }
    }
    else {
      calcFitness(target);

      generating = true;
      // server call to generate a new generation
      online = await newGenerationServer();

      if(!online) {
        // generate new generation locally
        newGenerationLocal();
      }
      generating = false;
    }
  }

  Future<bool> newGenerationServer() async {
    var url = 'https://us-central1-project-885b4.cloudfunctions.net/function-1';
    var data = json.encode(this.rockets);
    var response;
    var client = new BrowserClient();
    try{
      response = await client.post(url, body: data);
    }
    catch (e) {
      return false;
    }

    if (response != null && response.statusCode == 200) {
      rockets = new List<Rocket>();
      for (Map rocketMap in json.decode(response.body)) {
        rockets.add(Rocket.fromJson(rocketMap));
      }
    }
    return (response != null);
  }

  void newGenerationLocal() {
    List<Rocket> parents = select();
    List<Rocket> offspring = uniformCrossover(parents);
    List<Rocket> newGen = mutate(offspring);

    rockets = newGen;
  }

  void calcFitness(Vector2 target) {
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

    for (int i = 0; i < size; i++) {
      rockets[i].fitness = i.toDouble() + 1;
    }

    rockets.last.fitness *= 2;
  }

  List<Rocket> select() {
    //find the max fitness value
    List<Rocket> parents = new List<Rocket>();
    List<Rocket> pool = new List<Rocket>();
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < rockets[i].fitness.toInt(); j++) {
        pool.add(rockets[i]);
      }
    }

    for (int i = 0; i < size; i++) {
      int index = rand.nextInt(pool.length);
      parents.add(pool[index]);
    }
    return parents;
  }

  List<Rocket> centerCrossover(List<Rocket> parents) {
    List<Rocket> offspring = new List<Rocket>();

    while (!parents.isEmpty) {
      Rocket parent1 = parents[0];
      Rocket parent2 = parents[rand.nextInt(parents.length - 1) + 1];
      List<Vector2> dna1 = new List<Vector2>();
      List<Vector2> dna2 = new List<Vector2>();

      //crossover at parent1 crossover rate
      if (rand.nextDouble() < parent1.crossoverRate) {
        int center = rand.nextInt(parent1.dna.length);
        for (int i = 0; i < parent1.dna.length; i++) {
          if (i < center) {
            dna1.add(parent1.dna[i]);
            dna2.add(parent2.dna[i]);
          }
          else {
            dna1.add(parent2.dna[i]);
            dna2.add(parent1.dna[i]);
          }
        }
      }
      else {
        dna1 = parent1.dna;
        dna2 = parent2.dna;
      }

      offspring.add(new Rocket(dna1));
      offspring.add(new Rocket(dna2));
      parents.remove(parent1);
      parents.remove(parent2);
    }
    return offspring;
  }

  List<Rocket> uniformCrossover(List<Rocket> parents) {
    List<Rocket> offspring = new List<Rocket>();

    while (!parents.isEmpty) {
      Rocket parent1 = parents[0];
      Rocket parent2 = parents[rand.nextInt(parents.length - 1) + 1];
      List<Vector2> dna1 = new List<Vector2>();
      List<Vector2> dna2 = new List<Vector2>();

      //crossover at parent1 crossover rate
      if (rand.nextDouble() < parent1.crossoverRate) {
        for (int i = 0; i < rockets[0].numGenes; i++) {
          if (rand.nextInt(2) == 0) {
            dna1.add(parent1.dna[i]);
            dna2.add(parent2.dna[i]);
          }
          else {
            dna1.add(parent2.dna[i]);
            dna2.add(parent1.dna[i]);
          }
        }
      }
      else {
        dna1 = parent1.dna;
        dna2 = parent2.dna;
      }

      offspring.add(new Rocket(dna1));
      offspring.add(new Rocket(dna2));
      parents.remove(parent1);
      parents.remove(parent2);
    }
    return offspring;
  }

  List<Rocket> mutate(List<Rocket> population) {
    List<Rocket> mutated = new List<Rocket>();
    for (Rocket r in population) {
      for (int i = 0; i < r.numGenes; i++) {
        if (rand.nextDouble() < r.mutationRate) {
          r.dna[i] = r.randomGene();
        }
      }
      mutated.add(r);
    }
    return mutated;
  }
}
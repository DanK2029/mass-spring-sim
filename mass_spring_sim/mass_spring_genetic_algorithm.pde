import java.util.*;

Creature geneticAlgorithm(int populationSize, Creature baseCreature) {
  int winningCreatureIndex = 0;
  float winningThreshold = 500.0;
  float topFitness = 0.0;
  boolean winningCreatureFound = false;
  int testTimeSpan = 8000;
  int generationCount = 0;
  ArrayList<Creature> population = generateInitialPopulation(populationSize, baseCreature);
  do {
    println("loop");
    generationCount++;
    population = evaluatePopulation(population, testTimeSpan);
    println("Generation: "+generationCount);
    for (int i = 0; i < population.size(); i++) {
      println("Creature "+population.get(i).id+", fitness: "+population.get(i).fitness);
      if (population.get(i).fitness >= topFitness) {
        topFitness = population.get(i).fitness;
        winningCreatureIndex = i;
      }
      if (population.get(i).fitness > winningThreshold) {
        winningCreatureFound = true;
      }
    }
    
    println("Top Fitness: "+population.get(winningCreatureIndex).fitness);
    
  } while (generationCount < 7);//!winningCreatureFound);
  
   
  return population.get(winningCreatureIndex);
}

ArrayList<Creature> generateInitialPopulation(int populationSize, Creature baseCreature) {
  println("initial creation");
  ArrayList<Creature> population = new ArrayList<Creature>();
  for (int i = 0; i < populationSize; i++) {
    Creature copiedCreature = baseCreature.copyCreature();
    copiedCreature.mutate();
    population.add(copiedCreature);
  }
  return population;
}


ArrayList<Creature> evaluatePopulation(ArrayList<Creature> population, int testTimeSpan) {
  println("evaluate population");
  
  for (int i = 0; i < population.size(); i++) {
    testCreature(population.get(i), testTimeSpan);
  }
  
  // sort creature population based on fitness in accending order
  Collections.sort(population, new Comparator<Creature>() {
    public int compare(Creature c1, Creature c2) {
      if (c1.fitness == c2.fitness)
        return 0;
      return c1.fitness < c2.fitness ? -1 : 1;
    }
  });
  
  // remove creatures with the lower half of fitness
  for (int i = 0; i < population.size()/2; i++) {
      population.remove(i);
  }
  
  // each creature in population has a child and mutates it those children are then added to the population
  ArrayList<Creature> newPopulation = new ArrayList<Creature>();
  for (int i = 0; i < population.size()/2; i++) {
    Creature newCreature = population.get(i);
    newCreature.mutate();
    newPopulation.add(newCreature);
  }
  
  population.addAll(newPopulation);
  
  // sort creature population based on fitness in accending order
  Collections.sort(population, new Comparator<Creature>() {
    public int compare(Creature c1, Creature c2) {
      if (c1.fitness == c2.fitness)
        return 0;
      return c1.fitness < c2.fitness ? -1 : 1;
    }
  });
  return population;
}


void testCreature(Creature c, int timeSpan) {
  Creature testCreature = c.copyCreature();
  
  ArrayList<Creature> singleCreatureList = new ArrayList<Creature>();
  singleCreatureList.add(testCreature);
  
  for (int i = 0; i < timeSpan; i++) {
    simStep(singleCreatureList);
  }
  
  float fitness = singleCreatureList.get(0).evaluateCreature();
  c.fitness = fitness;
}
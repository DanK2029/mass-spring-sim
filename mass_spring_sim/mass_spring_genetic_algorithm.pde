import java.util.*;

Creature geneticAlgorithm(int populationSize, int numOfGenerations, Creature baseCreature) {
  int winningCreatureIndex = 0;
  float topFitness = 0.0;
  int testTimeSpan = 8000;
  generationCount = 0;
  ArrayList<Creature> population = generateInitialPopulation(populationSize, baseCreature);

  do {
    println("");
    generationCount++;
    population = evaluatePopulation(population, testTimeSpan);
    println("Generation: " + generationCount);
    for (int i = 0; i < population.size(); i++) {
      println("CreatureID: " + population.get(i).id + ", Fitness: " + population.get(i).fitness);
      if (population.get(i).fitness >= topFitness) {
        topFitness = population.get(i).fitness;
        winningCreatureIndex = i;
      }
    }
    writeCreatureFile(population.get(winningCreatureIndex), "GenAlgoCreations/winningCreatures/"+ structureFileName + "/" +generationCount);
    Date genDate = new Date();
    println(genDate);
  } while (generationCount < numOfGenerations);
  
  Creature winningCreature = population.get(winningCreatureIndex);
  //writeCreatureFile(winningCreature, "latestGenAlgoCreation");
  return winningCreature;
}

ArrayList<Creature> generateInitialPopulation(int populationSize, Creature baseCreature) {
  println("initial creation");
  ArrayList<Creature> population = new ArrayList<Creature>();
  population.add(baseCreature);
  for (int i = 0; i < populationSize-1; i++) {
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
  int halfPopulationSize = population.size()/2;
  for (int i = 0; i < halfPopulationSize; i++) {
      population.remove(i);
  }
  
  // each creature in population has a child and mutates it those children are then added to the population
  ArrayList<Creature> newPopulation = new ArrayList<Creature>();
  
  for (int i = 0; i < population.size(); i++) {
    Creature newCreature = population.get(i).copyCreature();
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
  //singleCreatureList.add(c);
  singleCreatureList.add(testCreature);

  for (int i = 0; i < timeSpan; i++) {
    simStep(singleCreatureList);
    time = 0.0;
  }
  float fitness = singleCreatureList.get(0).evaluateCreature();
  println(c.id, fitness);
  c.fitness = fitness;
}

void printPopulationIds(ArrayList<Creature> population) {
  for (int i = 0; i < population.size(); i++) {
    println(population.get(i).id);
  }
}
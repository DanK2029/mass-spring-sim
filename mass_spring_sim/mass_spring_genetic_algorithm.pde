Creature geneticAlgorithm(int populationSize, Creature baseCreature) {
  int winningCreatureIndex = 0;
  float winningThreshold = 500.0;
  float topFitness = 0.0;
  boolean winningCreatureFound = false;
  int generationCount = 0;
  ArrayList<Creature> population = generateInitialPopulation(populationSize, baseCreature);
  do {
    println("loop");
    generationCount++;
    population = evaluatePopulation(population);
    for (int i = 0; i < population.size(); i++) {
      float creatureFitness = population.get(i).evaluateCreature();
      if (creatureFitness > topFitness) {
        topFitness = creatureFitness;
        winningCreatureIndex = i;
      }
      if (creatureFitness > winningThreshold) {
        winningCreatureFound = true;
      }
    }
    println(generationCount+", winning Fitness: "+topFitness);
    println("population size: "+population.size());
  } while (generationCount < 200);//!winningCreatureFound);
  
   
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


ArrayList<Creature> evaluatePopulation(ArrayList<Creature> population) {
  println("evaluate population");
  int initialPopulationSize = population.size();
  ArrayList<Float> fitnessList = new ArrayList<Float>();
  float fitnessSum = 0.0;
  for (int i = 0; i < population.size(); i++) {
    Creature c = population.get(i);
    float creatureFitness = testCreature(c, 20000, "halfStep");
    fitnessList.add(creatureFitness);
    fitnessSum += creatureFitness;
  }
  float fitnessAverage = (float) (fitnessSum / population.size());
  for (int i = 0; i < population.size(); i++) {
    if (population.get(i).evaluateCreature() < fitnessAverage) {
      println("remove 1");
      population.remove(i);
    }
  }
  while (population.size() > initialPopulationSize/2) {
    println("remove 2");    
    population.remove(population.size()-1);
  }

  ArrayList<Creature> newPopulation = new ArrayList<Creature>();
  for (int i = 0; i < population.size(); i++) {
    Creature newCreature = population.get(i);
    newCreature.mutate();
    newPopulation.add(newCreature);
  }
  population.addAll(newPopulation);
  return population;  
}


float testCreature(Creature c, int timeSpan, String integratorType) {
  ArrayList<Creature> singleCreatureList = new ArrayList<Creature>();
  singleCreatureList.add(c);
  if (integratorType == "halfStep") {
    halfStep(timeSpan, tDelta, singleCreatureList);
  } else if (integratorType == "forwardEuler") {
    eulerForward(timeSpan, tDelta, singleCreatureList);
  }
  float fitness = singleCreatureList.get(0).evaluateCreature();
  return fitness;
}
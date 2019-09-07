class Population {
  Navigator[] navigators;
  float fitnessSum;
  int generationCount = 1;
  int bestNavigator = 0;
  int lowestSteps = 500;

  Population(int size) {
    navigators = new Navigator[size];
    for (int i = 0; i < size; i++) {
      navigators[i] = new Navigator();
    }
  }

  void display() {
    for (int i = 0; i < navigators.length; i++) {
      if (visuals.displayBestOnly == false) {
        navigators[i].display();
      }
    }
    navigators[0].display();
  }

  // Called every frame, this method kills all navigators
  // with a highest step than the current lowest. If a
  // navigator is found with a lower step count, then it is
  // updated in the update method in the Navigator() class.
  void update() {
    for (int i = 0; i < navigators.length; i++) {
      // All of the navigators than took more steps than the
      // best navigator are worse. Therefore,they should 
      // be killed.
      if (navigators[i].brain.step > lowestSteps) {
        navigators[i].active = false;
        killCount++;
      } else {
        navigators[i].update();
      }
    }
  }

  // Method for returning whether any navigators are active.
  // The returned boolean is used to determine when the next
  // generation of offspring can be created, which occurs when
  // this method returns true. 
  boolean extinct() {
    for (int i = 0; i < navigators.length; i++) {
      if (navigators[i].active && !navigators[i].solved) {
        return false;
      }
    }
    return true;
  }

  // Method for calling the fitness method of the Navigator() 
  // class on every navigator. This is done to ensure each
  // of the navigators has a measured fitness.
  void fitness() {
    for (int i = 0; i < navigators.length; i++) {
      navigators[i].fitness();
    }
  }

  // Medthod for determining the sum of the fitnesses of every
  // navigator. This is used to determine the upper bounds of
  // the random number used for choosing navigators to reproduce.
  void sumFitness() {
    fitnessSum = 0;
    for (int i = 0; i < navigators.length; i++) {
      fitnessSum += navigators[i].fitness;
    }
  }

  // Method that creates a new generation of navigators from the
  // previous generation. This includes creating an array for the
  // new navigators, finding the most effective navigator of the 
  // previous generation, summing the fitness of all navigators in
  // the previous generation, setting the best navigator of the last
  // generation as the first in the offspring generation, selecting
  // parents for reproduction, and crossing over those parents to form
  // children for the new generation.
  void selection() {
    Navigator[] offspring = new Navigator[navigators.length];
    setBestNavigator();
    sumFitness();
    offspring[0] = navigators[bestNavigator].crossover();
    offspring[0].isBest = true;
    for (int i = 1; i < offspring.length; i++) {
      // A single parent is selected based on fitness, which prevents 
      // unfit parents from worsening the distance to the goal.
      Navigator parent = selectParent();
      // A child is created by copying the desireable genes from the parent
      // and adding mutation to replace the undesireable genes.
      offspring[i] = parent.crossover();
    }
    // The new children objects from an array named offspring. This new array
    // replaces the old generation.
    navigators = offspring.clone();
    generationCount++;
  }

  // Method for deciding which navigators should be reproduced. This
  // is done by using a random number (0-sum of all fitness scores).
  // The randomly chosen number should always be less than the sum of
  // all the fitness scores, so null should never be returned.
  Navigator selectParent() {
    float random = random(fitnessSum);
    float runningSum = 0;
    for (int i = 0; i < navigators.length; i++) {
      runningSum += navigators[i].fitness;
      if (runningSum > random) {
        return navigators[i];
      }
    }
    return null;
  }

  // Method for calling mutate on every one of the navigator children,
  // except for the first position, which is reserved for the most
  // effective navigator of the previous generation. 
  void mutate() {
    for (int i = 1; i < navigators.length; i++) {
      navigators[i].brain.mutate();
    }
  }

  // The most effective navigator of the last generation should
  // be kept, as doing so prevents negative progress. These
  // best navigators should not be mutated, in case mutations
  // worsens the effectiveness. It is "the navigator to beat."
  void setBestNavigator() {
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i < navigators.length; i++) {
      if (navigators[i].fitness > max) {
        max = navigators[i].fitness;
        maxIndex = i;
      }
      bestNavigator = maxIndex;
      if (navigators[bestNavigator].solved) {
        lowestSteps = navigators[bestNavigator].brain.step;
      }
    }
  }
}

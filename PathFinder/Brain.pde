class Brain {
  PVector[] directions;
  int step = 0;
  
  // Creates an array x long of random PVector movements to
  // be performed by each navigator.
  Brain(int size) {
    directions = new PVector[size];
    randomize();
  }
  
  // Fills the list of random PVector movements with a random
  // theta. PVector.fromAngle() allows 
  void randomize() {
    for (int i = 0; i < directions.length; i++) {
      float randomTheta = random(2*PI);
      directions[i] = PVector.fromAngle(randomTheta);
    }
  }
  
  // Creates a new object from Brain() class and copies the 
  // PVector from the same position in the directions array.
  Brain clone() {
    Brain clone = new Brain(directions.length);
    for (int i = 0; i < directions.length; i++) {
      clone.directions[i] = directions[i].copy();
    }
    return clone;
  }
  
  // Method that overwrites random items in the directions
  // array. Mutate is called on all children, which causes
  // changes in how the previous navigator would have moved.
  void mutate() {
    // The chance of a specific direction (angle) being 
    // overwritten by a new direction, where 0.01 is 1% 
    // chance of mutation and therefore replacement.
    float mutationRate = 0.01;
    
    for (int i = 0; i < directions.length; i++) {
      float random = random(1);
      if (random < mutationRate) {
        // If mutation occurs, then the direction it 
        // occurs on is overwritten by a random angle.
        float randomTheta = random(2*PI);
        directions[i] = PVector.fromAngle(randomTheta);
      }
    }
  }
}

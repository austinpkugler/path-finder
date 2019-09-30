class Navigator {
  Brain brain;
  boolean active = true;
  boolean solved = false;
  boolean isBest = false;
  float fitness = 0;
  PVector pos;
  PVector vel;
  PVector acc;

  Navigator() {
    // Passes the initial number of vectors to use. The number passed
    // specifies the length of array directions, which holds random
    // PVector movements.
    brain = new Brain(500);
    pos = new PVector(cfg.startX, cfg.startY);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  // Method for displaying all navigators to the screen.
  // This is done for the user's observation.
  void display() {
    // The current most effective navigator should be 
    // shown in a different color for clarity. In any
    // given generation, this navigator will have the
    // highest fitness from the previously evaluated
    // generation.
    strokeWeight(0);
    if (!isBest && visuals.displayBestOnly == false) {
      fill(140, 140, 140);
      //pushMatrix();
      //rectMode(CENTER);
      //rect(pos.x, pos.y, cfg.diameter, cfg.diameter);
      //popMatrix();
      ellipse(pos.x, pos.y, cfg.diameter, cfg.diameter);
    } else {
      fill(0, 0, 255);
      ellipse(pos.x, pos.y, cfg.diameter + 3, cfg.diameter + 3);
    }
  }

  // Method for moving the navigators PVector positions.
  void move() {
    // If there are still unexplored random directions, then
    // set the acceleration of the navigator to the next
    // element in the directions array. This is done so 
    // the navigator continuously moves at a random angle.
    if (brain.directions.length > brain.step) {
      acc = brain.directions[brain.step];
      brain.step++;
    } else {
      // Kill the navigator if it has no more directions 
      // to follow, as it has reached its highest performance.
      active = false;
      killCount++;
    }
    // Add the acceleration and velocity, while limiting the acceleration to 5.
    vel.add(acc);
    vel.limit(5);
    pos.add(vel);
  }

  // Method for checking whether any navigators have gone offscreen or reached the solution.
  void update() {
    if (active && !solved) {
      move();
      // The navigator should die if it goes offscreen, because 
      // no position offspring can be the solution.
      if (pos.x < (cfg.diameter/2) || pos.y < (cfg.diameter / 2) || pos.x > width - (cfg.diameter / 2) || pos.y > height - (cfg.diameter / 2)) {
        active = false;
        killCount++;
      } else if (dist(pos.x, pos.y, cfg.goal.x, cfg.goal.y) < 5) {
        solved = true;
      }
    }
  }

  // Determines a numerical fitness for every navigator object of
  // the Navigator() class. If any paticular object has already reached
  // the destination, then it begins to use the number of steps performed
  // to effect fitness.
  void fitness() {
    // If the solution is reached, then the navigators
    // should begin to attempt to reach the destination more
    // effectively. Therefore, the steps it took for a navigator
    // to reach the solution should be measured for comparison.
    if (solved) {
      fitness = 1.0 / 16.0 + 10000.0 /(float)(brain.step * brain.step);
    } else {
      float distance = dist(pos.x, pos.y, cfg.goal.x, cfg.goal.y);
      fitness = 1.0 /(distance * distance);
    }
  }

  // Uses data from a single parent to create a child that shares
  // a similiar brain to their parent. This means the child inherits
  // most of the directions the parent traveled.
  Navigator crossover() {
    Navigator child = new Navigator();
    child.brain = brain.clone();
    return child;
  }
}

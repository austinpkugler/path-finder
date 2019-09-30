class Visuals {

  // All visual assets are assigned a datatype.
  // Visual assets include fonts, images, and user
  // preferences.
  PFont sourceCodePro;
  PFont courier;
  PImage menuImg;
  PImage aboutImg;
  PImage launchedImg;
  PImage settingsImg;
  PImage editImg;
  String status = "menu";
  boolean displayData = true;
  boolean displayBestOnly = false;
  boolean paused = true;
  float sumOfFrameRates;
  float avgFrameRate;

  // Load all visual assets, such as fonts and images.
  void loadVisualAssets() {
    sourceCodePro = loadFont("assets/fonts/SourceCodePro-Black-48.vlw");
    courier = loadFont("assets/fonts/CourierNewPSMT-48.vlw");
    menuImg = loadImage("assets/img/main_menu.png");
    aboutImg = loadImage("assets/img/about.png");
    launchedImg = loadImage("assets/img/launched.png");
    settingsImg = loadImage("assets/img/settings.png");
    editImg = loadImage("assets/img/edit.png");
  }

  // Display the relevant images and text for each possible visual stage.
  void display() {
    switch(status) {
    case "launched":
      background(0);
      displayNavigators();
      image(launchedImg, 0, 0, width, height);
      displayDebug();
      break;
    case "edit":
      background(0);
      displayNavigators();
      image(launchedImg, 0, 0, width, height);
      image(editImg, 0, 0, width, height);
      displayDebug();
      break;
    case "menu":
      image(menuImg, 0, 0, width, height);
      break;
    case "settings":
      image(settingsImg, 0, 0, width, height);
      strokeWeight(5);
      stroke(112, 48, 160);
      if (cfg.playAudio) {
        line(0.55 * width, 0.38 * height, 0.57 * width, 0.38 * height);
      } else {
        line(0.65 * width, 0.38 * height, 0.67 * width, 0.38 * height);
      }
      if (cfg.fps == 60) {
        line(0.55 * width, 0.68 * height, 0.57 * width, 0.68 * height);
      } else {
        line(0.65 * width, 0.68 * height, 0.67 * width, 0.68 * height);
      }
      break;
    case "about":
      image(aboutImg, 0, 0, width, height);
      break;
    }
  }

  // Method for the display of all navigators who are currently alive.
  void displayNavigators() {
    stroke(0);
    fill(0, 255, 0);
    ellipse(cfg.startX, cfg.startY, cfg.diameter + 3, cfg.diameter + 3);
    fill(255, 0, 0);
    ellipse(cfg.goal.x, cfg.goal.y, cfg.diameter + 3, cfg.diameter + 3);
    // If all of the navigators are not active, then they can no longer move.
    // Therefore, the genetic algorithm can now evaluate the inactive navigators 
    // to determine the next generation.
    if (population.extinct()) {
      if (!paused) {
        population.fitness();
        population.selection();
        population.mutate();
      }
    } else {
      if (!paused) {
        population.update();
      }
      population.display();
    }
  }

  void displayDebug() {
    // If the user has set display data as a preferences, then
    // display all debug values.
    sumOfFrameRates += frameRate;
    avgFrameRate = sumOfFrameRates / frameCount;
    float runtime = frameCount /(avgFrameRate * 60);
    if (displayData) {
      stroke(0);
      fill(255);
      textAlign(LEFT);
      textFont(courier, 16);
      text("Generation: " + population.generationCount, 5, 10);
      text("Child Count: " + cfg.childCount, 5, 25);
      text("Children Killed: " + killCount, 5, 40);
      text("Least Steps: " + population.lowestSteps, 5, 55);
      text("FPS: " + int(frameRate), 5, 70);
      text("Diameter: " + cfg.diameter, 5, 85);
      text("Runtime: " + int(runtime) + "m", 5, 100);
      text("Mutation Rate: " + (cfg.mutationRate * 100) + '%', 5, 115);
      text("Mode: " + status, 5, 130);
      text("'m' | view main menu\n'd' | toggle debug mode\n'b' | toggle best only", 5, height * 0.95);
    }
  }
}

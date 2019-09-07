// Going into settings and changing nothing while in-game will reset the generation to 0.


import processing.sound.*;

SoundFile click;
Visuals visuals;
Config cfg;
Population population;
int killCount = 0;

void setup() {
  fullScreen(P2D);
  //size(1000, 600, P2D);
  frameRate(144);
  visuals = new Visuals();
  visuals.loadVisualAssets();
  cfg = new Config();
  cfg.loadConfig();
  population = new Population(cfg.childCount);
  click = new SoundFile(this, "assets/audio/click.wav");
}

void resetFps() {
  frameRate(cfg.fps);
}

void draw() {
  visuals.display();
}

void keyPressed() {
  if (visuals.status == "launched" || visuals.status == "edit") {
    switch(key) {
    case 'd':
      visuals.displayData = !visuals.displayData;
      break;
    case 'b':
      if (population.generationCount > 1) {
        visuals.displayBestOnly = !visuals.displayBestOnly;
      }
      break;
    case ESC:
      key = 0;
      visuals.paused = true;
      visuals.status = "menu";
      break;
    case 'm':
      visuals.paused = true;
      visuals.status = "menu";
      break;
    case ' ':
      visuals.paused = !visuals.paused;
      break;
    case 'e':
      if (visuals.status != "edit") {
        visuals.paused = true;
        visuals.status = "edit";
      } else {
        visuals.status = "launched";
      }
    }
  } else {
    key = 0;
  }
}

void mousePressed() {
  PVector clicked = new PVector(mouseX, mouseY);
  if (mouseButton == LEFT) {
    if (cfg.playAudio && visuals.status != "launched") {
      click.play();
    }
    switch(visuals.status) {
    case "menu":
      if (clicked.x > 0.3 * width && clicked.x < 0.7 * width) {
        if (clicked.y > 0.3 * height && clicked.y < 0.4 * height) {
          resetFps();
          visuals.status = "launched";
        } else if (clicked.y > 0.4 * height && clicked.y < 0.5 * height) {
          visuals.status = "settings";
        } else if (clicked.y > 0.5 * height && clicked.y < 0.6 * height) {
          visuals.status = "about";
        } else if (clicked.y > 0.6 * height && clicked.y < 0.7 * height) {
          cfg.saveConfig();
          exit();
        }
      }
      break;
    case "launched":
      if (clicked.y > 0 && clicked.y < 0.1 * height) {
        if (clicked.x > 0.85 * width && clicked.x < 0.9 * width) {
          visuals.paused = true;
          visuals.status = "edit";
        } else if (clicked.x > 0.9 * width && clicked.x < 0.95 * width) {
          visuals.paused = false;
        } else if (clicked.x > 0.95 * width && clicked.x < width) {
          visuals.paused = true;
        }
      }
      break;
    case "edit":
      if (clicked.y > 0 && clicked.y < 0.1 * height) {
        if (clicked.x > 0.85 * width && clicked.x < 0.9 * width) {
          visuals.status = "launched";
        } else if (clicked.x > 0.9 * width && clicked.x < 0.95 * width) {
          visuals.paused = false;
        } else if (clicked.x > 0.95 * width && clicked.x < width) {
          visuals.paused = true;
        }
      }
      break;
    case "about":
      if (clicked.x > 0.3 * width && clicked.x < 0.7 * width) {
        if (clicked.y > 0.7 * height && clicked.y < 0.8 * height) {
          visuals.status = "menu";
        }
      }
      break;
    case "settings":
      if (clicked.x > 0.3 * width && clicked.x < 0.7 * width && clicked.y > 0.7 * height && clicked.y < 0.8 * height) {
        cfg.saveConfig();
        resetLearning();
        resetFps();
        visuals.status = "menu";
      } else if (clicked.x > 0.5 * width && clicked.x < 0.6 * width) {
        if (clicked.y > 0.3 * height && clicked.y < 0.4 * height) {
          click.play();
          cfg.playAudio = true;
        } else if (clicked.y > 0.4 * height && clicked.y < 0.5 * height) {
          cfg.childCount += 25;
        } else if (clicked.y > 0.5 * height && clicked.y < 0.6 * height) {
          cfg.diameter += 4;
        } else if (clicked.y > 0.6 * height && clicked.y < 0.7 * height) {
          cfg.fps = 60;
          resetFps();
        }
      } else if (clicked.x > 0.6 * width && clicked.x < 0.7 * width) {
        if (clicked.y > 0.3 * height && clicked.y < 0.4 * height) {
          cfg.playAudio = false;
        } else if (clicked.y > 0.4 * height && clicked.y < 0.5 * height) {
          cfg.childCount -= 25;
        } else if (clicked.y > 0.5 * height && clicked.y < 0.6 * height) {
          if (cfg.diameter > 13) {
            cfg.diameter -= 4;
          }
        } else if (clicked.y > 0.6 * height && clicked.y < 0.7 * height) {
          cfg.fps = 120;
          resetFps();
        }
      }
      break;
    }
  }
}

// If the user changes the number of children in each generation, 
// then the learning must start over again from generation 1.
void resetLearning() {
  population = new Population(cfg.childCount);
}

/*
  TODO:
 - In editing mode:
 > Add ability to add stagnant walls.
 > Add ability to add moving walls.
 > Add ability to randomize walls.
 > Add ability to delete stagnant and 
 moving walls.
 - In launched mode:
 > Check for collision between any navigators
 and walls; kill the navigators if they
 collide with a wall.
 */

// The Processing sound library is used for UI sound effects.
// It should be noted that .isPlaying() appears to be deprecated. 
import processing.sound.*;

SoundFile click;
Visuals visuals;
Config cfg;
Population population;
int killCount = 0;

void setup() {
  //fullScreen(P2D);
  size(1500, 860, P2D);
  frameRate(144);
  visuals = new Visuals();
  visuals.loadVisualAssets();
  cfg = new Config();
  cfg.loadConfig();
  population = new Population(cfg.childCount);
  click = new SoundFile(this, "assets/audio/click.wav");
}

// Used to initial lower the frameRate from the starting 144.
// This was done to allow the user to select a frameRate up
// to 144, as Processing does not allow the frameRate to reach
// any higher than what it was first initialized as.
void resetFps() {
  frameRate(cfg.fps);
}

// Displays all visual elements at the frameRate. The
// draw() function is called frameRate times per second.
void draw() {
  visuals.display();
}

// Key mapping for all possible states of the application.
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

// Mouse mapping for all possible states of the application.
String editStatus = "none";
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
      if (editStatus == "none") {
        if (clicked.y > 0 && clicked.y < 0.1 * height) {
          if (clicked.x > 0.85 * width && clicked.x < 0.9 * width) {
            visuals.status = "launched";
          } else if (clicked.x > 0.9 * width && clicked.x < 0.95 * width) {
            visuals.paused = false;
          } else if (clicked.x > 0.95 * width && clicked.x < width) {
            visuals.paused = true;
          }
        }
        if (clicked.x > 0 && clicked.x < 0.1 * width) {
          if (clicked.y > 0.2 * height && clicked.y < 0.3 * height) {
            editStatus = "selectingStart";
          } else if (clicked.y > 0.3 * height && clicked.y < 0.4 * height) {
            editStatus = "selectingEnd";
          } else if (clicked.y > 0.4 * height && clicked.y < 0.5 * height) {
            editStatus = "placingWall";
          } else if (clicked.y > 0.5 * height && clicked.y < 0.6 * height) {
            editStatus = "placingMovingWall";
          } else if (clicked.y > 0.6 * height && clicked.y < 0.7 * height) {
            editStatus = "randomizing";
          } else if (clicked.y > 0.7 * height && clicked.y < 0.8 * height) {
            editStatus = "deleting";
          }
        }
      } else {
        switch(editStatus) {
        case "selectingStart":
          cfg.startX = clicked.x;
          cfg.startY = clicked.y;
          editStatus = "none";
          resetLearning();
          break;
        case "selectingEnd":
          cfg.goal.x = clicked.x;
          cfg.goal.y = clicked.y;
          editStatus = "none";
          resetLearning();
          break;
        case "placingWall":
          // BLANK
          break;
        case "placingMovingWall":
          // BLANK
          break;
        case "randomizing":
          // BLANK
          break;
        case "deleting":
          // BLANK
          break;
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
        resetFps();
        visuals.status = "menu";
      } else if (clicked.x > 0.5 * width && clicked.x < 0.6 * width) {
        if (clicked.y > 0.3 * height && clicked.y < 0.4 * height) {
          click.play();
          cfg.playAudio = true;
        } else if (clicked.y > 0.4 * height && clicked.y < 0.5 * height) {
          cfg.childCount += 25;
          resetLearning();
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
  killCount = 0;
}

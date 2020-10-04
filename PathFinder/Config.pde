class Config {

  String[] savedConfig;
  boolean playAudio;
  PVector goal;
  float startX;
  float startY;
  float mutationRate;
  int diameter;
  int childCount;
  int fps;

  // Loags all config variables from an external text file.
  // This will likely be replaced with a CSV file later.
  void loadConfig() {
    savedConfig = loadStrings("assets/data/config.txt");
    playAudio = boolean(savedConfig[0]);
    childCount = int(savedConfig[1]);
    diameter = int(savedConfig[2]);
    fps = int(savedConfig[3]);
    mutationRate = float(savedConfig[4]);
    startX = width / 2;
    startY = height / 2;
    goal = new PVector(width / 2, diameter + 10);
  }

  // Overwrites the config text file with new values.
  // Only called when the user has changed at least one value.
  void saveConfig() {
    PrintWriter newSave = createWriter("assets/data/config.txt");
    newSave.println(playAudio);
    newSave.println(childCount);
    newSave.println(diameter);
    newSave.println(fps);
    newSave.println(mutationRate);
    newSave.flush();
    newSave.close();
  }
}

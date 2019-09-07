class Config {

  String[] savedConfig;
  boolean playAudio;
  PVector goal;
  int startX;
  int startY;
  int diameter;
  int childCount;
  int fps;
  
  void loadConfig() {
    savedConfig = loadStrings("assets/data/config.txt");
    playAudio = boolean(savedConfig[0]);
    childCount = int(savedConfig[1]);
    diameter = int(savedConfig[2]);
    fps = int(savedConfig[3]);
    startX = width / 2;
    startY = height / 2;
    goal = new PVector(width / 2, diameter + 10);
  }
  
  void saveConfig() {
    PrintWriter newSave = createWriter("assets/data/config.txt");
    newSave.println(playAudio);
    newSave.println(childCount);
    newSave.println(diameter);
    newSave.println(fps);
    newSave.flush();
    newSave.close();
  }
}

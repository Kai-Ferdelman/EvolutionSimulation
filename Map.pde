class Map {
  int mapSize;
  int size;
  String[] stringSizes = {"small", "medium", "large", "giant"};
  int[] intSizes = {50, 150, 500, 1000};
  int rowCounter = 0;
  int collumnCounter;
  int tileUpdateNumber = 500;

  Tile[][] tiles;

  Map(int initSize) {
    mapSize = initSize;
    size = intSizes[initSize];
    tiles = new Tile[intSizes[mapSize]][intSizes[mapSize]];
    initializeTiles();
  }

  void initializeTiles() {
    int randomOffsetX = int(random(500));
    int randomOffsetY = int(random(500));
    for (int i = 0; i < size; i++) {
      for (int o = 0; o < size; o++) {
        tiles[i][o] = new Tile(i, o, randomOffsetX, randomOffsetY);
      }
    }
  }

  void calc() {
  }

  void updateTiles() {
    //standard updating 
    for (int i = 0; i < size; i++) {
      for (int o = 0; o < size; o++) {
        if (!paused) {
          tiles[i][o].timeOutCounter++;
          tiles[i][o].updated = false;
        }
        tiles[i][o].drawTile();
      }
    }

    int temp = collumnCounter + tileUpdateNumber;
    for (int i = collumnCounter; i < temp; i++) {
      if (i < tiles[rowCounter].length) {
        tiles[rowCounter][i].update();
      } else
        break;
    }
    collumnCounter += tileUpdateNumber;
    if (collumnCounter >= size) {
      collumnCounter = 0;
      rowCounter++;
      if (rowCounter >= size)
        rowCounter = 0;
    }

    updateSpecificTile(mouseX, mouseY, true);
  }

  void updateSpecificTile(int inputX, int inputY, boolean mouse) {
    if (mouse) {
      int x = int(inputX/(zoom+1)-offsetX/(zoom+1));
      int y = int(inputY/(zoom+1)-offsetY/(zoom+1));
      try {
        if (!paused) {
          tiles[x][y].update();
        }
        tiles[x][y].underMouse();
      }
      catch(Exception e) {
      }
    }
  }
}
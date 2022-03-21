class UI {

  boolean showMapGrid = false;

  UI() {
  }

  void run() {
    drawUI();
  }

  void drawUI() {
    rectMode(CORNER);
    if (showMapGrid)
      showMapGrid();
    textAlign(LEFT);
    noStroke();
    fill(0);
    rect(height, 0, width-height, height);
    noStroke();
    fill(255);
    rect(height, 0, 5, height);
    textSize(50);
    rect(height, 50, width-height, 5);
    text("Creature Information", height+10, 50);
    rect(height, height/3*2, width-height, 5);
    text("Tile Information", height+10, height/3*2);
    rect(height+420,height/3*2, 5, height/3);
    text("Shortcuts", height+430, height/3*2);
    showCreatureInfo();
    showTileInfo();
    showSettings();
  }

  void showCreatureInfo(){
    Herbivore h = herbs.get(selectedCreature);
    pushMatrix();
    translate(height+10, 80);
    textSize(30);
    text("Creature ID: #"+h.creatureID, 0, 0);
    text("Creature Array Number: "+h.creatureNum, 300, 0);
    text("Name: "+h.name, 0, 40);
    text("Position (X/Y): "+int(h.pos.x)+"/"+int(h.pos.y), 0, 80);
    text("Eye 1 (X/Y): "+int(h.eye1.x*10)+"/"+int(h.eye1.y*10), 0, 120);
    text("Eye 2 (X/Y): "+int(h.eye2.x*10)+"/"+int(h.eye2.y*10), 0, 160);
    text("Rotation (deg): "+int((h.rotation/PI)*180), 0, 200);
    text("Movement Speed: "+int(h.speed*100), 0, 240);
    text("Moving: "+h.moving, 350, 240);
    text("Rotational Speed: "+int(h.rotationSpeed*100), 0, 280);
    text("Turning: "+h.turning, 350, 280);
    text("Eating: "+h.eating, 0, 320);
    text("Eating Speed: "+int(h.eatingSpeed*100), 350, 320);
    text("Fullness: "+h.fullness*100, 0, 360);
    popMatrix();
  }

  void showTileInfo() {
    int x = 0;
    int y = 0;
    Tile selectedTile = new Tile(-1, -1, 0, 0);
    try {
      x = int(mouseX/(zoom+1)-offsetX/(zoom+1));
      y = int(mouseY/(zoom+1)-offsetY/(zoom+1));
      selectedTile = map.tiles[x][y];
    }
    catch(Exception e) {
    }
    pushMatrix();
    translate(height+10, height/3*2);
    textSize(30);
    if (x > map.size-1 || y > map.size-1)
      text("Tile Position (X/Y): \n     Out of Bounds!", 0, 40);
    else {
      text("Tile Position (X/Y): "+x+"/"+y, 0, 40);
      text("Is Land: "+!selectedTile.water+" ("+int(seaLevel*100)+")", 0, 80);
      text("Noise Value: "+int(selectedTile.noise*100), 0, 120);
      text("Food Value: "+int(selectedTile.food*100), 0, 160);
      if (selectedTile.zone == 0)
        text("Zone: not assigned", 0, 200);
      else
        text("Zone: "+selectedTile.zone, 0, 200);
    }
    popMatrix();
  }
  
  void showSettings(){
    pushMatrix();
    translate(height+430, height/3*2);
    textSize(30);
    fill(255);
    text("Next Creature: 'n'", 0, 40);
    fill(255);
    text("Previous Creature: 'b'", 0, 80);
    fill(255);
    if(showMapGrid) fill(#38C127);
    text("Show Map Grid: 'g'", 0, 120);
    fill(255);
    text("Move Map: 'w' 'a' 's' 'd'", 0, 160);
    fill(255);
    text("Reset Map: 'r'",0, 200);
    fill(255);
    if(showFullCreature) fill(#38C127);
    text("Hide Creature Extras: 'h'",0, 240);
    fill(255);
    if(moveCreature) fill(#38C127);
    text("Move Creature: 'm' ", 0, 280);
    fill(255);
    text("Force feed: 'f'", 0, 320);
    fill(255);
    if(showNeuralNet) fill(#38C127);
    text("Toggle Neural Net: 'shift'", 0, 360);
    popMatrix();
  }

  void showMapGrid() {
    strokeWeight(1);
    stroke(0);
    line(map.size*(zoom+1)/4+offsetX, 0+offsetY, map.size*(zoom+1)/4+offsetX, map.size*(zoom+1)+offsetY);
    line(map.size*(zoom+1)/4*3+offsetX, 0+offsetY, map.size*(zoom+1)/4*3+offsetX, map.size*(zoom+1)+offsetY);
    line(0+offsetX, map.size*(zoom+1)/4+offsetY, map.size*(zoom+1)+offsetX, map.size*(zoom+1)/4+offsetY);
    line(0+offsetX, map.size*(zoom+1)/4*3+offsetY, map.size*(zoom+1)+offsetX, map.size*(zoom+1)/4*3+offsetY);
    stroke(255);
    line(map.size*(zoom+1)/2+offsetX, 0+offsetY, map.size*(zoom+1)/2+offsetX, map.size*(zoom+1)+offsetY);
    line(0+offsetX, map.size*(zoom+1)/2+offsetY, map.size*(zoom+1)+offsetX, map.size*(zoom+1)/2+offsetY);
  }
}
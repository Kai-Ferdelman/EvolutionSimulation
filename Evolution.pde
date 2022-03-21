Map map;
UI ui;
int offsetX, offsetY;
int creatureIdCounter = 0;
int prevMouseX, prevMouseY;
int zoom = 0;
int globalMapSize = 1;
float regrowRate = 0.005;
int selectedCreature = 0;
int minHerbs = 50;
ArrayList<Herbivore> herbs = new ArrayList<Herbivore>();
boolean showFullCreature = false;
boolean paused = false;
boolean moveCreature = false;
boolean showNeuralNet = false;
float seaLevel = 0.25;
VisualNeuralNet visualNeuralNet;

void setup() {
  noCursor();
  fullScreen();
  frameRate(30);
  map = new Map(globalMapSize);
  ui = new UI();
  for (int i = 0; i < minHerbs; i++) {
    Herbivore h = new Herbivore(i, creatureIdCounter, "");
    herbs.add(h);
  }
  visualNeuralNet = new VisualNeuralNet();
}

void draw() {
  background(#AAAAAA);
  map.updateTiles();
  fill(0);
  rect(height, 0, width-height, height);
  int herbLength = herbs.size();
  for (int i = 0; i < herbLength; i++) {
    herbs.get(i).run();
    if (herbs.get(i).fullness > 50 && herbs.size() < 600) {
      procriate(herbs.get(i));
    }
  }
  if (showNeuralNet) {
    visualNeuralNet.run(herbs.get(selectedCreature).neurons);
  } else {
    ui.run();
  }
  drawCursor();
  for (int i = 0; i < herbs.size(); i++) {
    if (herbs.get(i).fullness < 0) {
      deleteHerbivore(i);
      i--;
    }
  }
  if (paused) {
    rectMode(CORNER);
    fill(255, 100);
    noStroke();
    rect(height/4, height/4, height/5, height/2);
    rect(height-height/4, height/4, -height/5, height/2);
  }
}


void drawCursor() {
  fill(0, 0);
  stroke(255);
  PVector pointer = new PVector((mouseX-offsetX)/(zoom+1), (mouseY-offsetY)/(zoom+1));
  PVector direction = PVector.sub(herbs.get(selectedCreature).pos, pointer);
  direction.normalize();
  direction.mult(10);
  strokeWeight(3);
  line(mouseX, mouseY, mouseX+direction.x, mouseY+direction.y);
  strokeWeight(1);
  ellipse(mouseX, mouseY, 10, 10);
}

void procriate(Herbivore h) {
  for (int i = 0; i < 1; i++) {
    Herbivore newHerb = h.copyHerbivore(herbs.size(), creatureIdCounter);
    for (int o = 0; o < 3; o++) {
      int randomInt = int(random(0, newHerb.neuronCount));
      newHerb.neurons[randomInt] = new Neuron(int(random(5)+2), newHerb.neuronCount, newHerb.inputVariables, newHerb.creatureNum, randomInt);
    }
    herbs.add(newHerb);
  }
  h.fullness -= 30;
}

void deleteHerbivore(int _creatureNum) {
  for (Herbivore h : herbs) {
    if (h.creatureNum > _creatureNum) {
      h.creatureNum--;
    }
  }
  if (_creatureNum < selectedCreature) {
    selectedCreature--;
  }
  herbs.remove(_creatureNum);
  if (herbs.size() < minHerbs) {
    Herbivore newH = new Herbivore(minHerbs-1, creatureIdCounter, "");
    herbs.add(newH);
  }
}

void mousePressed() {
  prevMouseX = mouseX;
  prevMouseY = mouseY;

  if (mouseButton == LEFT) {
    PVector pointer = new PVector((mouseX-offsetX)/(zoom+1), (mouseY-offsetY)/(zoom+1));
    float largestDistance = 3;
    for (Herbivore h : herbs) {
      float distance = PVector.dist(pointer, h.pos);
      if (distance < largestDistance) {
        selectedCreature = h.creatureNum;
        largestDistance = distance;
      }
    }

    if (showNeuralNet) {
      for (int i = 0; i < herbs.get(selectedCreature).neurons.length; i++) {
        herbs.get(selectedCreature).neurons[i].selected = false;
      }
      for (int i = 0; i < herbs.get(selectedCreature).neurons.length; i++) {
        if (dist(mouseX, mouseY, herbs.get(selectedCreature).neurons[i].pos.x, herbs.get(selectedCreature).neurons[i].pos.y) < 20) {
          herbs.get(selectedCreature).neurons[i].selected = true;
        }
      }
    }
  }
}

void mouseDragged() {
  if (mouseButton == RIGHT) {
    offsetX += mouseX - prevMouseX;
    offsetY += mouseY - prevMouseY;

    if (offsetX < height-(map.size*(1+zoom))) {
      offsetX = height-(map.size*(1+zoom));
    }
    if (offsetY < height-(map.size*(1+zoom))) {
      offsetY = height-(map.size*(1+zoom));
    }
    if (offsetX > 0) {
      offsetX = 0;
    }
    if (offsetY > 0) {
      offsetY = 0;
    }
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }

  if (mouseButton == LEFT && moveCreature) {
    PVector pointer = new PVector((mouseX-offsetX)/(zoom+1), (mouseY-offsetY)/(zoom+1));
    float largestDistance = 3;
    float distance = PVector.dist(pointer, herbs.get(selectedCreature).pos);
    if (distance < largestDistance) {
      herbs.get(selectedCreature).pos = pointer;
    }

    if (showNeuralNet) {
      for (int i = 0; i < herbs.get(selectedCreature).neurons.length; i++) {
        herbs.get(selectedCreature).neurons[i].selected = false;
      }
      for (int i = 0; i < herbs.get(selectedCreature).neurons.length; i++) {
        if (dist(mouseX, mouseY, herbs.get(selectedCreature).neurons[i].pos.x, herbs.get(selectedCreature).neurons[i].pos.y) < 20) {
          herbs.get(selectedCreature).neurons[i].pos = new PVector(mouseX, mouseY);
          herbs.get(selectedCreature).neurons[i].selected = true;
          break;
        }
      }
    }
  }
}

void mouseWheel(MouseEvent e) {
  if (mouseX < map.size*(1+zoom) && mouseY < map.size*(1+zoom)) {
    zoom += e.getCount();
    try {
      offsetX -= map.size/2*e.getCount();
      offsetY -= map.size/2*e.getCount();
    }
    catch(Exception ex) {
    }

    if (zoom < 0) {
      zoom = 0;
    }
    if (offsetX < height-(map.size*(1+zoom))) {
      offsetX = height-(map.size*(1+zoom));
    }
    if (offsetY < height-(map.size*(1+zoom))) {
      offsetY = height-(map.size*(1+zoom));
    }
    if (offsetX > 0) {
      offsetX = 0;
    }
    if (offsetY > 0) {
      offsetY = 0;
    }
  }
}

void keyPressed(KeyEvent e) {
  if (key == 'w') {
    offsetY+=10*zoom;
  } 
  if (key == 's') {
    offsetY-=10*zoom;
  }
  if (key == 'a') {
    offsetX+=10*zoom;
  }
  if (key == 'd') {
    offsetX-=10*zoom;
  }
  if (offsetX < height-(map.size*(1+zoom))) {
    offsetX = height-(map.size*(1+zoom));
  }
  if (offsetY < height-(map.size*(1+zoom))) {
    offsetY = height-(map.size*(1+zoom));
  }
  if (offsetX > 0) {
    offsetX = 0;
  }
  if (offsetY > 0) {
    offsetY = 0;
  }

  if (key == 'g') {
    ui.showMapGrid = !ui.showMapGrid;
  }
  if (key == 'r') {
    map.initializeTiles();
  }
  if (key =='n') {
    selectedCreature++;
  }
  if (key == 'b') {
    selectedCreature--;
  }
  if (selectedCreature < 0) {
    selectedCreature = herbs.size()-1;
  }
  if (selectedCreature > herbs.size()-1) {
    selectedCreature = 0;
  }
  if (key == 'p') {
    paused = !paused;
  }
  if (key == 'h') {
    showFullCreature = !showFullCreature;
  }
  if (key == 'q') {
    deleteHerbivore(selectedCreature);
  }
  if (key == 'm') {
    moveCreature = !moveCreature;
  }
  if (key == 'f') {
    herbs.get(selectedCreature).fullness++;
  }
  if (keyCode == SHIFT) {
    showNeuralNet = !showNeuralNet;
    if (showNeuralNet) paused = true;
  }
  if (key == 'v') {
    visualNeuralNet.showValues = ! visualNeuralNet.showValues;
  }
  if (key == 'i') {
    visualNeuralNet.showIO = ! visualNeuralNet.showIO;
  }
  if(key == '+'){
    seaLevel+=0.01;
    println(seaLevel);
  }
  if(key == '-'){
    seaLevel-=0.01;
    println(seaLevel);
  }
}

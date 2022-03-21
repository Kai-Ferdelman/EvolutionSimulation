class CreaturesSuper {
  float speed, rotation, rotationSpeed, eatingSpeed;
  boolean moving, eating, attacking, hurting, turning;
  int neuronCount = 15;
  int creatureType; //0 = herbivore; 1 = carnivore; 2 = omnivore;
  int influenceRadius = 10;
  int creatureID;
  int creatureNum;
  boolean creatureSelected = false;
  PVector pos = new PVector();
  PVector eye1;
  PVector eye2;
  float fullness = 20;
  int[] outputNeurons;
  String name;

  Neuron neurons[] = new Neuron[neuronCount];

  CreaturesSuper() {
    pos.x = random(map.size);
    pos.y = random(map.size);
    eye1 = new PVector(random(-1.5, 1.5), random(-1.5, 1.5));
    eye2 = new PVector(random(-1.5, 1.5), random(-1.5, 1.5));
  }

  void run() {
    drawCreature();
    if (creatureNum == selectedCreature) {
      creatureSelected = true;
    } else {
      creatureSelected = false;
    }
    hurting = false;
  }

  void drawCreature() {
    pushMatrix();
    translate(pos.x*(1+zoom)+offsetX, pos.y*(1+zoom)+offsetY);
    rotate(rotation);
    //draw influenze sphere
    if (showFullCreature || creatureSelected) {
      noStroke();
      switch(creatureType) {
      case 0: 
        fill(0, 255, 0, 100);
        break;
      case 1: 
        fill(255, 0, 0, 100);
        break;
      case 2: 
        fill(0, 0, 255, 100);
      }
        ellipse(0, 0, influenceRadius*(zoom+1), influenceRadius*(zoom+1));
    }
    switch(creatureType) {
    case 0: 
      fill(#00FF00);
      break;
    case 1: 
      fill(#FF0000);
      break;
    case 2: 
      fill(#0000FF);
    }
    stroke(0);
    strokeWeight(1);
    if (creatureSelected)
      strokeWeight(3);
    PShape creature = createShape(QUAD, 0, 0, -5, -5, 10, 0, -5, 5);
    //draw creature at different sizes
    if (creatureSelected && showFullCreature) {
      if ((zoom+1)/5 < 1) {
        creature.scale(1);
      } else {
        creature.scale((zoom+1)/5);
      }
    } else {
      if ((zoom+1)/15 < 0.5) {
        creature.scale(0.5);
      } else {
        creature.scale((zoom+1)/15);
      }
    }
    shape(creature, 0, 0);
    //draw Eyes
    if (showFullCreature || creatureSelected) {
      stroke(255);
      fill(0, 0);
      ellipse(eye1.x*(1+zoom), eye1.y*(1+zoom), 10, 10);
      ellipse(eye2.x*(1+zoom), eye2.y*(1+zoom), 10, 10);
      line(eye1.x*(1+zoom), eye1.y*(1+zoom), 0, 0);
      line(eye2.x*(1+zoom), eye2.y*(1+zoom), 0, 0);
    }
    popMatrix();
  }
}

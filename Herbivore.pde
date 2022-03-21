class Herbivore extends CreaturesSuper {

  int inputVariables = 20; //num of variables that can be used as input other than neurons
  //visionDownType; visionDownAmount; visionFrontType; visionFrontValue;
  int numOfOutputs = 7;

  Herbivore(int _creatureNum, int initID, String initName) {
    creatureType = 1;
    creatureNum = _creatureNum;
    creatureID = initID;
    creatureIdCounter++;
    eatingSpeed = 0;
    rotation = random(0, TWO_PI);
    name = initName;
    name += ".";
    name += creatureID;
    for (int i = 0; i < neurons.length; i++) {
      neurons[i] = new Neuron(int(random(5)+2), neuronCount, inputVariables, creatureNum, i);
    }
    outputNeurons = new int[numOfOutputs];
    for (int i = 0; i < numOfOutputs; i++) {
      outputNeurons[i] = int(random(neurons.length));
      for (int o = 0; o < i; o++) {
        if (outputNeurons[i] == outputNeurons[o]) {
          i--;
          break;
        }
      }
    }
  }

  void run() {
    super.run();
    if (!paused) {
      for (int i = 0; i < neurons.length; i++) {
        neurons[i].calc();
      }
      manageOutputs();
    }
  }

  float getInput(int input) {
    switch(input) {
    case -1: 
      return pos.x;
    case -2: 
      return pos.y;
    case -3: 
      return rotation;
    case -4: //under creature
      if (getTile(pos).water == true)
        return 0;
      else
        return 1;
    case -5: 
      return getTile(pos).food;
    case -6: // eye 1
      if (getTile(eye1).water == true)
        return 0;
      else
        return 1;
    case -7:
      return getTile(eye1).food;
    case -8: // eye 2
      if (getTile(eye2).water == true)
        return 0;
      else
        return 1;
    case -9: 
      return getTile(eye2).food;
    case -10:
      if (hurting == true)
        return 1;
      else
        return 0;
    case -11:
      return getHeardSize();
    case -12:
      return getHeardHurting();
    case -13: 
      return getNearbyHostile();
    case -14: 
      return fullness;
    case -15: 
      return -1;
    case -16:
      return 0;
    case -17:
      return getFriendlyPos().x;
    case -18:
      return getFriendlyPos().y;
    case -19:
      return getHostilePos().x;
    case -20:
      return getHostilePos().y;
    }
    if (input >= 0) {
      return neurons[input].outputValue;
    }
    return 0;
  }

  Tile getTile(PVector viewPos) {
    Tile tile = new Tile(-1, -1, 0, 0);
    try{
    tile = map.tiles[int(viewPos.x)][int(viewPos.y)];
    }catch(Exception e){}
    return tile;
  }

  int getHeardSize() {
    int heardSize = 0;
    for (Herbivore h : herbs) {
      if (h.creatureID != this.creatureID) {
        float dist = PVector.dist(h.pos, this.pos);
        if (dist < 5)
          heardSize++;
      }
    }
    return heardSize;
  }

  int getHeardHurting() {
    int hurtingHeard = 0;
    for (Herbivore h : herbs) {
      if (h.creatureID != this.creatureID) {
        float dist = PVector.dist(h.pos, this.pos);
        if (dist < 5) {
          if (h.hurting) {
            hurtingHeard++;
          }
        }
      }
    }
    return hurtingHeard;
  }

  int getNearbyHostile() {
    return 0;
  }

  PVector getFriendlyPos() {
    float smallestDist = 5;
    PVector friendlyPos = new PVector();
    for (Herbivore h : herbs) {
      if (h.creatureID != this.creatureID) {
        float dist = PVector.dist(h.pos, this.pos);
        if (dist < smallestDist) {
          smallestDist = dist;
          friendlyPos = h.pos;
        }
      }
    }
    return friendlyPos;
  }

  PVector getHostilePos() {
    PVector hostilePos = new PVector(0, 0);

    return hostilePos;
  }

  void manageOutputs() {
    //needed Outputs:
    //bool moving; float moveSpeed; bool turning; float turnSpeed;float eatingSpeed; bool eating; bool attack;
    if (neurons[outputNeurons[0]].outputValue > 0) {
      moving = true;
    } else {
      moving = false;
    }
    if (moving) {
      if (neurons[outputNeurons[1]].outputValue > 300) {
        speed = .3;
      } else if (neurons[outputNeurons[1]].outputValue < -300) {
        speed = .3;
      } else {
        speed = neurons[outputNeurons[1]].outputValue/1000;
      }
      pos.x += (cos(rotation)*speed*0.2);
      pos.y += (sin(rotation)*speed*0.2);

      if (pos.x > map.size)
        pos.x -= map.size;
      if (pos.x < 0)
        pos.x += map.size;
      if (pos.y > map.size)
        pos.y -= map.size;
      if (pos.y < 0)
        pos.y += map.size;
    }
    if (neurons[outputNeurons[2]].outputValue > 0) {
      turning = true;
    } else {
      turning = false;
    }
    if (turning) {
      rotationSpeed = neurons[outputNeurons[3]].outputValue;
      if (rotationSpeed > 30) {
        rotationSpeed = .1;
      } else if (rotationSpeed < -30) {
        rotationSpeed = .1;
      } else {
        rotationSpeed /= 100;
      }
      rotation += rotationSpeed;
      if (rotation > 2*PI)
        rotation -= 2*PI;
      if (rotation < 0)
        rotation += 2*PI;
    }
    if (neurons[outputNeurons[4]].outputValue > 0) {
      eatingSpeed = neurons[outputNeurons[4]].outputValue/1000;
      if (neurons[outputNeurons[4]].outputValue > 1000) {
        eatingSpeed = 1;
      }
    } else {
      eatingSpeed = 0;
    }
    if (neurons[outputNeurons[5]].outputValue > 0) {
      eating = true;
      map.tiles[int(pos.x)][int(pos.y)].update();
      if (map.tiles[int(pos.x)][int(pos.y)].food > eatingSpeed) {
        map.tiles[int(pos.x)][int(pos.y)].food -= eatingSpeed;
        fullness += eatingSpeed;
      }
    } else {
      eating = false;
    }
    fullness -= .05;
  }
  
  Herbivore copyHerbivore(int _id, int _num){
    Herbivore newHerb = new Herbivore(_id, _num, name);
    newHerb.pos = pos.copy();
    newHerb.eye1 = eye1.copy();
    newHerb.eye2 = eye2.copy();
    newHerb.outputNeurons = outputNeurons;
    for(int i = 0; i < neuronCount; i++){
      newHerb.neurons[i] = neurons[i].copyNeuron(creatureNum, i);
    }
    return newHerb;
  }
}
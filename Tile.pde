class Tile{
  int posX, posY;
  int size;
  float foodValue, noise;
  boolean water = false;
  int timeOutCounter = 0;
  boolean updated = false;
  float food;
  int zone = 0;
  
  Tile(int initX, int initY, int initOffsetX, int initOffsetY){
    posX = initX;
    posY = initY;
    noise = noise((posX+initOffsetX)*0.1, (posY+initOffsetY)*0.1)*noise((posY+initOffsetX)*0.05, (posX+initOffsetY)*0.05);
    if(noise <= seaLevel){
      water = true;
      foodValue = 0;
    }else{
      water = false;
      foodValue = noise;
      food = noise*100;
    }
  }
  
  void drawTile(){
    rectMode(CORNER);
    size = 1 + zoom;
    if(water){
      fill(0,100,130-300*noise);
    }else{
      fill(180-food,170+food,food);
    }
    noStroke();
    rect(posX*size+offsetX,posY*size+offsetY,size, size);
  }
  
  void update(){
    if(noise <= seaLevel){
      water = true;
      foodValue = 0;
      food = 0;
    }else{
      water = false;
      foodValue = noise;
    }
    if(!updated){
      if(food < foodValue*100){
        food += regrowRate*foodValue*timeOutCounter;
        if(food > foodValue*100){
          food = foodValue*100;
        }
      }
      timeOutCounter = 0;
      updated = true;
    }
  }
  void underMouse(){
    size = 1 + zoom;
    if(water){
      fill(0,100,130-300*noise);
    }else{
      fill(180-food,170+food,food);
    }
    stroke(0);
    strokeWeight(1);
    rect(posX*size+offsetX,posY*size+offsetY,size, size);
  }
}
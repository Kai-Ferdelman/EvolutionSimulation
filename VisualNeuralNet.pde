class VisualNeuralNet {

  boolean showValues = false;
  boolean showIO = true;
  float size = 20;

  Neuron[] neurons;
  VisualNeuralNet() {
  }

  void run(Neuron[] _neurons) {
    rectMode(CORNER);
    fill(0);
    noStroke();
    rect(height, 0, width-height, height);
    neurons = _neurons;
    drawOutputs();
    display();
    drawInputs();
  }

  void display() {
    for (Neuron neuron : neurons) {
      strokeWeight(1);
      if (neuron.selected) strokeWeight(5);
      for (int i = 0; i < neuron.inputs.length; i++) {
        if (neuron.inputs[i] >= 0) {
          PVector midPoint = PVector.sub(neuron.pos, neurons[neuron.inputs[i]].pos).div(2);
          stroke(#00FF00);
          line(neuron.pos.x, neuron.pos.y, neuron.pos.x-midPoint.x, neuron.pos.y-midPoint.y);
          stroke(#FF0000);
          line(neurons[neuron.inputs[i]].pos.x+midPoint.x, neurons[neuron.inputs[i]].pos.y+midPoint.y, neurons[neuron.inputs[i]].pos.x, neurons[neuron.inputs[i]].pos.y);
          
        } else if (neuron.inputs[i] < 0) {
          stroke(#00FF00);
          if (neuron.inputs[i] < -10) {
            line(neuron.pos.x, neuron.pos.y, height-neuron.inputs[i]*80-800, 150);
          } else {
            line(neuron.pos.x, neuron.pos.y, height-neuron.inputs[i]*80, 50);
          }
        }
      }
      if(neuron.selected){
        textSize(30);
        fill(255);
        String function = "";
        function += neuron.inputs[0];
        for(int i = 1; i < neuron.numOfInputs; i++){
          function += " ";
          function += neuron.operatorSymbols[neuron.operators[i-1]];
          function += " ";
          function += neuron.inputs[i];
          function += " ";
        }
        text("Function: "+function,height+(width-height)/2, height-100);
        if (showValues){
          textSize(15);
          function = "";
          if(neuron.inputs[0] >= 0) function += neurons[neuron.inputs[0]].outputValue;
          else function += herbs.get(selectedCreature).getInput(neuron.inputs[0]);
        for(int i = 1; i < neuron.numOfInputs; i++){
          function += " ";
          function += neuron.operatorSymbols[neuron.operators[i-1]];
          function += " ";
          if(neuron.inputs[i] >= 0) function += neurons[neuron.inputs[i]].outputValue;
          else function += herbs.get(selectedCreature).getInput(neuron.inputs[i]);
          function += " ";
        }
        text("Function: "+function+" = "+neuron.outputValue, height+(width-height)/2, height-50);
        }
      }
    }
    int i = 0;
    for (Neuron neuron : neurons) {
      fill(0);
      stroke(255);
      strokeWeight(1);
      if (neuron.selected) strokeWeight(5);
      ellipse(neuron.pos.x, neuron.pos.y, size, size);
      textAlign(CENTER, CENTER);
      textSize(10);
      fill(255);
      text(i, neuron.pos.x, neuron.pos.y);
      textSize(20);
      if (showValues) text(neuron.outputValue, neuron.pos.x, neuron.pos.y+size);
      i++;
    }
  }

  void drawInputs() {
    pushMatrix();
    translate(80, 0);
    String[] inputs = {"PosX", "PosY", "Rotation", "OnWater", "Food", "Eye1\nOnWater", "Eye1\nFood", "Eye2\nOnWater", "Eye2\nFood", "Hurting", "Herd", "Herd\nHurting", "Hostiles", "Fullness", "Invert", "Zero", "Friendly\nPosX", "Friendly\nPosY", "Hostile\nPosX", "Hostile\nPosy"};
    for (int i = 0; i < inputs.length; i++) {
      rectMode(CENTER);
      fill(0);
      stroke(255);
      strokeWeight(1);
      textSize(10);
      if (i >= 10) {
        rect(height+i*80-800, 150, 70, 30);
        fill(255);
        text(inputs[i], height+i*80-800, 150);
        textSize(15);
        if (showValues) text(herbs.get(selectedCreature).getInput(-(i+1)), height+i*80-800, 175);
      } else {
        rect(height+i*80, 50, 70, 30);
        fill(255);
        text(inputs[i], height+i*80, 50);
        textSize(15);
        if (showValues) text(herbs.get(selectedCreature).getInput(-(i+1)), height+i*80, 75);
      }
    }
    popMatrix();
  }

  void drawOutputs() {
    pushMatrix();
    translate(225,height-170);
    String[] outputs = {"Moving", "Moving\nSpeed", "Turning", "Turning\nSpeed", "Eating", "Eating\nSpeed"};
    for (int i = 0; i < outputs.length; i++) {
      rectMode(CENTER);
      fill(0);
      stroke(#FF0000);
      strokeWeight(1);
      if(herbs.get(selectedCreature).neurons[herbs.get(selectedCreature).outputNeurons[i]].selected) strokeWeight(5);
      line(height+i*80, 0, herbs.get(selectedCreature).neurons[herbs.get(selectedCreature).outputNeurons[i]].pos.x-225, herbs.get(selectedCreature).neurons[herbs.get(selectedCreature).outputNeurons[i]].pos.y-height+170);
      strokeWeight(1);
      fill(0);
      stroke(255);
      textSize(10);
      rect(height+i*80, 0, 70, 30);
      fill(255);
      text(outputs[i], height+i*80, 0);
        textSize(15);
        if (showValues) text(herbs.get(selectedCreature).neurons[herbs.get(selectedCreature).outputNeurons[i]].outputValue,  height+i*80, 25);
    }
    popMatrix();
  }
}
class  Neuron {

  float outputValue = 0;
  float tempValue;
  int numOfInputs;
  int[] inputs;
  float[] inputValues;
  int[] operators; 
  String[] operatorSymbols = {"+", "-", "*", "/"};
  int creatureNum;
  PVector pos = new PVector();
  boolean selected = false;
  int centerDist = 300;
  int inputVariables;
  int neuronCount;
  int neuronNum;

  Neuron(int initNumOfInputs, int initNeuronCount, int initInputVariables, int initCreatureNum, int initNeuronNum) {
    numOfInputs = initNumOfInputs;
    inputVariables = initInputVariables;
    neuronCount = initNeuronCount;
    neuronNum = initNeuronNum;
    inputs = new int[numOfInputs];
    inputValues = new float[numOfInputs];
    operators = new int[numOfInputs-1];
    creatureNum = initCreatureNum;
    float neuronPosValue = (TWO_PI*neuronNum)/neuronCount;
    pos.x = sin(neuronPosValue)*centerDist+height+(width-height)/2;
    pos.y = height/2-cos(neuronPosValue)*centerDist;

    for (int i = 0; i < inputs.length; i ++) {
      inputs[i] = int(random(neuronCount+inputVariables)-inputVariables);
    }
    for (int i = 0; i < operators.length; i ++) {
      operators[i] = int(random(4));
    }
  }

  void calc() {
    try {
      for (int i = 0; i < inputValues.length; i++) {


        if (inputs[i] < 0) {
          //get value from creatures inputs
          inputValues[i] = herbs.get(creatureNum).getInput(inputs[i]);
        } else {
          //get value from other neuron
          inputValues[i] = herbs.get(creatureNum).neurons[i].outputValue;
        }
      }
    }
    catch(Exception e) {
    }
    outputValue = inputValues[0];
    if (creatureNum == selectedCreature && selected) {
      println(outputValue);
    }
    for (int i = 1; i < inputValues.length; i++) {
      switch(operators[i-1]) {
      case 0:
        if (creatureNum == selectedCreature && selected) {
          print(outputValue);
        }
        outputValue+=inputValues[i];
        if (creatureNum == selectedCreature && selected) {
          println("+"+inputValues[i]+"="+outputValue);
        }
        break;
      case 1:
        if (creatureNum == selectedCreature && selected) {
          print(outputValue);
        }
        outputValue-=inputValues[i];
        if (creatureNum == selectedCreature && selected) {
          println("-"+inputValues[i]+"="+outputValue);
        }
        break;
      case 2:
        if (creatureNum == selectedCreature && selected) {
          print(outputValue);
        }
        outputValue*=inputValues[i];
        if (creatureNum == selectedCreature && selected) {
          println("*"+inputValues[i]+"="+outputValue);
        }
        break;
      case 3:
        if (creatureNum == selectedCreature && selected) {
          print(outputValue);
        }
        if (inputValues[i] != 0) {
          outputValue/=inputValues[i];
          if (creatureNum == selectedCreature && selected) {
            println("/"+inputValues[i]+"="+outputValue);
          }
          break;
        } else {
          break;
        }
      }
    }
    if (creatureNum == selectedCreature && selected) {
          println();
        }

    if (outputValue > 10000) {
      outputValue = 10000;
    }
    if (outputValue < -10000) {
      outputValue = -10000;
    }
    if (abs(outputValue) < 0.000001) {
      outputValue = 0;
    }
  }

  Neuron copyNeuron(int initCreatureNum, int initNeuronNum) {
    Neuron newNeuron = new Neuron(numOfInputs, neuronCount, inputVariables, initCreatureNum, initNeuronNum);
    newNeuron.inputs = inputs;
    newNeuron.operators = operators;
    newNeuron.pos = pos.copy();
    return newNeuron;
  }
}
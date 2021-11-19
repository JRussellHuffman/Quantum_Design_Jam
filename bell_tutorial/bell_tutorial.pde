import processing.svg.*;

String[] quantumCorpusLoad;
String[] finalQuantumArray;
color black = color(0);
color white = color(255);
int startingX;
int startingY;
int scale = 18;
int rows = 40;
int columns = 50;
boolean drawOnBottom;
int padding = 50;
int shots = 1000;
boolean simulate = false; 

void setup() {
  beginRecord(SVG, "export-as-vector-art.svg");
  size(1000,1000);
  pixelDensity(1); //this causes some issues in the SVG export. Recommend reverting to 1 when exporting.
  background(white);
  strokeWeight(5);
  stroke(black);
  if (simulate) {
    createReadings();
  } else {
    parseCorpus();
  }
  drawLines();
  endRecord();
}

void parseCorpus() {
  quantumCorpusLoad = loadStrings("corpus.txt");
  finalQuantumArray = quantumCorpusLoad[0].replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\'", "").replaceAll("\\s", "").split(",");
  //print(finalQuantumArray); //uncomment to see the values in the console
}

void createReadings() {
  Simulator simulator = new Simulator(0.1); // the parameter adds error. 0 is no error. 1 is pure noise. 0.1 seems to be similar to real hardware
  int qubits = 2;
  
  QuantumCircuit phiPlus = new QuantumCircuit(qubits, qubits); //the first parameter is number of quantum registers (qubits). the second is classical registers, which should always be the same as qubits, so using the same variable 
  
  // -------------------------------------------------------
  //add circuit here
  phiPlus.h(0);
  phiPlus.cx(0, 1);
  
  
  // -------------------------------------------------------
  
  //measure entire circuit
  for (int i = 0; i < qubits; i++) {
    phiPlus.measure(i, i); //measure all the qubits
  }

  //drop everything into the same array as real hardware data
  List<String> measurements = new ArrayList();
  for (int i = 0; i < shots; i++) {
    Map<String,Integer> counts = (Map)simulator.simulate(phiPlus, 1, "counts");
    String firstKey = counts.keySet().iterator().next();
    measurements.add(firstKey);
  }
  finalQuantumArray = measurements.toArray(new String[0]);
  //println(finalQuantumArray);
}


//Draw lines based on the corpus. The left digit (the 1st qubit's data)
//determines the position as either the top canvas or the bottom canvas.
//the right digit (0th qubit's data) determines if its a hortizontal or vertical line.

void drawLines() {
  for (int i = 0; i < finalQuantumArray.length; i = i+1) {
    
    //store 0 and 1 as characters
    int binary0='0';
    char b0 = (char)binary0; 
    int binary1='1';
    char b1 = (char)binary1; 
   
    // get the first qubit character
    char qb0 = finalQuantumArray[i].charAt(0);
    // get the second qubit character
    char qb1 = finalQuantumArray[i].charAt(1);
   
    
    
    //decide which canvas to draw the line on
    if (qb0 == b0) {
      drawOnBottom = false;
    } else {
      drawOnBottom = true;
    }
    
    //draw either a hortizontal or vertical line
    if (qb1 == b0) {
      drawHortizontalLine(i, drawOnBottom);
    } else {
      drawVerticalLine(i, drawOnBottom);
    }
  }
}

void drawHortizontalLine(int i, boolean drawBottom) {
  
  double ycoordinate = Math.floor(i/(columns));
  double xcoordinate = i - (ycoordinate*columns);
  
  startingX = (int) xcoordinate * scale + (scale/5) + padding; //start 20 percent in so each line is nicely aligned
  startingY = (int) ycoordinate * scale + (scale/2); //start 50% in
  
  startingY += scale/4 * 10 + padding; //adding a gap from the top
  
  if (drawBottom) {
    startingY += rows * scale / 2; //start halfway down
    startingY += scale/2 * 10; //adding a gap between the two
  }
  
  line(startingX,startingY, startingX + scale - (scale/(5/2)), startingY); //make the length 20 percent shorter, which is 10 percent of each side
}

void drawVerticalLine(int i, boolean drawBottom) {
  double ycoordinate = Math.floor(i/(columns));
  double xcoordinate = i - (ycoordinate*columns);
  
  startingX = (int) xcoordinate * scale + (scale/2) + padding; //make the length 20 percent short, which is 10 percent of each side
  startingY = (int) ycoordinate * scale + (scale/5);
  
  startingY += scale/4 * 10 + padding; //adding a gap from the top
  
  if (drawBottom) {
    startingY += rows * scale / 2; //start halfway down
    startingY += scale/2 * 10; //adding a gap between the two 
  }
  
  line(startingX,startingY, startingX, startingY + scale - (scale/(5/2)));//make the length 20 percent short, which is 10 percent of each side
}

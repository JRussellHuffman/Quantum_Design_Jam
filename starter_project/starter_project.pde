import processing.svg.*; //enables exporting to SVG

String[] quantumCorpusLoad; //raw imported data
String[] finalQuantumArray; //parsed data used to draw composition
boolean simulate = true; //change to true to pull data from MicroQiskit. Otherwise, it will pull from the textfile in the root folder, which contains data from real quantum hardware, generated by Qiskit

void setup() {
  beginRecord(SVG, "export-as-vector-art.svg"); //encapsulate the entire setup function's content in an SVG
  size(1000,1000); //canvas size
  pixelDensity(2); //this causes somme issues in the SVG export. Recommend reverting to 1 when exporting.
  //pulls either real or simulated data
  if (simulate) {
    createReadings();
  } else { 
    parseCorpus();
  }
  //call the function that will draw to the canvas
  DrawArt();
  endRecord(); // placed at the end of the setup function and closes out beginRecord()
}

void parseCorpus() { //pulls in the data from text file containing the output from Qiskit from the real quantum system
  quantumCorpusLoad = loadStrings("corpus.txt");
  finalQuantumArray = quantumCorpusLoad[0].replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\'", "").replaceAll("\\s", "").split(",");
}

void createReadings() { //create a circuit with MicroQiskit and stores the simulated data
  Simulator simulator = new Simulator(0.1); // the parameter adds error. 0 is no error. 1 is pure noise. 0.1 seems to be similar to real hardware
  int qubits = 2; //the number of qubits being used in your circuit
  int shots = 10; //determins the number shots used in the circuitd
  
  QuantumCircuit phiPlus = new QuantumCircuit(qubits, qubits); //the first parameter is number of quantum registers (qubits). the second is classical registers, which should always be the same as qubits, so using the same variable 
  
  // -------------------------------------------------------
  //add your circuit here.
  
  
  
  // -------------------------------------------------------
  
  //measure entire circuit
  for (int i = 0; i < qubits; i++) {
    phiPlus.measure(i, i); //measure all the qubits
  }

  //drops everything into the same array as real hardware data
  List<String> measurements = new ArrayList();
  for (int i = 0; i < shots; i++) {
    Map<String,Integer> counts = (Map)simulator.simulate(phiPlus, 1, "counts");
    String firstKey = counts.keySet().iterator().next();
    measurements.add(firstKey);
  }
  finalQuantumArray = measurements.toArray(new String[0]);
}

void DrawArt() {
  // -------------------------------------------------------
  //draw your art here. Examples renders text on the main canvas
  
  text("What get's put in this function will be drawn on the canvas.", 40, 120); 
  text("For example, below is the entire corpus of data from our quantum system.", 40, 150); 
  
  for (int i = 0; i < finalQuantumArray.length; i++) {
    text(finalQuantumArray[i], 40, 180+(i*30)); 
  }
  // -------------------------------------------------------
   
};

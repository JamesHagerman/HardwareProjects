
/* 
   Sensatron 2013 Light Rig
   James Hagerman
*/

import TotalControl.*;

// These variables are 
int STRANDS = 12; // Number of physical wands
int STRAND_LENGTH = 50; // Number of lights per strand
int LED_COUNT = STRAND_LENGTH; // Total number of lights

int strandCount = 6;
int pixelsOnStrand = 100;
int totalPixels = strandCount * pixelsOnStrand;

// Onscreen display:
int SIZE = 600;
double dRad = (Math.PI*2)/STRANDS;
int[][] lights = new int[STRANDS][STRAND_LENGTH];
int SPACING = 5;
PFont font;

// TCL Stuff:
TotalControl tc;
int[] tclArray = new int[totalPixels];
int[] remap = new int[strandCount * pixelsOnStrand];

// Status output dots
int statusDotRow = 0;

void setup() {
  size(SIZE+100, SIZE, P3D);
  frameRate(60);
  smooth();
  font = createFont("Arial Bold",10);
  
  int status = tc.open(strandCount,pixelsOnStrand);
  if(status != 0) {
    tc.printError(status);
    exit();
  }
  
  buildRemapArray();
  
}

void draw() {
  background(0);
  displayFramerate();
  printStatusDots();
  
  updateLights();
  drawLights();
  
  mapDrawingToLights();
  sendLights();
  delay(100);
  
}

void updateLights() {
//  color thisRandomColor = getRandomColor();
//  for (int i = 0; i < totalPixels; i++) {
//    tclArray[i]  = getRandomColor();
//  }

//  randomizeAllLights();
  setAllLights(color(255,0,0));
  setOneLight(0,5,color(255));
}

void randomizeAllLights() {
  for (int strand = 0; strand < STRANDS; strand++) {
    for (int lightNum = 0; lightNum < STRAND_LENGTH; lightNum++) {
      lights[strand][lightNum] = getRandomColor();
    }
  }
}

void setAllLights(color c) {
  for (int strand = 0; strand < STRANDS; strand++) {
    for (int lightNum = 0; lightNum < STRAND_LENGTH; lightNum++) {
      lights[strand][lightNum] = c;
    }
  } 
}

void setOneLight(int strand, int lightNum, color c) {
  lights[strand][lightNum] = c;
}

void mapDrawingToLights() {
  int lightIndex = 0;
  for (int strand = 0; strand < STRANDS; strand++) {
    for (int lightNum = 0; lightNum < STRAND_LENGTH; lightNum++) {
      tclArray[lightIndex] = lights[strand][lightNum];
      lightIndex++;
    }
  } 
}

color getRandomColor() {
  return color((int)random(255), (int)random(255), (int)random(255));
}

void sendLights() {
  tc.refresh(tclArray,remap);
}

void buildRemapArray() {
  println("Building remap array");
  for (int i = 0; i < STRANDS * STRAND_LENGTH; i++) {
    remap[i] = i;
  }
  println("Done building remap array");
}

void drawLights() {
  int centerX = width/2;
  int centerY = height/2;
  
  pushMatrix();
//  rotateZ(radians(180));
  translate(0, 0, -175);
  rotateX(radians(45));
  
  
  
  
  
  for (int strand = 0; strand < STRANDS; strand++) {
    double theta = strand * dRad - (PI/2);
    for (int lightNum = 0; lightNum < STRAND_LENGTH; lightNum++) {
      int c = lights[strand][lightNum];
//      c = 255;
      fill(c);
//      noStroke();
      int y = (int) ((lightNum+1) * SPACING * Math.sin(theta));
      int x = (int) ((lightNum+1) * SPACING * Math.cos(theta));
      x = centerX - x;
      y = centerY - y;
      ellipse(x, y, 5, 5);
    }
    // Draw the wand labels
    fill(255);
    int y = (int) ((STRAND_LENGTH+1) * SPACING * Math.sin(theta));
    int x = (int) ((STRAND_LENGTH+1) * SPACING * Math.cos(theta));
    x = centerX - x;
    y = centerY - y + 5;
    text(strand, x, y);
  }
  
  popMatrix();
}

void colorTest() {
  // This isn't used. It's just here for reference...
  println("Color test");
  
//  int rBlue = (int)random(255);
  int rRed = 0xf1;
  int rBlue = 0xf2;
  int rGreen = 0xf3;
  
  int randomColor = rRed;
  randomColor = rRed << 16 | rBlue << 8 | rGreen;
  println("Custom color hex: " + hex(randomColor,8));
  
  color testColor = color(rRed, rBlue, rGreen, 5);
  println("Test color hex: " + hex(randomColor,8));
  
}

void printStatusDots() {
  if (statusDotRow <= 50) {
    print(".");
    statusDotRow++;
  } else {
    println(".");
    statusDotRow = 0;
  }
}

void displayFramerate() {
  textFont(font,10);
  fill(255);
  text("FPS: " + int(frameRate),20,30);
}

void exit() {
  tc.close();
}


/* 
 Sensatron 2013 Light Rig
 James Hagerman
 */

import TotalControl.*;

// Camera setup:
import processing.video.*;
Capture cam;

// These variables are 
int STRANDS = 12; // Number of physical wands
int STRAND_LENGTH = 50; // Number of lights per strand
int LED_COUNT = STRAND_LENGTH; // Total number of lights

int strandCount = 6;
int pixelsOnStrand = 100;
int totalPixels = strandCount * pixelsOnStrand;

// Onscreen display:
int screenWidth = 1400;
int screenHeight = 600;

PGraphics lightDisplay;
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


// Circle Animation setup:
// Declare two arrays with 50 elements.
int[] xpos = new int[100]; 
int[] ypos = new int[100];
PGraphics circleAnimation;

void setup() {
  size(screenWidth, screenHeight, P3D);
  frameRate(60);
  
  lightDisplay = createGraphics(700, 600, P3D);
  lightDisplay.smooth();
  lightDisplay.lights();
  
  // Circle Animation setup:
  circleAnimation = createGraphics(400,300);
  circleAnimation.smooth();
  // Initialize all elements of each array to zero.
  for (int i = 0; i < xpos.length; i ++ ) {
    xpos[i] = 0; 
    ypos[i] = 0;
  }
  
  font = createFont("Arial Bold", 10);

  int status = tc.open(strandCount, pixelsOnStrand);
  if (status != 0) {
    tc.printError(status);
    exit();
  }

  buildRemapArray();
  
//  String[] cameras = Capture.list();
//  if (cameras.length == 0) {
//    println("There are no cameras available for capture.");
//    exit();
//  } else {
//    println("Available cameras:");
//    for (int i = 0; i < cameras.length; i++) {
//      println(cameras[i]);
//    }
//    
//    // The camera can be initialized directly using an 
//    // element from the array returned by list():
////    cam = new Capture(this, 320, 180, "FaceTime HD Camera (Built-in)");
////    cam.start();     
//  }
  
//  cam = new Capture(this, 320, 180, "FaceTime HD Camera (Built-in)");
//  cam.start(); 
  cam = new Capture(this, 400, 300, "Logitech Camera");
  cam.start(); 
}

void draw() {
  background(150);
  displayFramerate();
//  printStatusDots();

  updateRaw();
//  updateCircleAnimation();
  
  updateLights();
  drawLights();
  
//  delay(100);
}

void updateCircleAnimation() {
  circleAnimation.beginDraw();
  circleAnimation.background(0);
  
  // Shift array values
  for (int i = 0; i < xpos.length-1; i ++ ) {
    // Shift all elements down one spot. 
    // xpos[0] = xpos[1], xpos[1] = xpos = [2], and so on. Stop at the second to last element.
    xpos[i] = xpos[i+1];
    ypos[i] = ypos[i+1];
  }
  
  // New location
  xpos[xpos.length-1] = mouseX; // Update the last spot in the array with the mouse location.
  ypos[ypos.length-1] = mouseY;
  
  // Draw everything
  circleAnimation.pushMatrix();
//  rotateX(radians(45));
//  rotateY(radians(45));
//  translate(width/2,height/2,-100); // for P3D renderer
  circleAnimation.translate(circleAnimation.width/2,circleAnimation.height/2);
  
  for (int i = 0; i < xpos.length; i ++ ) {
     // Draw an ellipse for each element in the arrays. 
     // Color and size are tied to the loop's counter: i.
    
//    rotateZ(radians(i)); // for P3D renderer
    circleAnimation.rotate(radians(i));
    circleAnimation.noStroke();
    circleAnimation.fill(255-i*2, 0+i*2.5, 255, 50);
    circleAnimation.ellipse(xpos[i],ypos[i],i,i);
  }
  circleAnimation.popMatrix();
  circleAnimation.endDraw();
  image(circleAnimation, 700+ cam.width, 100); 
}

void updateRaw() {
  if (cam.available()) {
    cam.read();
    cam.loadPixels();
  }
  image(cam, 700, 100); 
  color c = cam.pixels[1*cam.width+1]; //pixels[y*cam.width+x]
//  color c = cam.get(60,90);
  noStroke();
  fill(c);
  rect(width-30, height-30, 20, 20);  
}

void updateLights() {
//  color thisRandomColor = getRandomColor();
//  for (int i = 0; i < totalPixels; i++) {
//    tclArray[i]  = getRandomColor();
//  }

//  randomizeAllLights();
//  setAllLights(color(255, 0, 0));
//  setOneLight(0, 5, color(255));
//  cycleOneColor();
  useRawColors();
}

void useRawColors() {
  int centerX = cam.width/2;
  int centerY = cam.height/2;
  for (int strand = 0; strand < STRANDS; strand++) {
    double theta = strand * dRad - (PI/2) + PI;
    for (int lightNum = 0; lightNum < STRAND_LENGTH; lightNum++) {
      int y = (int) ((lightNum+3) * SPACING * Math.sin(theta));
      int x = (int) ((lightNum+3) * SPACING * Math.cos(theta));
      
      x = (int)map(x, 0, 700, 0, cam.width);
      y = (int)map(y, 0, 600, 0, cam.height);
      x = centerX - x;
      y = centerY - y;
      fill(cam.pixels[y*cam.width+x]);
      ellipse(700+x, 100+cam.height+y, 5, 5);
      lights[strand][lightNum] = cam.pixels[y*cam.width+x];
    }
  }
}

void cycleOneColor() {
  for (int strand = 0; strand < STRANDS; strand++) {
    for (int lightNum = 0; lightNum < STRAND_LENGTH; lightNum++) {
//      lights[strand][lightNum] = getRandomColor();
      setAllLights(color(255, 0, 0));
      setOneLight(strand, lightNum, color(255));
    }
  }
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
  tc.refresh(tclArray, remap);
}

void buildRemapArray() {
  println("Building remap array");
  for (int i = 0; i < STRANDS * STRAND_LENGTH; i++) {
    remap[i] = i;
  }
  println("Done building remap array");
}

void drawLights() {
  int centerX = lightDisplay.width/2;
  int centerY = lightDisplay.height/2;
  
  lightDisplay.beginDraw();
  lightDisplay.background(100);
  lightDisplay.pushMatrix();
  //  rotateZ(radians(180));
  lightDisplay.translate(0, 0, -100);
//  lightDisplay.rotateX(radians(23));

  for (int strand = 0; strand < STRANDS; strand++) {
    double theta = strand * dRad - (PI/2) + PI;
    for (int lightNum = 0; lightNum < STRAND_LENGTH; lightNum++) {
      int c = lights[strand][lightNum];
//      c = 255;
      lightDisplay.fill(c);
//      noStroke();
      int y = (int) ((lightNum+3) * SPACING * Math.sin(theta));
      int x = (int) ((lightNum+3) * SPACING * Math.cos(theta));
      x = centerX - x;
      y = centerY - y;
      lightDisplay.ellipse(x, y, 5, 5);
    }
    // Draw the wand labels
    lightDisplay.fill(255);
    int y = (int) ((STRAND_LENGTH+3) * SPACING * Math.sin(theta));
    int x = (int) ((STRAND_LENGTH+3) * SPACING * Math.cos(theta));
    x = centerX - x;
    y = centerY - y;
    lightDisplay.text(strand, x, y, 10);
  }

  lightDisplay.popMatrix();
  lightDisplay.endDraw();
  image(lightDisplay, 0, 0);
  
  // Move this information to the physical lights:
  mapDrawingToLights();
  sendLights();
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
  println("Custom color hex: " + hex(randomColor, 8));

  color testColor = color(rRed, rBlue, rGreen, 5);
  println("Test color hex: " + hex(randomColor, 8));
}

void printStatusDots() {
  if (statusDotRow <= 50) {
    print(".");
    statusDotRow++;
  } 
  else {
    println(".");
    statusDotRow = 0;
  }
}

void displayFramerate() {
  textFont(font, 10);
  fill(255);
  text("FPS: " + int(frameRate), 720, 30);
}

void exit() {
  tc.close();
}


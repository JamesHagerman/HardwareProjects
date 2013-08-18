/*
  Sensatron 2013 Lighting Rig - v2.0
  by James Hagerman
  on August 18,2013 at 1:13 am
 */
 
// Physical configuration settings:
int STRANDS = 12; // Number of physical wands
int STRAND_LENGTH = 50; // Number of lights per strand
int LED_COUNT = STRAND_LENGTH; // Total number of lights

// We kinda need to use multiple definitions of the same data... for now...
int strandCount = 6;
int pixelsOnStrand = 100;
int totalPixels = strandCount * pixelsOnStrand;

// Animation settings:
ArrayList<SensatronRoutine> allAnimations; // Place to hold all known animations
ACircle aCircle; // A single circle controlled by the mouse
CircleAnimation originalCircles;

// Lighting class instances:
TCLControl tclControl;
RadialControl radialControl;

void setup() {
  size(500,500, P3D);
  frameRate(60);
  
  // Do hardware init first:
  tclControl = new TCLControl();
  
//  aCircle = new ACircle(100);
  originalCircles = new CircleAnimation();
  
}

void draw() {
//  aCircle.draw();
//  aCircle.updateScreen();
  
  originalCircles.draw();
  originalCircles.updateScreen();
}

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

// We need a way for classes to tell us it's time to change patterns.
boolean changePattern;

// Animation settings:
ArrayList<SensatronRoutine> allAnimations; // Place to hold all known animations
ACircle aCircle; // A single circle controlled by the mouse
CircleAnimation originalCircles;

// Lighting class instances:
TCLControl tclControl;
RadialControl radialControl;
RawConversion rawConversion;

// Onscreen lighting display:
LightDisplay lightDisplay;

// Gyro input:
GyroInput gyroInput;

// Camera input class:
CameraInput cameraInput;

void setup() {
  size(500,500, P3D);
  frameRate(60);
  
  // Do hardware init first:
  tclControl = new TCLControl();
  radialControl = new RadialControl();
  rawConversion = new RawConversion();
  lightDisplay = new LightDisplay();
  gyroInput = new GyroInput(this);
  
  // Set up the webcam:
  // cameraInput = new CameraInput(this);
  
  changePattern = false;
  
  aCircle = new ACircle(100);
  originalCircles = new CircleAnimation();
  
}

void draw() {

  // Keep the gyro data up to date and connected:
  gyroInput.draw();
  
  // If changePattern is true, one of the classes is asking us to change the animation pattern
  if (changePattern) {
    println("Changing patterns!");
    changePattern = false;
  }

  // These draws the actual animation to the screen:
  // if (gyroOkay) {
  //   aCircle.draw(gyroInput.rawX, gyroInput.rawY);
  // } else {
  //   aCircle.draw();
  // }
  // aCircle.updateScreen();
  // rawConversion.stripRawColors(aCircle.pg); // Move the animation data directly to the lights
  
  if (gyroOkay) {
    originalCircles.draw(gyroInput.rawX, gyroInput.rawY);
  } else {
    originalCircles.draw();
  }
  originalCircles.updateScreen();
  rawConversion.stripRawColors(originalCircles.pg); // Move the animation data directly to the lights


  // This draws the camera data to the screen...:
  // cameraInput.drawCameraData();
  // rawConversion.stripRawColors(cam); // and then directly to the lights: 
  
  
  // lightDisplay.drawLights(); // Draw 3D Lighting display

  // Shift radial light array to hardware:
  tclControl.tclArray = radialControl.mapRadialArrayToLights();
  tclControl.sendLights();
  
}

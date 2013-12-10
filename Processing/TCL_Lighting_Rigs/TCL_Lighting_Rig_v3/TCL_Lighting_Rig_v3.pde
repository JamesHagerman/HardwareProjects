/*
  TCL Lighting Rig v3
  by James Hagerman
  on December 5, 2013

  This app started off as the control program for the Sensatron art car owned and opperated
  by Jason Siadek

  I, James, have been working on this code and have been turning it into an overall lighting 
  rig for use with TCL lights. 
 */
 
//============================
// Hardware definitions:

// Lighting class instances:
TCLControl tclControl;

// Physical configuration settings:
int STRANDS = 12; // Number of physical wands
int STRAND_LENGTH = 50; // Number of lights per strand
int LED_COUNT = STRAND_LENGTH; // Total number of lights

// We kinda need to use multiple definitions of the same data... for now...
int strandCount = 6;
int pixelsOnStrand = 100;
int totalPixels = strandCount * pixelsOnStrand;

// Gyro input:
GyroInput gyroInput; // not used in this project but wont compile right now without this

// Kinect management is done by the kinect manager:
KinectManager kinectManager;

// Camera input class:
CameraInput cameraInput; // We aren't using the camera either... yet...

// End hardware definitions
//============================


//============================
// Hardware enabling:

// These variables will let us define which of the above hardware we are actually using:
// If any of these are false, the code will not try to initialize the related hardware.
boolean lightsEnabled = true;
boolean cameraEnabled = false;
boolean gyroEnabled   = false;
boolean kinectEnabled = true;

// End hardware enabling
//============================


//============================
// Display and Data management classes:

// This isn't hardware. It's a class that takes an image and parses color data from it.
// This color is then directly dumped to the lights.
ImageToLights imageToLights;

// This class allows for radial mapping of a normal light array.
RadialControl radialControl;

// Onscreen 3D radial lighting display:
RadialDisplay radialDisplay;

// End Display and Data management clases
//============================


//============================
// Animation related definitions:

// Animation related variables:
AnimationRoutine[] allAnimations; // Place to hold all known animations
AnimationRoutine currentAnimation; // a reference to the current animation object

// The animations themselves:
ACircle aCircle; // A single circle controlled by the mouse
CircleAnimation originalCircles;
Spin spin;
MultiSpin multiSpin;

// How many animations, in total, the system knows about:
int animationCount = 4;

// Animation control:
// ToDo: Change "pattern" to "animation"
int patternIndex = 1; // Start running on pattern 0
int patternIndexMax;

// Automatic pattern changing:
boolean changePattern; // We need a way for classes to tell us it's time to change patterns.
int patternChangeTimer = 0;
int patternChangeTimeout = 1000;


// Animation morph inputs:
//
// All animations should use the same variable names for input so we can better separate physical 
// input devices into their own abstraction. These variables should end up replacing fakeMouseX 
// and fakeMouseY at some point in the future:
int inputX, inputY, inputZ, inputU, inputV, inputW;

// Fake mouse movement variables:
int fakeMouseX;
int fakeMouseY;
int direction = 1;
int direction2 = 1;

// End animation related definitions
//============================

void setup() {
  size(500,500, P3D);
  frameRate(60);
  
  // Init all of the hardware:

  // Init TCL lights. This will try to connect to the hardware!!
  if (lightsEnabled) {
    tclControl = new TCLControl();
  }

  // Try to init the bluetooth gyro. 
  if (gyroEnabled) {
    gyroInput = new GyroInput(this); // We aren't using the bluetooth gyro in this project
  }
  
  // Set up the webcam:
  if (cameraEnabled) {
    cameraInput = new CameraInput(this);
  }

  // Init any attached Kinect devices:
  if (kinectEnabled) {
    kinectManager = new KinectManager(this);
  }


  // Init some color data management:
  imageToLights = new ImageToLights(); // Empty construtor...

  // Init some display classes:
  // These two classes should probably be combined...
  radialControl = new RadialControl(); // Radial mapping tools
  radialDisplay = new RadialDisplay();   // On screen 3D display (radial)
  

  // Init the pattern management:
  changePattern = false;
  
  // Load animations into the animation list:
  loadAnimations();
  
  // Init the input variables if they need to be set:
  fakeMouseX = 0;
  fakeMouseY = 0;
}

void loadAnimations() {

  println("Loading " + animationCount + " animations...");
  allAnimations = new AnimationRoutine[animationCount];

  allAnimations[0] = new ACircle(100);
  allAnimations[1] = new CircleAnimation();
  allAnimations[2] = new Spin(10);
  allAnimations[3] = new MultiSpin(10);

  // aCircle = new ACircle(100);
  // originalCircles = new CircleAnimation();
  // spin = new Spin(10);
  // multiSpin = new MultiSpin(10);

  // Set the maximum pattern index count so the auto changer doesn't freak out:
  patternIndexMax = animationCount - 1;

  // Bound the initial pattern index value to point to a known animation:
  if (patternIndex > patternIndexMax) {
    patternIndex = patternIndexMax;
  }
  if (patternIndex < 0) {
    patternIndex = 0;
  }

  // Set the current animation to be one of the ones in the allAnimations array:
  currentAnimation = allAnimations[patternIndex];

}

void updateHardwareInputs() {
  if (gyroEnabled) {
    // Keep the gyro data up to date and connected:
    gyroInput.keepAlive();

    if (!gyroOkay) {
      patternChangeTimer += 1;
      if (patternChangeTimer > patternChangeTimeout) {
        println("Automatically changing patterns");
        patternChangeTimer = 0;
        changePattern = true;
      }
    }

    // We need to automatically change or set the animation we're running if there is no gyro attached:
    if (!gyroOkay) {
      patternIndex = 1; // Hard code the damn thing to use the COOL animation if we don't have the gyro attached.
    }
  }

  if (kinectEnabled) {

  }


}

void changeAnimation() {
  // If changePattern is true, one of the classes is asking us to change the animation pattern
  if (changePattern) {
    println("Changing patterns!");
    patternIndex += 1;
    if (patternIndex > patternIndexMax) {
      println("Starting from the first pattern.");
      patternIndex = 0;
    }
     if (patternIndex == 0) {
       patternIndex = 1; // This is skipping the first bullshit pattern.
     }
     if (patternIndex == 2) {
       patternIndex = 3; // This is skipping the second bullshit pattern.
     }
    changePattern = false;
  }
}

void draw() {

  // Update any hardware input devices:
  // Note: This function lets hardware trigger animaion changes!
  updateHardwareInputs();

  // Manage any animation changes caused by hardware OR the auto switcher:
  changeAnimation();

  // Map hardware input into one of the generic inputs:
  inputX = mouseX;
  inputY = mouseY;
  
  // Replace the nested if statements with something more easy to understand:
  currentAnimation = allAnimations[patternIndex];
  currentAnimation.draw(inputX, inputY);

  // Dump the current animation frame to the screen:
  currentAnimation.updateScreen();

  // Dump the current animation frame into the light array:
  imageToLights.stripRawColors(currentAnimation.pg);
  
//   // These draw the actual animation to the screen:
//   if (patternIndex == 0) {
//     if (gyroOkay) {
//       aCircle.draw(gyroInput.rawX, gyroInput.rawY);
//     } else {
      
//      fakeMouseX += 10;
//      if (fakeMouseX >= width) {
//        fakeMouseX = 0;
//      }
//      fakeMouseY += (1 * direction);
//      if (fakeMouseY >= 360 || fakeMouseY <= 0) {
//        direction = direction * -1;
//        fakeMouseY += (1 * direction);
//      }
     
//       aCircle.draw(fakeMouseX, fakeMouseY);
//     }
//     aCircle.updateScreen();
//     imageToLights.stripRawColors(aCircle.pg); // Move the animation data directly to the lights
    
//   }

//   if (patternIndex == 1) {
//      // Update the the fake mouse movement
     
//      fakeMouseX += (5 * direction2);
//      if (fakeMouseX >= width || fakeMouseX <= 0) {
//        direction2 = direction2 * -1;
//        fakeMouseX += (1 * direction2);
//      }
//      fakeMouseY += (1 * direction);
//      if (fakeMouseY >= 360 || fakeMouseY <= 0) {
//        direction = direction * -1;
//        fakeMouseY += (1 * direction);
//      }
     
//     if (gyroOkay) {
//       originalCircles.draw(gyroInput.rawX, gyroInput.rawY);
//     } else {
//       originalCircles.draw(fakeMouseX, fakeMouseY);
// //      originalCircles.draw(mouseX, mouseY);
//     }
//     originalCircles.updateScreen();
//     imageToLights.stripRawColors(originalCircles.pg); // Move the animation data directly to the lights
    
//   } 

//   if (patternIndex == 2) {
//     if (gyroOkay) {
//       // Update the the fake mouse movement
//        fakeMouseY += 1 + int(map(gyroInput.rawY, 0, width, 0, 5));
//        if (fakeMouseY >= 180) {
//          fakeMouseY = 0;
//        }
     
//       spin.draw(fakeMouseY, fakeMouseY);
//     } else {
      
//       // Update the the fake mouse movement
//      fakeMouseX += 10;
//      if (fakeMouseX >= width) {
//        fakeMouseX = 0;
//      }
//      fakeMouseY += 10;
//      if (fakeMouseY >= 180) {
//        fakeMouseY = -0;
//      }
     
//       spin.draw(fakeMouseY, fakeMouseX);
//     }
    
//     spin.updateScreen();
//     imageToLights.stripRawColors(spin.pg);
    
    
//   }

//   if (patternIndex == 3) {
//     if (gyroOkay) {
//       // Update the the fake mouse movement
//        fakeMouseY += 1+ int(map(gyroInput.rawY, 0, width, 0, 5));
//        if (fakeMouseY >= 180) {
//          fakeMouseY = 0;
//        }
     
//       multiSpin.draw(fakeMouseY, fakeMouseY);
//     } else {
      
//       // Update the the fake mouse movement
// //     fakeMouseX += 10;
// //     if (fakeMouseX >= width) {
// //       fakeMouseX = 0;
// //     }
//      fakeMouseY += 1;
//      if (fakeMouseY >= 180) {
//        fakeMouseY = -0;
//      }
     
//       multiSpin.draw(fakeMouseY, mouseY);
//     }
    
//     multiSpin.updateScreen();
//     imageToLights.stripRawColors(multiSpin.pg);
//   }
  


  if (cameraEnabled) {
    // This draws the camera data to the screen...:
    cameraInput.drawCameraData();
    imageToLights.stripRawColors(cam); // and then directly to the lights: 
  }
  

  if (lightsEnabled) {
    // Shift radial light array to hardware:
    tclControl.tclArray = radialControl.mapRadialArrayToLights();
    tclControl.sendLights();
  } else {
    radialDisplay.drawLights(); // Draw 3D radial display
  }
  
}


// Handle keyinput:
void keyPressed(){
  // q to quit gracefully so we don't break the driver:
  if(key=='q') {
    if (kinectEnabled) {
      kinectManager.quit();
    }
    exit();
  }

  if(key == ' ') {
    lightsEnabled = !lightsEnabled;
  }

}

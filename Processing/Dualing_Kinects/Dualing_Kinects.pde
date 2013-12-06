import org.openkinect.*;
import org.openkinect.processing.*;


// Kinect Library objects
Kinect kinect0;
Kinect kinect1;
int device_count = 0;

PImage display0, display1;

// Size of kinect image
int kw = 640;
int kh = 480;

void setup() {
  size(1280,480, P3D);
  frameRate(120);
  
  // Count the Kinects first...
  device_count = Context.getContext().devices();
  println("Number of Kinects attached: " + device_count);
  
  if (device_count == 2) {
    println("We are going to display TWO kinect depth fields!");
    kinect0 = new Kinect(this);
    kinect0.start(0);
    kinect0.enableRGB(false);
    kinect0.enableIR(false);
    kinect0.enableDepth(true);
    kinect0.tilt(0);
    kinect0.processDepthImage(true);
    
    kinect1 = new Kinect(this);
    kinect1.start(1);
    kinect1.enableRGB(false);
    kinect1.enableIR(false);
    kinect1.enableDepth(true);
    kinect1.tilt(0);
    kinect1.processDepthImage(true);
    
  } else if (device_count == 1) {
    println("We are only going to display the output from one kinect.");
    
    kinect0 = new Kinect(this);
    kinect0.start(0);
    kinect0.enableRGB(false);
    kinect0.enableIR(false);
    kinect0.enableDepth(true);
    kinect0.tilt(0);
    
  } else {
    println("No kinect detected!");
  }
}

void draw() {
  imageMode(CORNER);
  display0 = kinect0.getDepthImage();
  image(display0, 0, 0);
  
  display1 = kinect1.getDepthImage();
  image(display1, kw, 0);
}

// Handle keyinput:
void keyPressed(){
  // q to quit gracefully so we don't break the driver:
  if(key=='q') {
    kinect0.quit();
    kinect1.quit();
    exit();
  }
}

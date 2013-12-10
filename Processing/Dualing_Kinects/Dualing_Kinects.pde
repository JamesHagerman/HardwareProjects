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
boolean depth = true;
boolean rgb = false;
boolean ir = false;

void setup() {
  size(1280,520);
  // frameRate(120);
  
  // Count the Kinects first...
  device_count = Context.getContext().devices();
  println("Number of Kinects attached: " + device_count);
  
  if (device_count == 2) {
    println("We are going to display TWO kinect depth fields!");
    kinect0 = new Kinect(this);
    kinect0.start(0);
    kinect0.enableRGB(true);
    // kinect0.enableIR(false);
    // kinect0.enableDepth(true);
    kinect0.tilt(0);
    // kinect0.processDepthImage(true);
    
    kinect1 = new Kinect(this);
    kinect1.start(1);
    kinect1.enableRGB(true);
    // kinect1.enableIR(false);
    // kinect1.enableDepth(true);
    kinect1.tilt(0);
    // kinect1.processDepthImage(true);
    
  } else if (device_count == 1) {
    println("We are only going to display the output from one kinect.");
    
    kinect0 = new Kinect(this);
    kinect0.start(1);
    // kinect0.enableDepth(true);
    kinect0.enableRGB(true);
    // kinect0.enableIR(false);
    kinect0.tilt(0);
    // kinect0.processDepthImage(true);
    
  } else {
    println("No kinect detected!");
  }
}

void draw() {
  background(0);
  // imageMode(CORNER);

  if (device_count == 2) {
    // display0 = kinect0.getDepthImage();
    display0 = kinect0.getVideoImage();
    image(display0, 0, 0);
    
    // display1 = kinect1.getDepthImage();
    display1 = kinect1.getVideoImage();
    image(display1, 640, 0);

  } else if (device_count == 1) {
    // display0 = kinect0.getDepthImage();
    display0 = kinect0.getVideoImage();
    image(display0, 0, 0);
    // image(kinect0.getVideoImage(),0,0);
    // image(kinect0.getDepthImage(),640,0);
    // fill(255);
    // text("RGB/IR FPS: " + (int) kinect0.getVideoFPS(),10,495);
    // text("DEPTH FPS: " + (int) kinect0.getDepthFPS(),640,495);
  }


}

// Handle keyinput:
void keyPressed(){
  // q to quit gracefully so we don't break the driver:
  if(key=='q') {
    if (device_count == 2) {
      kinect0.quit();
      kinect1.quit();
    } else if (device_count == 1) {
      kinect0.quit();
    }
    exit();
  }
  //  else if (key == 'r') {
  //   if (device_count == 2) {
  //     rgb = !rgb;
  //     if (rgb) {
  //       ir = false;
  //     } else {
  //       ir = true;
  //     }
  //     kinect0.enableRGB(rgb);
  //     kinect0.enableIR(ir);
  //     kinect0.enableDepth(depth);
  //     kinect0.tilt(0);
  //     // kinect0.processDepthImage(true);

  //     kinect1.enableRGB(rgb);
  //     kinect1.enableIR(ir);
  //     kinect1.enableDepth(depth);
  //     kinect1.tilt(0);
  //     // kinect1.processDepthImage(true);
      
  //   } else if (device_count == 1) {
  //     rgb = !rgb;
  //     if (rgb) {
  //       ir = false;
  //     } else {
  //       ir = true;
  //     }
  //     kinect0.enableRGB(rgb);
      
  //   }
  // }


}

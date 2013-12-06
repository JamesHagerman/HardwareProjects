import org.openkinect.*;
import org.openkinect.processing.*;

// Internal flob tracking to get rough position data:
import s373.flob.*; // http://s373.net/code/flob/

class KinectManager {
	PApplet parent;

	// Keep track of how many kinects are alive automatically:
	int kinectCount;

	// Arrays for holding each devices info:
	Kinect[] kinectDevices;
	PImage[] kinectDisplays;

	// Size of kinect image
	int kw = 640;
	int kh = 480;

	KinectManager(PApplet parent_) {
		parent = parent_;

		kinectCount = Context.getContext().devices();

		kinectDevices = new Kinect[kinectCount];
		kinectDisplays = new PImage[kinectCount];

		if (kinectCount>0) {
			println(kinectCount+" Kinect(s) attached.");
			println("Initializing them all...");
			for (int i = 0; i<kinectCount; i++) {
				kinectDevices[i] = new Kinect(parent);
			    kinectDevices[i].start(0);
			    kinectDevices[i].enableRGB(false);
			    kinectDevices[i].enableIR(false);
			    kinectDevices[i].enableDepth(true);
			    kinectDevices[i].tilt(0);
			    kinectDevices[i].processDepthImage(true);

			    kinectDisplays[i] = kinectDevices[i].getDepthImage();
			}
		} else {
			println("No Kinects were found! Exiting...");
			exit();
		}
	}

	// This isn't working correctly... but it should draw two kinects depth images:
	void draw() {
	  imageMode(CORNER);
	  	for (int i = 0; i<kinectCount; i++) {
		    kinectDisplays[i] = kinectDevices[i].getDepthImage();
		    image(kinectDisplays[i], i*kw, 0);
		}
	}

	void quit() {
		println("Disconnecting all attached Kinects");
		if (kinectCount>0) {
			for (int i = 0; i<kinectCount; i++) {
				kinectDevices[i].quit();
			}
		}
	}
}
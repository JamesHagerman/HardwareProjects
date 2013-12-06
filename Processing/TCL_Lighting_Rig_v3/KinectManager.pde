import org.openkinect.*;
import org.openkinect.processing.*;

class KinectManager {
	PApplet parent;
	ArrayList<Kinect> kinectDevices;

	KinectManager() {

	}
	KinectManager(PApplet parent_) {
		parent = parent_;
	}

	void quit() {
		println("Disconnecting all attached Kinects");
		// kinect.quit();
	}
}
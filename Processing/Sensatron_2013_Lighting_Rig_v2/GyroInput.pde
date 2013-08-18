/*
  Serial ports are a bitch in processing/java.
  Make sure you use this command to set your /var/lock directory to the correct permissions:
  sudo chmod go+rwx /var/lock

  Still, it isn't flawless. It will probably crash the computer sometimes if there is unexpected
  device disconnects (i.e. if the battery dies on the gyro box).

  There doesn't seem to be a "real" fix anywhere...
 */

import processing.serial.*;

int halfWidth, halfHeight;

Serial myPort;
PApplet parent; // Needed for any serial init code

int serialKeepAlive;
int serialTimeOut = 120;
String keepAliveTest = "";
boolean serialOkay = false;

int lf = 10; // ASCII linefeed
String inString = ""; // Holds the string captured from the serial event

String[] splitSerial;
int ax, ay, az;

class GyroInput {

	GyroInput(PApplet parent_) {
		parent = parent_;

		halfWidth = width/2;
		halfHeight = height/2;

		// Set up the software serial port for comms over bluetooth:
		serialOkay = initBlueToothSerial(parent);
		if (!serialOkay) {
			println("Couldn't open serial port! Continuing anyways...");
			// exit();
		}

		// Set up shutdown functions:
		prepareExitHandler();

		println("Waiting until we settle... DERP");
		delay(1000);
	}

	void checkSerialStatus() {
	  serialKeepAlive++;
	  if (serialKeepAlive >= serialTimeOut) {
	    println("Checking serial port status...");
	    if (keepAliveTest.equals(inString)) {
	      println("We lost our connection! Reconnecting...");
	      reconnectSerial();
	    } else {
	//      println("Still connected. Updating test string and carrying on...");
	      keepAliveTest = inString;
	      serialKeepAlive = 0;
	    }
	  }
	}

	void reconnectSerial() {
	  myPort.stop();
	  if (!initBlueToothSerial(parent)) {
	    println("We couldn't reconnect...");
	  } else {
	    println("Reconnected!");
	  }
	}

	boolean initBlueToothSerial(PApplet parent_) {
	  try {
	    // Set up the serial port:
	    String[] availableSerialPorts = Serial.list();
	    for (int i=0; i<availableSerialPorts.length; i++) {
	      println(availableSerialPorts[i]); // Print the available serial ports
	  
	        // Bluetooth: tty.FireFly-57DF-RNI-SPP  runs at 9600
	        // FTDI: tty.usbserial                  runs at 38400
	        // Hacked bluetooth makeymate: tty.FireFly-57DF-RNI-SPP runs at 115200
	  //    if (availableSerialPorts[i].indexOf("tty.usbserial") > 0) {
	      if (availableSerialPorts[i].indexOf("tty.FireFly-57DF-RNI-SPP") > 0) {
	         myPort = new Serial(parent_, availableSerialPorts[i], 115200); 
	         println("Using serial port " + availableSerialPorts[i]);
	         serialKeepAlive = 0;
	         break;
	      }
	    } 
	    
	    // Set up the serial buffer to only call the serialEvent method when a linefeed is received:
	    myPort.bufferUntil(lf);
	    return true;
	  } catch (Exception e) {
	    println("Serial error!");
	  }
	  return false;
	}

	void reconnectSerial(PApplet parent_) {
	  myPort.stop();
	  if (!initBlueToothSerial(parent_)) {
	    println("We couldn't reconnect...");
	  } else {
	    println("Reconnected!");
	  }
	}

	void processSerialInputString() {
  
	  splitSerial = split(inString, ':');
	//  print(inString + " - " + splitSerial.length);
	  if (splitSerial.length==5) {
	//    println(splitSerial[0]);
	//    println(splitSerial[1]);
	//    println(splitSerial[2]);
	//    println(splitSerial[3]);
	    
	    ax = int(splitSerial[1]);
	    ay = int(splitSerial[2]);
	    az = int(splitSerial[3]);
	//    println("Here: "+ az+ ":" + map(az,-17000,17000,-90,90));
	  } else {
	    println("No data received...");
	  }
	  background(80);
	  // drawMyBox(halfWidth, halfHeight, 40, -int(map(ax,-18000,18000,-90,90)), 0, int(map(ay,-18000,18000,-90,90)));

	}

}

void serialEvent(Serial p) {
  inString = (myPort.readString());
 println(inString);
}

// Try to clean up the serial port correctly every time the app closes:
private void prepareExitHandler() {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () { 
      if (serialOkay) {
        println("Stopping serial port");
        myPort.stop();
      }
    }
  }));
}
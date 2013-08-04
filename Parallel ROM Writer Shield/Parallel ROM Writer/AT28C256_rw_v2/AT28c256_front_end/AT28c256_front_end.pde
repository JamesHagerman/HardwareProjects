// This application was written to load a firmware file on the host machine and then use the
// serial protocol expressed by the Arduino program for the EEPROM/EPROM Reader and Writer
// shield to write that firmware file to an AT28C256 parallel EEPROM chip.
//
// There is no size limiting in this application! It will try to write the full firmware file!
// This means, if you're using a chip smaller then 256k, you probably don't want your firmware file
// to be bigger then your actual chip's maximum memory size.
//
// Please read through all of the comments to get an idea of what this code does before running it.
// It may or may not be doing what you want.
//
// This code was written for use with really any chip. Most of the logic can be found in the 
// accompanying Arduino source code. 
// 
import processing.serial.*;
Serial myPort; 

int inByte = -1;
int serialLength = 0;
int serialCount = 0;
String inString = "";

byte firmware_bytes[];

void setup() {
  size(200, 200);

  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil(10); // line feed is 10

  println("Starting program in 2 seconds");
  delay(2000); // let everything's voltages settle down a bit...

  myPort.clear();
}

void draw() {
  background(0);

  // Change this to tell the front end app which file you want to write.
  firmware_bytes = loadBytes("FCB_V103_256.bin");

  // Actually walk through the file, write, and verify each of the bytes loaded.
  verify_whole_memory_fix_issues();

  exit();
}

void verify_whole_memory_fix_issues() {
  int max_fix_attempts = 10;
  
  // This steps through every byte in the loaded firmware file that you're asking the system to flash.
  // It will try to write each byte and then verify that the written byte can be read back from that 
  // same address without any errors.
  //
  // If you see a bunch of '.'s scrolling, this is a good thing. These are "write okay" periods.
  //
  // If you see a bunch of increasing numbers, the system is having problems writing that address. It
  // will retry a few times (10 times by default) and if it still can't verify a good write occured, 
  // it will alert you as to which memory address seemed to fail and tel you to check it manually.
  //
  // Manual checking of these addresses can be done using the serial interface provided by JUST the
  // Arduino source code. You'll have to start up a serial session to the Arduino and send the 
  // read:<address> or write:<address>:<data> commands yourself manually.
  // 
  for ( int i = 0; i < firmware_bytes.length; i++) { //firmware_bytes.length
    int fix_attempts = 0;
    while (!check_address (i) && fix_attempts <= max_fix_attempts) {

      // Past 5 attempts, something is funky with the memory chip...
      if (fix_attempts == 5) {
        println("\n!! " + i + ":" + (firmware_bytes[i] & 0xff) + "");
      }

      print(fix_attempts); // printout the current try count
      write_address(i);

      fix_attempts += 1;
    }

    if (fix_attempts == 0) {
      print("."); // minimal ok write output. This is a good thing!
    } else if (fix_attempts == max_fix_attempts) {
      println("\n Check memory address " + i + " manually!!!!");
    }

    if (i%100 == 0) {
      println(i); // Add a new line every hundred written bytes...
    }
  }
}


// File write functions:
boolean check_address(int this_address) {
  int this_byte = firmware_bytes[this_address] & 0xff;
  int read_data = read(this_address);
  if (read_data == this_byte) {
    return true;
  } else {
    return false;
  }
}
boolean write_address(int this_address) {
  int this_byte = firmware_bytes[this_address] & 0xff;
  return write(this_address, this_byte);
}

// Basic read write functions
int read(int the_address) {
  int toRet =-1;
  myPort.write("read:");
  myPort.write(str(the_address));
  myPort.write(10);

  while (inString == "") {
  }
  //println("Got response: " + inString);
  int sep_index = inString.indexOf(":");

  if (inString.substring(0, sep_index + 1).equals("r:")) {
    inString = inString.substring(sep_index + 1);
    sep_index = inString.indexOf(":");

    inString = trim(inString.substring(sep_index + 1));

    //println("Data part: " + inString);

    toRet = parseInt(inString);
    //println("Read completed: " + toRet);
    inString = "";
    return (toRet & 0xFF);
  } else {
    println("Read failed: Serial error");
    println("Response: " + inString.substring(0, sep_index + 1));
    println("Expected: " + "r:" );
    inString = "";
    return toRet;
  }
}
boolean write(int the_address, int the_byte) {
  myPort.write("write:");
  myPort.write(str(the_address));
  myPort.write(":");
  myPort.write(str(the_byte));
  myPort.write(10);

  while (inString == "") {
  }
  //println("Got response: " + inString);
  if (inString.equals("w:" + the_address + ":" + the_byte + "\n") ) {
    // println("Write completed!");
    inString = "";
    return true;
  } else {
    println("Write failed: Serial error");
    print("Response: " + inString);
    print("Expected: " + "w:" + the_address + ":" + the_byte + "\n" );
    inString = "";
    return false;
  }
}

// Basic serial comm stuff
void serialEvent(Serial myPort) {
  serialCount += 1;
  inString = (myPort.readString());
  //println("got a serial message " + serialCount + ": ");
  //print(inString);
}


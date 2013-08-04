// EEPROM/EPROM Reader/Writer shield
//
// Options on the shield:

// Chip Type switch:
// This switch changes the function of pins 1 and 27 on the PROM Chip. These pins 
// change meaning for different chips. The labels seem to be backwards on the board...
//
// Set to EEPROM (left):
//	Pin 1: eprom size switch (see below (address bit 15 or Vpp select header value (Vcc or a2)))
//	Pin 27: address bit 14
//
// Set to EPROM (right):
//	Pin 1: address bit 14
//	Pin 27: a0 (Write Enable control comes from a0)
//
//
// EPROM Size switch:
// This switch only functions when the Chip Type switch is set to the left (towards 
// EEPROM... since that switches labels are wrong). When it is, pin 1 on the PROM chip
// will be set to either address bit 15 or to the value of the Vpp Select header.
// 
// Left:
//	Pin 1: Vpp Select header (Vcc or a2)
// Right ->
//	Pin 1: address bit 15
//
// Vpp Select header:
// If the two switches are set correctly (see above) this header will set pin 1 on the PROM
// to either Vcc or wire it to a2 on the arduino so we can control that pin from software.
//
// This header also alows us to break out pin 1 to be a high voltage programming pin! This
// feature does not exist but it should be possible to implament this feature with some 
// external circuitry (a high voltage line controlled by a transistor from a2 for example)
//
// EPROM Size Switch header (optional!):
// This header allows access to the second pole of the EPROM Size switch.
// This does nothing but allows for further development using the size select switch
// This may be useful to someone implamenting a high voltage EPROM programming circuit...
///


#include <Shifter.h>

#define SER_Pin 4 //SER_IN
#define RCLK_Pin 3 //L_CLOCK
#define SRCLK_Pin 2 //CLOCK

// How many shift registers are in the chain:
//#define NUM_REGISTERS 3 // We use Arduino gpio pins for data now (instead of a third shift register)
#define NUM_REGISTERS 2

//initaize shifter using the Shifter library
Shifter shifter(SER_Pin, RCLK_Pin, SRCLK_Pin, NUM_REGISTERS); 

// Shift register WRITE pins (only needed if using the shift register boards for data writing):
// Using shift registers for the data lines means you can not read from these chips.
// int dq0 = 0;
// int dq1 = 1;
// int dq2 = 2;
// int dq3 = 3;
// int dq4 = 4;
// int dq5 = 5;
// int dq6 = 6;
// int dq7 = 7;

// Arduino Read/Write pins
// Using the arduino's normal digitial I/O pins means we can read and write from these chips.
int d0 = 5;
int d1 = 6;
int d2 = 7;
int d3 = 8;
int d4 = 9;
int d5 = 10;
int d6 = 11;
int d7 = 12;

// Address pins - These are not arduino ports! These are shifter ports! Out only!:
int a0 = 0; //8;	// 1:QA
int a1 = 1; //9;	// 1:QB
int a2 = 2; //10;	// 1:QC
int a3 = 3; //11;	// 1:QD
int a4 = 4; //12;	// 1:QE
int a5 = 5; //13;	// 1:QF
int a6 = 6; //14;	// 1:QG
int a7 = 7; //15;	// 1:QH

int a8 = 8; //16;	// 2:QA
int a9 = 9; //17;	// 2:QB
int a10 = 10; //18;	// 2:QC
int a11 = 11; //19;	// 2:QD
int a12 = 12; //20;	// 2:QE
int a13 = 13; //21;	// 2:QF
int a14 = 14; //22;	// 2:QG
//int a15 = 15; //23;		// 2:QH // No such thing on the 256k chip. But maybe there's one out there?


// Control pins:
int oe = 13;
int we = A0;
int ce = A1;

word address = 0; // Variable to hold memory addresses
byte read_byte = 0; // Variable to hold the byte data read from the chip
byte write_byte = 0; // Variable to hold the byte data to write to the chip


// Setup for serial noises:
String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete

int sep_char_idx = 0;
String command_part = "";

String address_part = "";
word real_address_part;

String byte_part = "";
byte real_byte_part;


void setup(){
  Serial.begin(115200);

  pinMode(oe, OUTPUT);
  pinMode(ce, OUTPUT);
  pinMode(we, OUTPUT);

  // Reserve space for the input string (shouldn't be this long but whatever...)
  inputString.reserve(200);

}

void loop(){
  sep_char_idx = 0;
  command_part = "";
  address_part = "";
  real_address_part = 0;
  byte_part = "";
  real_byte_part = 0;

  if (stringComplete) {
    // Serial.println(inputString); 

    inputString.trim();

    sep_char_idx = inputString.indexOf(':');
    if (sep_char_idx == -1) {
      Serial.println("Sorry, no command was given (missing the command separator, ':' )");
    } 
    else {
      // Serial.print(sep_char_idx);
      // Serial.println("trying...");
      command_part = inputString.substring(0, sep_char_idx);

      if (command_part == "write" || command_part == "read" || command_part == "read_m" || command_part == "set_all") {
        // Good. Our input is a valid command

        if (command_part.equalsIgnoreCase("read")){
          address_part = inputString.substring(sep_char_idx + 1);
          real_address_part = (word) address_part.toInt();

          // Read test:
          // Serial.print("Reading from address ");
          // Serial.println(real_address_part);
          // 
          // address = real_address_part;
          // set_address();
          // shifter.write();
          // Serial.println("Address Set!");
          // End read test!

          read_data(real_address_part);

        } 
        else if (command_part.equalsIgnoreCase("write")) {
          inputString = inputString.substring(sep_char_idx + 1);
          sep_char_idx = inputString.indexOf(':');

          //Serial.println(sep_char_idx);

          if (sep_char_idx != -1) {
            address_part = inputString.substring(0, sep_char_idx);
            real_address_part = (word) address_part.toInt();

            byte_part = inputString.substring(sep_char_idx + 1);
            real_byte_part = (byte) byte_part.toInt();

            //Serial.print("Writing the value ");
            //Serial.print(real_byte_part);
            //Serial.print(" to address ");
            //Serial.println(real_address_part);
            write_data(real_address_part, real_byte_part);
          } 
          else {
            Serial.println("Error: the address and data are formatted incorrectly");
          }

        } 
        else if (command_part.equalsIgnoreCase("read_m")) {
          address_part = inputString.substring(sep_char_idx + 1);
          real_address_part = (word) address_part.toInt();

          Serial.print("Reading first ");
          Serial.print(real_address_part);
          Serial.println(" addresses...");
          for (word i = 0; i <= real_address_part; i++) {
            read_data(i);
          }
        } 
        else if (command_part.equalsIgnoreCase("set_all")) {
          setup_for_write();
          address = 0xffff;
          write_byte = 0xff;
          set_address();
          set_data_for_write();
          shifter.write();

          Serial.println(" Set address and data for testing...");
          delay(60000);
          Serial.println(" One minute passed! falling out of test mode!");
        }

      } 
      else {
        Serial.print("Sorry, '");
        Serial.print(command_part);
        Serial.println("' is not a valid command");
      } 
    }

    // clear the string:
    inputString = "";
    stringComplete = false;
  }
}

void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read(); 
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    } 
  }
}

void write_data(word current_address, byte data) {
  setup_for_write();

  address = current_address;
  write_byte = data;

  set_address();
  set_data_for_write();
  shifter.write();

  delayMicroseconds(100);
  // delay(10);
  // Serial.println("Address and data set...");

  digitalWrite(ce, LOW);
  delayMicroseconds(75);  // DON'T CHANGE THIS VALUE!
  digitalWrite(ce, HIGH);   

  delayMicroseconds(200); 
  // delay(10);
  // Serial.println("Write at that address done...");
  Serial.print("w:");
  Serial.print(address);
  Serial.print(":");
  Serial.print(write_byte);
  Serial.print("\n");

  write_byte = 0;
  address = 0;
}


void read_data(word current_address) {
  setup_for_read();

  address = current_address;
  read_byte = 0;

  set_address();
  shifter.write();

  delayMicroseconds(100);
  // delay(10);
  // Serial.println("Address set...");

  digitalWrite(ce, LOW);
  delayMicroseconds(75);   
  // delay(10);
  // Serial.println("CE set LOW...");

  //Serial.println("Data should be ready now. Doing read...");
  bitWrite(read_byte, 0, digitalRead(d0));
  bitWrite(read_byte, 1, digitalRead(d1));
  bitWrite(read_byte, 2, digitalRead(d2));
  bitWrite(read_byte, 3, digitalRead(d3));
  bitWrite(read_byte, 4, digitalRead(d4));
  bitWrite(read_byte, 5, digitalRead(d5));
  bitWrite(read_byte, 6, digitalRead(d6));
  bitWrite(read_byte, 7, digitalRead(d7));


  // Spit out the address and the read data:
  Serial.print("r:");
  Serial.print(address);
  Serial.print(":");
  Serial.print(read_byte);
  Serial.print("\n");
  read_byte = 0; // make sure we go back to zero so our bits don't get lost

  delayMicroseconds(50); 
  // delay(10);
  digitalWrite(ce, HIGH);

  address = 0;
}

void setup_for_write() {
  // Pin mode for writing data
  pinMode(d0, OUTPUT);
  pinMode(d1, OUTPUT);
  pinMode(d2, OUTPUT);
  pinMode(d3, OUTPUT);
  pinMode(d4, OUTPUT);
  pinMode(d5, OUTPUT);
  pinMode(d6, OUTPUT);
  pinMode(d7, OUTPUT);

  digitalWrite(ce, HIGH); // we will switch this to low to write our data
  digitalWrite(we, LOW); // write enabled
  digitalWrite(oe, HIGH); // outputs disabled
}

void setup_for_read() {
  // Pin mode for reading data
  pinMode(d0, INPUT);
  pinMode(d1, INPUT);
  pinMode(d2, INPUT);
  pinMode(d3, INPUT);
  pinMode(d4, INPUT);
  pinMode(d5, INPUT);
  pinMode(d6, INPUT);
  pinMode(d7, INPUT);

  digitalWrite(ce, HIGH); // we will switch this to low to read our data
  digitalWrite(we, HIGH); // NO write
  digitalWrite(oe, LOW); // outputs enabled
}

void set_address() {
  shifter.setPin(a0, bitRead(address, 0));
  shifter.setPin(a1, bitRead(address, 1));
  shifter.setPin(a2, bitRead(address, 2));
  shifter.setPin(a3, bitRead(address, 3));
  shifter.setPin(a4, bitRead(address, 4));
  shifter.setPin(a5, bitRead(address, 5));
  shifter.setPin(a6, bitRead(address, 6));
  shifter.setPin(a7, bitRead(address, 7));
  shifter.setPin(a8, bitRead(address, 8));
  shifter.setPin(a9, bitRead(address, 9));
  shifter.setPin(a10, bitRead(address, 10));
  shifter.setPin(a11, bitRead(address, 11));
  shifter.setPin(a12, bitRead(address, 12));
  shifter.setPin(a13, bitRead(address, 13));
  shifter.setPin(a14, bitRead(address, 14));
  //shifter.setPin(a15, bitRead(address, 15));
}

// function using shift registers for write data
void set_data_for_write() {
  // shifter.setPin(dq0, bitRead(write_byte, 0));
  // shifter.setPin(dq1, bitRead(write_byte, 1));
  // shifter.setPin(dq2, bitRead(write_byte, 2));
  // shifter.setPin(dq3, bitRead(write_byte, 3));
  // shifter.setPin(dq4, bitRead(write_byte, 4));
  // shifter.setPin(dq5, bitRead(write_byte, 5));
  // shifter.setPin(dq6, bitRead(write_byte, 6));
  // shifter.setPin(dq7, bitRead(write_byte, 7));

  digitalWrite(d0, bitRead(write_byte, 0));
  digitalWrite(d1, bitRead(write_byte, 1));
  digitalWrite(d2, bitRead(write_byte, 2));
  digitalWrite(d3, bitRead(write_byte, 3));
  digitalWrite(d4, bitRead(write_byte, 4));
  digitalWrite(d5, bitRead(write_byte, 5));
  digitalWrite(d6, bitRead(write_byte, 6));
  digitalWrite(d7, bitRead(write_byte, 7));
}


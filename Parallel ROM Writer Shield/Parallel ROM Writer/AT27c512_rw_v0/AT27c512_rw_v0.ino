#include <Shifter.h>

#define SER_Pin 4 //SER_IN
#define RCLK_Pin 3 //L_CLOCK
#define SRCLK_Pin 2 //CLOCK

#define NUM_REGISTERS 3 //how many registers are in the chain


//initaize shifter using the Shifter library
Shifter shifter(SER_Pin, RCLK_Pin, SRCLK_Pin, NUM_REGISTERS); 


// 27C512 data WRITE pins (uses the shift register board):
int dq0 = 0;
int dq1 = 1;
int dq2 = 2;
int dq3 = 3;
int dq4 = 4;
int dq5 = 5;
int dq6 = 6;
int dq7 = 7;

byte output_byte = 0;
int ce = 13; // Only for programming (oe tied to 12.2v programming level)

//27C512 data READ pins (straight to arduino)
int d0 = 5;
int d1 = 6;
int d2 = 7;
int d3 = 8;
int d4 = 9;
int d5 = 10;
int d6 = 11;
int d7 = 12;

byte input_byte = 0;
int oe = 13; // Only for reading (ce tied to ground) 

// 27C512 chip address pins:
int a0 = 8;
int a1 = 9;
int a2 = 10;
int a3 = 11;
int a4 = 12;
int a5 = 13;
int a6 = 14;
int a7 = 15;
int a8 = 16;
int a9 = 17;
int a10 = 18;
int a11 = 19;
int a12 = 20;
int a13 = 21;
int a14 = 22;
//int a15 = 23;
word address = 0;

void setup(){
  Serial.begin(9600);
  
  pinMode(oe, OUTPUT);
  pinMode(ce, OUTPUT);
  
  //write_device();
  read_device();
  
}

void loop(){
  // no need to use the loop...
}

void write_device() {
  
  // Pin mode for writing data
  pinMode(d0, OUTPUT);
  pinMode(d1, OUTPUT);
  pinMode(d2, OUTPUT);
  pinMode(d3, OUTPUT);
  pinMode(d4, OUTPUT);
  pinMode(d5, OUTPUT);
  pinMode(d6, OUTPUT);
  pinMode(d7, OUTPUT);
  
  digitalWrite(ce, HIGH);
  Serial.println("Starting write in 5 seconds...");
  delay(5000); 
  
  Serial.println("Starting write...");
  
  for (int i = 0; i <= 2; i += 1) {
    address = i;
    output_byte = 1;
    set_address();
    set_data();
    shifter.write();
//    delay(100);
    delayMicroseconds(50);
    Serial.println("Address and data set...");
    
    
    digitalWrite(ce, LOW);
    delayMicroseconds(75);  // DON'T CHANGE THIS VALUE!
    digitalWrite(ce, HIGH);   
    
    delayMicroseconds(50); 
    Serial.println("Write at that address done...");
    Serial.println("");

  }
}

void read_device() {
  
  // Pin mode for reading data
  pinMode(d0, INPUT);
  pinMode(d1, INPUT);
  pinMode(d2, INPUT);
  pinMode(d3, INPUT);
  pinMode(d4, INPUT);
  pinMode(d5, INPUT);
  pinMode(d6, INPUT);
  pinMode(d7, INPUT);
  
  digitalWrite(oe, HIGH);
  Serial.println("Starting read in 5 seconds...");
  delay(5000); 
  
  Serial.println("Starting read...");
  
  for (int i = 0; i <= 100; i += 1) {
    address = i;
    set_address();
    shifter.write();
//    delay(100);
    delayMicroseconds(100);
//    Serial.println("Address set...");
    

    digitalWrite(oe, LOW);
//    delay(100);
    delayMicroseconds(100);   
//    Serial.println("CE set LOW...");


//    Serial.println("Data should be ready now. Doing read...");
    read_data();
//    delay(100);
    delayMicroseconds(100); 
//    Serial.println("Read done. Setting OE high for next read...");
    digitalWrite(oe, HIGH);

  }
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
void set_data() {
  shifter.setPin(dq0, bitRead(output_byte, 0));
  shifter.setPin(dq1, bitRead(output_byte, 1));
  shifter.setPin(dq2, bitRead(output_byte, 2));
  shifter.setPin(dq3, bitRead(output_byte, 3));
  shifter.setPin(dq4, bitRead(output_byte, 4));
  shifter.setPin(dq5, bitRead(output_byte, 5));
  shifter.setPin(dq6, bitRead(output_byte, 6));
  shifter.setPin(dq7, bitRead(output_byte, 7));
  
  digitalWrite(d0, bitRead(output_byte, 0));
  digitalWrite(d1, bitRead(output_byte, 1));
  digitalWrite(d2, bitRead(output_byte, 2));
  digitalWrite(d3, bitRead(output_byte, 3));
  digitalWrite(d4, bitRead(output_byte, 4));
  digitalWrite(d5, bitRead(output_byte, 5));
  digitalWrite(d6, bitRead(output_byte, 6));
  digitalWrite(d7, bitRead(output_byte, 7));
}

void read_data() {
  
  bitWrite(input_byte, 0, digitalRead(d0));
  bitWrite(input_byte, 1, digitalRead(d1));
  bitWrite(input_byte, 2, digitalRead(d2));
  bitWrite(input_byte, 3, digitalRead(d3));
  bitWrite(input_byte, 4, digitalRead(d4));
  bitWrite(input_byte, 5, digitalRead(d5));
  bitWrite(input_byte, 6, digitalRead(d6));
  bitWrite(input_byte, 7, digitalRead(d7));
  
  Serial.print(address);
  Serial.print(": ");
  Serial.println(input_byte);
  input_byte = 0;
}

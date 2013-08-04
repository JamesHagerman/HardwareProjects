
#include <OneWire.h>

const int sensors = 1; //number of temperature sensors on the bus
int sensors_pin = 2; //the pin where the bus its connected to arduino
uint8_t sensors_address[sensors][8]; //here will store the sensors addresses for later use

int relayPin = 13;
double tooCold = 1.67; // 35 degrees F
double tooWarm = 2.77; // 37 degrees F
unsigned long time;
unsigned long resumeTime;

OneWire  sensor_bus(sensors_pin);

float get_temperature (uint8_t *address);

void setup(void) {
  Serial.begin(9600);
  int x,y,c=0;
  Serial.println("Starting to look for sensors...");
  for(x=0;x<sensors;x++){
    if(sensor_bus.search(sensors_address[x]))
      c++;
  }
  if(c > 0) {
    Serial.println("Found this sensors : ");
    for(x=0;x<sensors;x++) {
      Serial.print("\tSensor ");
      Serial.print(x+1);
      Serial.print(" at address : ");
      for(y=0;y<8;y++){
        Serial.print(sensors_address[x][y],HEX);
        Serial.print(" ");
      }
      Serial.println();
    }
  } else {
    Serial.println("Didn't find any sensors");
  }
  
  pinMode(relayPin, OUTPUT);
}

void loop(void) {
    for(int x=0;x<sensors;x++) {
      
      float nowTemp = get_temperature(sensors_address[x]);
      
//      Serial.print("Sensor ");
//      Serial.print(x+1);
//      Serial.print(" ");
//      Serial.print(nowTemp);
//      Serial.println(" C");
      
      time = millis(); // Get current time
      
      if (time > resumeTime || nowTemp > tooWarm) {
        Serial.print(time/1000);
        
        if (nowTemp < tooCold) {
          Serial.print(": Temperature (");
          Serial.print(nowTemp);
          Serial.println(") too cold! Turning off for 10 minutes!");
          
          resumeTime = time + 600000; // 10 minute wait
          
          digitalWrite(relayPin, LOW);
        } else {
          Serial.print(": Temperature (");
          Serial.print(nowTemp);
          Serial.print(") above cutoff (");
          Serial.print(tooCold);
          Serial.println(")! Turning on!");
          digitalWrite(relayPin, HIGH);
         resumeTime = time; 
        }
        
      } else {
        Serial.print("FROZEN! Warming up: (time is now ");
        Serial.print(time/1000);
        Serial.print(" we will wait until ");
        Serial.print(resumeTime/1000);
        Serial.print(") ");
        Serial.print("temp is: ");
        Serial.println(nowTemp);
      }
      
    }
    delay(5000);
}

float get_temperature(uint8_t *address) {
  byte data[12];
  int x;
  sensor_bus.reset();
  sensor_bus.select(address);
  sensor_bus.write(0x44,1);
  
  sensor_bus.reset();
  sensor_bus.select(address);
  sensor_bus.write(0xBE,1);
  
  for(x=0;x<9;x++) {
    data[x] = sensor_bus.read();
  }
    
  int tr = data[0];
  if(data[1] > 0x80) {
   tr = !tr+1;
   tr = tr*-1;
  }
  int cpc = data[7];
  int cr = data[6];
  
  tr = tr>>1;
  
  float temperature = tr - (float)0.25+(cpc-cr)/(float)cpc;
  
  byte MSB = data[1];
  byte LSB = data[0];

  float tempRead = ((MSB << 8) | LSB); //using two's compliment
  float TemperatureSum = tempRead / 16;

  return TemperatureSum;
}

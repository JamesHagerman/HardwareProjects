#include <IRremote.h>
IRsend irsend;

#define TIMER_ENABLE_PWM     (TCCR2A |= _BV(COM2B1))
#define TIMER_DISABLE_PWM    (TCCR2A &= ~(_BV(COM2B1)))

int ftdiPin = 5; // Data input pin from computer -> FTDI -> RCX
int irPower = 6; // Power pin of IR Receiver

// NOTE: IRremote.h sets pin 3 as the IR LED output

void setup() {
  pinMode(ftdiPin, INPUT);
  pinMode(irPower, OUTPUT);
  digitalWrite(irPower, HIGH); 
  irsend.enableIROut(38);
}

void loop() {
  if (digitalRead(ftdiPin) == LOW) {
    // Turn off IR Receiver
    digitalWrite(irPower, LOW);
    // Turn on IR PWM Output
    TIMER_ENABLE_PWM;
  } else {
    // Turn on IR Receiver
    digitalWrite(irPower, HIGH);
    // Turn off the IR PWM Output
    TIMER_DISABLE_PWM;
  }
}

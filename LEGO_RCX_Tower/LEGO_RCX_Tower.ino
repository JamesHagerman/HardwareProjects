#include <IRremote.h>
IRsend irsend;

#define TIMER_ENABLE_PWM     (TCCR2A |= _BV(COM2B1))
#define TIMER_DISABLE_PWM    (TCCR2A &= ~(_BV(COM2B1)))

int ftdiPin = 6;
int irPower = 7;

void setup() {
  pinMode(ftdiPin, INPUT);
  pinMode(irPower, OUTPUT);
  digitalWrite(irPower, HIGH); 
  irsend.enableIROut(38);
}

void loop() {
  if (digitalRead(ftdiPin) == LOW) {
    digitalWrite(irPower, LOW);
    TIMER_ENABLE_PWM;
  } else {
    digitalWrite(irPower, HIGH);
    TIMER_DISABLE_PWM;
  }
}

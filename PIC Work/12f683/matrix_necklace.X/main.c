/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <htc.h>           /* Global Header File */
#include <stdint.h>        /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */

#include "system.h"        /* System funct/params, like osc/peripheral config */
#include "user.h"          /* User funct/params, such as InitApp */

// PIC12F683 Configuration Bit Settings
#include <xc.h>
__CONFIG(FOSC_INTOSCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_ON);

// Needed for __delay_ms and __delay_us
#define _XTAL_FREQ 4000000  

//#use rs232 (baud=9600, xmit=PIN_A6, rcv=PIN_A3, parity=N, bits=8)

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

/* i.e. uint8_t <variable_name>; */

// Shadow variable to hold port values:
//uint8_t sGPIO = 0;
union {
    uint8_t port;
    struct {
        unsigned GP0                    :1;
        unsigned GP1                    :1;
        unsigned GP2                    :1;
        unsigned GP3                    :1;
        unsigned GP4                    :1;
        unsigned GP5                    :1;
    };
} sGPIO;

//void setPin(union sGPIO *some_pin, bool value) {
//    value -> *some_pin;
//    GPIO = sGPIO.port;
//}
#define I { \
0x7e, \
0x7e, \
0x18, \
0x18, \
0x18, \
0x18, \
0x7e, \
0x7e  \
}
#define HEART { \
0x66, \
0xff, \
0xff, \
0xff, \
0x7e, \
0x7e, \
0x3c, \
0x18  \
}
#define TARDIS { \
0x08, \
0x1c, \
0x3e, \
0x2a, \
0x3e, \
0x2e, \
0x3e, \
0x7f  \
}
#define SPACE { \
0x00, \
0x00, \
0x00, \
0x00, \
0x00, \
0x00, \
0x00, \
0x00  \
}
int pattern_index = 0;
const int numPatterns = 4;
const unsigned int patterns[4][8] = {
  // I, SPACE, HEART, SPACE, K, a, y, my_l, a, SPACE, SPACE
	I, HEART, TARDIS, SPACE
};

//int dataIn    = sGPIO.GP0;
//int load      = sGPIO.GP1;
//int clock     = sGPIO.GP2;

int i = 0;
int j = 0;
int shifter = 0;

int brightness = 0x01; // Make the display as dim as possible digitally...

// Define max7219 registers
const unsigned int max7219_reg_noop        = 0x00;
const unsigned int max7219_reg_digit0      = 0x01;
const unsigned int max7219_reg_digit1      = 0x02;
const unsigned int max7219_reg_digit2      = 0x03;
const unsigned int max7219_reg_digit3      = 0x04;
const unsigned int max7219_reg_digit4      = 0x05;
const unsigned int max7219_reg_digit5      = 0x06;
const unsigned int max7219_reg_digit6      = 0x07;
const unsigned int max7219_reg_digit7      = 0x08;
const unsigned int max7219_reg_decodeMode  = 0x09;
const unsigned int max7219_reg_intensity   = 0x0a;
const unsigned int max7219_reg_scanLimit = 0x0b;
const unsigned int max7219_reg_shutdown    = 0x0c;
const unsigned int max7219_reg_displayTest = 0x0f;

void digitalWrite(int port, int value) {
    port = value;
    GPIO = sGPIO.port;
}

void putByte(unsigned int data) {
  unsigned int i = 8;
  unsigned int mask;
  while(i > 0) {
    mask = 0x01 << (i - 1);      // get bitmask

//    digitalWrite( clock, 0);   // tick
    sGPIO.GP2 = 0;
    GPIO = sGPIO.port;
    
    if (data & mask) {           // choose bit
//      digitalWrite(dataIn, 1);// send 1
        sGPIO.GP0 = 1;
        GPIO = sGPIO.port;
    } else {
//      digitalWrite(dataIn, 0); // send 0
        sGPIO.GP0 = 0;
        GPIO = sGPIO.port;
    }
//    digitalWrite(clock, 1);   // tock
    sGPIO.GP2 = 1;
    GPIO = sGPIO.port;
    --i;                         // move to lesser bit
  }
}

void maxSingle( unsigned int reg, unsigned int col) {
//  digitalWrite(load, LOW);       // begin
  sGPIO.GP1 = 0;
  GPIO = sGPIO.port;
  putByte(reg);                  // specify register
  putByte(col);  //((data & 0x01) * 256) + data >> 1);   // put data
//  digitalWrite(load,HIGH);
  sGPIO.GP1 = 1;
  GPIO = sGPIO.port;
}

void showPattern(int pattern) {
    unsigned int flipper = 0;
    for (int i = 0; i < 8; i++) {
        flipper = patterns[pattern][i];
        flipper = ((flipper * 0x0802LU & 0x22110LU) | (flipper * 0x8020LU & 0x88440LU)) * 0x10101LU >> 16;
        maxSingle(i + 1, flipper);
        flipper = 0;
    }
}

void wipeScreen() {
    for (i = 1; i <= 8; i++) {
        shifter = 1;
        for (j = 1; j <= 9; j++) {
            shifter = 0x01 << (j - 1);
            if (shifter >= 0xff) {
                shifter = 0;
            }
            maxSingle(i, shifter);
            __delay_ms(5);
        }
    }
}

/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/

uint8_t main(void)
{
    /* Configure the oscillator for the device */
    ConfigureOscillator();

    /* Initialize I/O and Peripherals for application */
    InitApp();

    /* TODO <INSERT USER APPLICATION CODE HERE> */
    
    //GPIObits.GP1 = 1;

    maxSingle(max7219_reg_scanLimit, 0x07);   // needs to be 0x07 for a matrix display
    maxSingle(max7219_reg_decodeMode, 0x00);  // using an led matrix (not 8 segment text displays here...)
    maxSingle(max7219_reg_shutdown, 0x01);    // not in shutdown mode
    maxSingle(max7219_reg_displayTest, 0x00); // no display test

    for (i = 1; i <= 8; i++) { // empty registers, turn all LEDs off
        maxSingle(i, 0);
    }

    maxSingle(max7219_reg_intensity, brightness & 0x0f);    // the first 0x0f is the value you can set

    while(1)
    {
        

        //GPIObits.GP2=1;
//        sGPIO.GP4 = 1;
//        GPIO = sGPIO.port;
//        //delay_ms(500); // 2.27 = 440 hertz
//        __delay_ms(250);
//        sGPIO.GP4 = 0;
//        GPIO = sGPIO.port;
//        //delay_ms(500);
//        __delay_ms(250);
//
//        sGPIO.GP1 = 1;
//        GPIO = sGPIO.port;
//        //delay_ms(500); // 2.27 = 440 hertz
//        __delay_ms(100);
//        sGPIO.GP1 = 0;
//        GPIO = sGPIO.port;
//        //delay_ms(500);
//        __delay_ms(100);

//        if (GPIObits.GP3 == 0) {
//            sGPIO.GP1 = 0;
//            GPIO = sGPIO.port;
//        }
//         if (GPIObits.GP3 == 1) {
//            sGPIO.GP1 = 1;
//            GPIO = sGPIO.port;
//        }


        /*
         * Test program here:
         */
//        for (i = 1; i <= 8; i++) {
//            shifter = 1;
//            for (j = 1; j <= 9; j++) {
//                shifter = 0x01 << (j - 1);
//                if (shifter >= 0xff) {
//                    shifter = 0;
//                }
//                maxSingle(i, shifter);
//                __delay_ms(10);
//            }
//        }
        
        /*
         * Actual program is here:
         */



        showPattern(pattern_index);
        __delay_ms(500);
        __delay_ms(250);

        if (pattern_index == 0) {
            pattern_index = 1;
//            wipeScreen();
        } else if (pattern_index == 1) {
            pattern_index = 2;
//            wipeScreen();
        } else if (pattern_index == 2) {
            pattern_index = 0;
            __delay_ms(500);
            __delay_ms(500);
            wipeScreen();
        }
        //else if (pattern_index == 3) {
//            pattern_index = 0;
//            wipeScreen();// Don't wipe the SPACE
//            __delay_ms(10);
//        }
//        } else if (pattern_index == 4) {
//            pattern_index = 0;
//        }

//        __delay_ms(50);

    }
    return 0;

}


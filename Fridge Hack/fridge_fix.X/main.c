/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <htc.h>           /* Global Header File */
#include <stdint.h>        /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */
#include <stdio.h>  // needed for printf

#include "system.h"        /* System funct/params, like osc/peripheral config */
#include "user.h"          /* User funct/params, such as InitApp */


// PIC12F683 Configuration Bit Settings
#include <xc.h>
__CONFIG(FOSC_INTOSCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_ON);

// Needed for __delay_ms and __delay_us
#define _XTAL_FREQ 4000000  

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

// Shadow variable to hold port values:
//uint8_t sGPIO = 0;
union {
    uint8_t port;
    struct {
        unsigned GP0                    :1;
        unsigned GP1                    :1; // serial transmit @9600 baud
        unsigned GP2                    :1; // relay control: high = relay closed
        unsigned GP3                    :1; 
        unsigned GP4                    :1; // temperature input
        unsigned GP5                    :1; // alarm!!
    };
} sGPIO;

// We have to define the shadow variable for the GPIO pins before we include the
//  one_wire library...
#include "one_wire.h"   /* One-wire library for the DS18B20 temperature sensor */


/* Software UART delay timings*/

//DelayTXBitUART delay for[(2 * f)/(4 * baud) + 1]/2 - 12 cycles --- f = 48MHz
// wtf. This is the thing we need:
// delay time = (((2*OSC_FREQ)/(4*BAUDRATE))+1)/2
//              (((2*_XTAL_FREQ)/(4*9600)) + 1 )/2
//              (((2*4000000)/(4*9600))+1)/2
//              104

void DelayTXBitUART(void)
{
    // 416 = 373 micro seconds
    // 410 = 368 micro seconds
    // 300 = 276 micro seconds
    // 41 = 57
    // 80 = 90
    // 77 = 88 micro seconds. This is what we need!
    _delay(77); // 9600 baud

    // 88 micro seconds per bit is needed for 9600 baud
    // 176 micro seconds per 2 bits.
    // 5.682kHz
    
    // LSB IS SENT FIRST!
    // I should be getting back 'a' which is 97 in decimal or:
    // 0110 0001 MSB first
    // 1000 0110 LSB first

}

////DelayRXHalfBitUART delay for[(2 * f)/(8 * baud) + 1]/2 - 9 cycles
//void DelayRXHalfBitUART(void)
//{
//    _delay(148); //38400 baud: 147.8 cycles
//}
//
////DelayRXBitUART delay for[(2 * f)/(4 * baud) + 1]/2 - 14 cycles
//void DelayRXBitUART()
//{
//    _delay(299); //38400 baud: 299 cycles
//}

void putch(char c) {

    unsigned char bitcount = 8;

    //start
    sGPIO.GP1 = 0;   // falling edge means "start bit"
    GPIO = sGPIO.port;
    DelayTXBitUART();

    while (bitcount--) {
        sGPIO.GP1 = (c & 0x01);
        GPIO = sGPIO.port;
        DelayTXBitUART();
        c>>=1;
    }
    //stop
    sGPIO.GP1 = 1;   // go back to "holding pattern of "high"
    GPIO = sGPIO.port;
    DelayTXBitUART();

}

/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/

/* DS18B20 one-wire temperature sensor stuff:
 * Temperature sensor ids:
 * 28 A5 A1 46 1 0 0 15 - unused currently
 * 28 3F 7E 46 1 0 0 5A - current fridge unit
 */
unsigned char DS18B20_A[]={0x28, 0xA5, 0xA1, 0x46, 0x01, 0x00, 0x00, 0x15, NULL}; // unused currently
unsigned char tmp = 0; // default to "sensor not found"
int current_temp;
//float watts;

uint8_t main(void)
{
    /* Configure the oscillator for the device */
    ConfigureOscillator();

    /* Initialize I/O and Peripherals for application */
    InitApp();


    /* Delay start so things settle*/
    __delay_ms(1000);
    __delay_ms(1000);
    __delay_ms(1000);
    printf("\n\n\n\n                           \n"); // clear out the buffer...?
    printf("Fridge fix by James Hagerman\n");

    tmp = reset_ow();
    if (tmp == 1) {
        printf("Sensor not found!!\n");
    } else {
        printf("Sensor found!\n");
    }

    while(1)
    {
        __delay_ms(5000); // Test temperatures every five seconds

        current_temp = read_temperature_ow_18B20(DS18B20_A);
//        watts = conv * 0.0625; // Oops. not enough space for floats!
        // Because we can't convert to float onboard (not enough space) we will
        //  use the integer value from the sensor to determine the cutoffs:
        //  value of 26 converted to degrees c (26*0.0625) = 1.625 C (34.925 F)
        //  value of 44 converted to degrees c (44*0.0625) = 2.75 C (36.95 F)
        //
        // These values (26 and 44) will be the lower and upper limits of the
        //  fridge controllers allowable range. Lower then this, the fridge will
        //  will be switched of. Higher then this, the fridge will be on.
        //
        // We will also build in an audible alarm past a value of 70.
        //  value of 70 converted to degrees c (70*0.0625) = 4.375 C (39.875 F)
        //
        // This alarm will be turned off when the fridge goes below 44 again...

        printf("Temperature is: %i\n", current_temp);

        if (current_temp < 26) {
            printf(" Too cold! Turning off!\n");
            sGPIO.GP2 = 0;
            sGPIO.GP5 = 0;
            GPIO = sGPIO.port;
        }
        if (current_temp > 44) {
            printf(" Too warm! Turning on!\n");
            sGPIO.GP2 = 1;
            sGPIO.GP5 = 0;
            GPIO = sGPIO.port;
        }
        if (current_temp > 70) {
            printf(" WAY too warm! ALARM!!\n");
            sGPIO.GP2 = 1;
            sGPIO.GP5 = 1;
            GPIO = sGPIO.port;
        }



//        //GPIObits.GP2=1;
//        sGPIO.GP2 = 1;
//        GPIO = sGPIO.port;
//        //delay_ms(500); // 2.27 = 440 hertz
//        __delay_ms(100);
//        sGPIO.GP2 = 0;
//        GPIO = sGPIO.port;
//        //delay_ms(500);
//        __delay_ms(100);

    }
    return 0;

}


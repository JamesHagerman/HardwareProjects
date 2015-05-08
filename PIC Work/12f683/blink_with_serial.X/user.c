/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <xc.h>             /* General Includes */
#include <stdint.h>         /* For uint8_t definition */
#include <stdbool.h>        /* For true/false definition */

#include "user.h"

/******************************************************************************/
/* User Functions                                                             */
/******************************************************************************/

/* <Initialize variables in user.h and insert code for user algorithms.> */

void InitApp(void)
{
    /* TODO Initialize User Ports/Peripherals/Project here */

    /* Setup analog functionality and port direction */

//    TRISIO = 0x00;
//    TRISIO = 0b11111000; // 0, 1, 2: outputs. all else are inputs

    

    TRISIObits.TRISIO0 = 1; // pin 7    LPC Demo Board Potentiometer
    TRISIObits.TRISIO1 = 0; // pin 6    Serial Out
    TRISIObits.TRISIO2 = 0; // pin 5    LPC RA2
    TRISIObits.TRISIO3 = 1; // pin 4    LPC Demo Board button
//    TRISIObits.TRISIO4 = 0; // pin 3    LPC RA4 SET TO ANALOG! See below
    TRISIObits.TRISIO5 = 0; // pin 2    LPC RA5
    
    //==================
    // Let's read in on AN3 (GP4/pin 3 on the chip)!
    // GPIO has to be set up first:
    TRISIObits.TRISIO4 = 1; // Set it as an input..
    ANSELbits.ANS3 = 1; // ... an analog input
    
    // Then we set the conversion clock speed:
    ANSELbits.ADCS = 5; //0b101; // 101 is Fosc/16 = 2.0 uSec per converted bit
    ADCON0bits.ADFM = 1; // right justify so LSB is in 1's place of ADRESL
    ADCON0bits.VCFG = 0; // Use Vdd as voltage reference instead of Vref
    ADCON0bits.CHS = 3; //0b11; // connect AN3 to the converter
    
    
    /* Initialize peripherals */

    /* Enable interrupts */
}


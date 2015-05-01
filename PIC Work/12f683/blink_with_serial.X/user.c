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

    // LPC LEDs
    // 

    TRISIObits.TRISIO0 = 1; // LPC Demo Board Potentiometer
    TRISIObits.TRISIO1 = 0; // Serial Out
    TRISIObits.TRISIO2 = 0; // LPC RA2
    TRISIObits.TRISIO3 = 1; // LPC Demo Board button
    TRISIObits.TRISIO4 = 0; // LPC RA4
    TRISIObits.TRISIO5 = 0; // LPC RA5

    /* Initialize peripherals */

    /* Enable interrupts */
}


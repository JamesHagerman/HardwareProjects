/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <htc.h>            /* HiTech General Includes */
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
    OPTION_REGbits.nGPPU = 0;
    //WPUbits.WPU4 = 1;

    /* Setup analog functionality and port direction */
    ANSEL = 0x00;  // make all pins digital *NEEDED FOR DIGITAL I/O*
    
    //CMCON0 = 0x07;
    //T1CON = 0b00000000;
    
    TRISIO = 0b11011001; // pin 1, 2, 5 as output, all else as input.
    /*
     * GP1 = serial
     * GP2 = relay
     * GP5 = alarm
     *
     * GP4 = sensor I/O
     */

    /* Initialize peripherals */

    /* Enable interrupts */
}


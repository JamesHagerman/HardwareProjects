/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <plib.h>            /* Include to use PIC32 peripheral libraries     */
#include <stdint.h>          /* For uint32_t definition                       */
#include <stdbool.h>         /* For true/false definition                     */
#include "user.h"            /* variables/params used by user.c               */

/******************************************************************************/
/* User Functions                                                             */
/******************************************************************************/

/* TODO Initialize User Ports/Peripherals/Project here */

void InitApp(void)
{
    /* Setup analog functionality and port direction */

    /* Initialize peripherals */

    // TRIS*CLR -> clears a pin/bit in the * port
    // TRIS*SET -> sets a pin/bit in the * port
    // TRIS*INV -> inverts a pin/bit in the * port

    // Set the LED's on the UBW32 as outputs:
    // RE0 -> yellow
    // RE1 -> red
    // RE2 -> white
    // RE3 -> green

//    TRISECLR = 0x0F; // This is the hard way
    // The following are the easy way:
    _TRISE0 = 0; // Cleared pins, set to zero, are configured as outputs
    _TRISE1 = 0;
    _TRISE2 = 0;
    _TRISE3 = 0;


    // Set the PRG and USER buttons on the UBW32 as an inputs:
    // This is the hard way:
//    TRISESET = 0x00C0; // This sets pin RE7 and RE6: 1100 0000 = C0
    
    // This is the easy way:
    _TRISE6 = 1; // Set pins, set to one, are configured as inputs
    _TRISE7 = 1;
    


    // Set pin RD8 as an output, could be written as TRISD = 0xFEFF;
    // but takes more clock cycles to perform.
//    TRISDCLR = 0x0100;

    

    
    /****** PWM Intialization*******************************************/
    // configure RD0 as output for PWM
    // PWM mode, Single output, Active High
    
//    TRISDCLR = 0x00000001;
//    OC1R 	 = 0;
//    OC1CON   = 0x0000;
//    OC1RS    = 0;
//    OC1CON   = 0x0006;
//    OC1CONSET = 0x8000;
}

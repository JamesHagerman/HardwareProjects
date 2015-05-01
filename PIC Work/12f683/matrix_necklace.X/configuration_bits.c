/******************************************************************************/
/* Main Files to Include                                                      */
/******************************************************************************/

#include <htc.h>            /* HiTech General Includes */

/******************************************************************************/
/* Configuration Bits                                                         */
/*                                                                            */
/* Refer to your Hi-Tech User Manual in the PICC installation directory       */
/* /doc folder for more information on filling in configuration bits.         */
/* In addition, configuration bit mnemonics can be found in your              */
/* PICC\version\include\<processor name>.h file for your device.  For         */
/* additional information about what the hardware configurations mean in      */
/* terms of device operation, refer to the device datasheet.                  */
/*                                                                            */
/******************************************************************************/

/* TODO Fill in your config bits here.  Remove #if 0 to embed config words.   */

#if 0

/* General syntax for configuration word 1 - Check your device .h file
for an up to date listing of available macros. */
__CONFIG(FOSC_INTOSC & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & BOREN_OFF);

/* If the device has multiple configuration words, the second macro defines
the second configuration word.  Again check your device .h file
for an up to date listing of available macros. */
__CONFIG(WRT_OFF & PLLEN_OFF & STVREN_OFF & BORV_19 & LVP_OFF);

#endif

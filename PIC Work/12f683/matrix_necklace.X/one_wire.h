/* 
 * File:   one_wire.h
 * Author: jamis
 *
 * Created on November 4, 2012, 10:08 PM
 */

#ifndef ONE_WIRE_H
#define	ONE_WIRE_H

#ifdef	__cplusplus
extern "C" {
#endif

//************************************************************************/
  // Routines for one-wire protocol (DS18B20)
  // Rel. 1.0 Nov 2006
  // Eduardo Barajas P.
  // TRIS_DQ --> DDRCbits.RC2   // TRIS for DQ
  // DQ  --> PORTCbits.RC2   // DATA pin for DQ
  #define TRIS_DQ  DDRCbits.RC2   // TRIS for DQ of DS18B20
  #define DQ  PORTCbits.RC2  // DATA pin for DQ of DS18B20
  // #define TRIS_DQ DDRCbits.RC1   // TRIS for DQ of DS18B20
  // #define DQ  PORTCbits.RC1  // DATA pin for DQ of DS18B20

  unsigned char reset_ow(void)  //Reset and detect DS8B20
  {
      unsigned char presence;

      TRIS_DQ = 1;  // Start with line high
      DQ = 0;
      TRIS_DQ = 0; // Make DQ low
      Delay100TCYx(5); // Drive low for 500us
      TRIS_DQ = 1;
      Delay10TCYx(7); // Release line and wait 70us
      presence = DQ;
      Delay10TCYx(43); // wait 430us after presence pulse
      return presence;  // 0=presence; 1=No Part connected
    }

  unsigned char read_bit_ow(void)  // Read single bit of DS18B20
  {
      DQ = 0;
      TRIS_DQ = 0; // Make DQ low
      Nop();          // Wait 1 uS
      TRIS_DQ = 1; // Make DQ high
      Delay10TCYx(1); // Delay 10 uS from start of timeslot
      Nop();          // Wait 1 uS
      Nop();          // Wait 1 uS
      Nop();          // Wait 1 uS
      Nop();          // Wait 1 uS
      return DQ; //Return value of DQ line
      }

  unsigned char read_byte_ow(void)  //Read one byte from the one-wire bus (18B20)
  {
      unsigned char i;
      unsigned char value = 0;

      for( i=0; i<8; i++) {
          if(read_bit_ow()) value |= (0x01<<i);  // Reads byte in, one bit at time and then shifts it left
          Delay10TCYx(12); // Delay 120uS for rest of timeslot
        }
      return value;
      }

  void write_bit_ow(char bitval)  // Writes a bit to the one-wire bus (18B20) passed in bitval.
  {
      DQ = 0;
      TRIS_DQ = 0; // Make DQ low to start timeslot
      Nop();          // Wait 1 uS
      if(bitval == 1)
          TRIS_DQ = 1; // return DQ high if write 1
      Delay10TCYx(10); // Delay 100uS for rest of timeslot
      TRIS_DQ = 1; // return DQ high
      }

  void write_byte_ow(char val) {     // Writes a byte to the one-wire bus
      unsigned char i;
      unsigned char temp;

      for( i=0; i<8; i++) { // Writes byte, one bit at a time
          temp = val>>i;  // Shifts val right 'i' spaces
          temp &= 0x01;  // Copy that bit to temp
          write_bit_ow(temp);  //Write bit in temp into one-wire bus
          }
      Delay10TCYx(10); // Delay 100uS for rest of timeslot
      }

  /************************************************************************/
  /************************************************************************/
  // Read SCRATCHPAD and return temperature for DS18B20 ONLY!!!
  unsigned int read_temperature_ow_18B20(char *ID) {
    unsigned int temperature;
    unsigned char dat[9], i;

      reset_ow();
      write_byte_ow(0x55); //Match Rom
      for(i=0; i<8; i++)
          write_byte_ow(ID[i]);
      write_byte_ow(0x44);  // Start conversion
      while(read_bit_ow()==0); // Wait for end of conversion
          reset_ow();
      write_byte_ow(0x55); //Match Rom
      for(i=0; i<8; i++)
          write_byte_ow(ID);
      write_byte_ow(0xBE); //Read Scratch
      for(i=0; i<9; i++)
          dat=read_byte_ow();
      temperature = dat[0] + dat[1] * 256;

      return temperature;
      }

  /************************************************************************/


#ifdef	__cplusplus
}
#endif

#endif	/* ONE_WIRE_H */


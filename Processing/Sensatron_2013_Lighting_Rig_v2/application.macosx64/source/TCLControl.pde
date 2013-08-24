/*
 Make sure you've loaded the correct FTDI driver:
 retina machine:
   cd /Users/jhagerman/dev/processing/other peopels stuff/p9813/processing
 original 13"
   cd /Volumes/Keket/Users/jamis/dev/Circuits_MPUs/FTDI\ Hacks/TCL\ Lights/p9813/processing
 for arduino: make load
 for bitbanging: make unload
 
 My wiring rig pinout:
   g = blue   = ground
   c = yellow = clock
   + = red/nc = positive 5 volts
   d = green  = data
  nc = not connected
  nc = not connected
*/

// TCL Library setup
import TotalControl.*;

// The TotalControl processing library doesn't define the FTDI pins so we do:
short TC_FTDI_TX  = 0x01;  /* Avail on all FTDI adapters,  strand 0 default */
short TC_FTDI_RX  = 0x02;  /* Avail on all FTDI adapters,  strand 1 default */
short TC_FTDI_RTS = 0x04;  /* Avail on FTDI-branded cable, strand 2 default */
short TC_FTDI_CTS = 0x08;  /* Avail on all FTDI adapters,  clock default    */
short TC_FTDI_DTR = 0x10;  /* Avail on third-party cables, strand 2 default */
short TC_FTDI_DSR = 0x20;  /* Avail on full breakout board */
short TC_FTDI_DCD = 0x40;  /* Avail on full breakout board */
short TC_FTDI_RI  = 0x80;  /* Avail on full breakout board */

class TCLControl {
  
  // TCL Objects:
  TotalControl tc; // TCL data control object itself
  int[] tclArray; // Actual pixel array
  int[] remap; // Remap lookup table
  
  TCLControl() {
    println("Initalizing the TCL Library...");
    tclArray = new int[totalPixels];
    remap = new int[strandCount * pixelsOnStrand];
    
    // Override the default pin outs:
    // This is clock. We don't want to override it:
    println("Customizing pinouts for the Sensatron...");
    //tc.setStrandPin(x,TC_FTDI_CTS);
    tc.setStrandPin(0,TC_FTDI_TX); // default
    tc.setStrandPin(1,TC_FTDI_RX); // default
    tc.setStrandPin(2,TC_FTDI_DTR); // spliting dtr and rts
    
    // Custom lines for the ftdi breakout
    tc.setStrandPin(3,TC_FTDI_RTS);
    tc.setStrandPin(4,TC_FTDI_RI);
    tc.setStrandPin(5,TC_FTDI_DSR);
    tc.setStrandPin(6,TC_FTDI_DCD);
    println("Done customizing pinouts.");
    
    println("Trying to open the FTDI device for bitbanging...");
    int status = tc.open(strandCount, pixelsOnStrand);
    if (status != 0) {
      tc.printError(status);
//      exit();
      println("Continuing without light output!");
    } else {
      println("Device opened.");
    }
  
    buildRemapArray();
  }
  
  void buildRemapArray() {
    println("Building remap array...");
    for (int i = 0; i < STRANDS * STRAND_LENGTH; i++) {
      remap[i] = i;
    }
    println("Done building remap array.");
  }
  
  // This will actually send the data in tclArray out to the lights using the remap table:
  void sendLights() {
    tc.refresh(tclArray, remap);
  }
  
}

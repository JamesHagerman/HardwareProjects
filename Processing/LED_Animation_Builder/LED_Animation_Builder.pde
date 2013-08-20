PGraphics pg;
PGraphics bottomLeds;
PGraphics topLeds;
PGraphics mask;

int centerX;
int centerY;
  
void setup() {
  size(500,500,P3D);
  smooth();
  
  // Build the graphics objects:
  pg = createGraphics(width,height,P3D);
  bottomLeds = createGraphics(width,height,P3D);
  topLeds = createGraphics(width,height,P3D);
  pg.smooth();
  bottomLeds.smooth();
  topLeds.smooth();
  
  // Define some useful variables:
  centerX = width/2;
  centerY = height/2;
  
  // Build a mask for the top and bottom leds:
  mask = createGraphics(width,height,P2D);
  buildMask();
}

void draw() {
//  image(mask,0,0);
//  background(0);
//  updatePG();
//  image(pg,0,0);
}

void buildMask() {
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.ellipse(centerX, centerY, centerX, centerY);
  mask.endDraw();
}

void updatePG() {
  // Animation variables:
  int centerX = pg.width/2;
  int centerY = pg.height/2;
  
  pg.beginDraw();
  pg.background(0);
  
  pg.noStroke();
  pg.fill(255,0,255);
  pg.ellipse(centerX, centerY, 5, 5);
  
  pg.endDraw();  
}


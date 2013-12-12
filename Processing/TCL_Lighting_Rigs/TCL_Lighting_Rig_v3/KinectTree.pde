class KinectTree extends AnimationRoutine {
//  int w = 0;
//  int h = 0;
//  
//  void reinit() {
//    w = pg.width;
//    h = pg.height;
//  }
  
  int diameter;

  int colorChangeCounter = 0;
  color backgroundColor;

  KinectTree() {
     diameter = 5;
     backgroundColor = getRandomColor();
  }
  
  KinectTree(int circleSize) {
     diameter = circleSize;
     backgroundColor = getRandomColor();
  }

  void draw() {
    draw(mouseX, mouseY);
  }
  
  void draw(int inputX, int inputY) {
    pg.beginDraw();
    pg.colorMode(HSB, 255);
    // pg.background(inputY, inputX, 255);
    // pg.background(0, 255, 0);
    if (colorChangeCounter > 50) {
      backgroundColor = getRandomColor();
      colorChangeCounter = 0;
    } else {
      colorChangeCounter += 1;
    }
    pg.background(backgroundColor);
    
    pg.noStroke();
    pg.fill(100, 255, 255);
   	// pg.ellipse(inputX,inputY, diameter, diameter);

    pg.rectMode(CENTER);
    pg.rect(inputX, height/2, 50, height);
    pg.rectMode(CORNER);

    pg.colorMode(RGB, 255);

    pg.endDraw();
  }

  color getRandomColor() {
    return color((int)random(255), (int)random(255), (int)random(255));
  }
}

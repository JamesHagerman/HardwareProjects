class KinectTree extends AnimationRoutine {
//  int w = 0;
//  int h = 0;
//  
//  void reinit() {
//    w = pg.width;
//    h = pg.height;
//  }
  
  int diameter;
  KinectTree() {
     diameter = 5;
  }
  
  KinectTree(int circleSize) {
     diameter = circleSize;
  }

  void draw() {
    draw(mouseX, mouseY);
  }
  
  void draw(int inputX, int inputY) {
    pg.beginDraw();
    pg.colorMode(HSB, 255);
    // pg.background(inputY, inputX, 255);
    pg.background(0, 255, 0);
    pg.noStroke();
    pg.fill(100, 255, 255);
   	pg.ellipse(inputX,inputY, diameter, diameter);
    pg.endDraw();
  }
}

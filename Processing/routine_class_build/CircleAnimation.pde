class CircleAnimation extends SensatronRoutine {
  int w = 0;
  int h = 0;
  
  void reinit() {
    w = pg.width;
    h = pg.height;
  }
  
  void draw() {
    pg.beginDraw();
    pg.background(255,0,255);
    pg.endDraw();
  }
}

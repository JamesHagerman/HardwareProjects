SensatronRoutine routine;
PGraphics mainPG;
CircleAnimation aCircle;
void setup() {
  size(500,500, P3D);
  aCircle = new CircleAnimation();
  
}

void draw() {
  println("main draw");
  aCircle.draw();
  aCircle.update();
}

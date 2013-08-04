
void setup() 
{
  size(200, 200);
  byte[] nums = { 0, 34, 5, 127, 52};

  // Writes the bytes to a file
  saveBytes("numbers.dat", nums);
  
  byte address = 0b0010;
  byte test = address & 0b0000;
  println("derp: " + test);
  
}

void draw() 
{
  background(204);
  
}


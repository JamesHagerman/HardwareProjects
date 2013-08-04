// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 9-8: A snake following the mouse

// Declare two arrays with 50 elements.
int[] xpos = new int[100]; 
int[] ypos = new int[100];

void setup() {
  size(800,600,P3D);
  
  smooth();
  // Initialize all elements of each array to zero.
  for (int i = 0; i < xpos.length; i ++ ) {
    xpos[i] = 0; 
    ypos[i] = 0;
  }
}

void draw() {
  background(0);
  
  // Shift array values
  for (int i = 0; i < xpos.length-1; i ++ ) {
    // Shift all elements down one spot. 
    // xpos[0] = xpos[1], xpos[1] = xpos = [2], and so on. Stop at the second to last element.
    xpos[i] = xpos[i+1];
    ypos[i] = ypos[i+1];
  }
  
  // New location
  xpos[xpos.length-1] = mouseX; // Update the last spot in the array with the mouse location.
  ypos[ypos.length-1] = mouseY;
  
  // Draw everything
  pushMatrix();
//  rotateX(radians(45));
//  rotateY(radians(45));
  translate(width/2,height/2,-100);
  
  for (int i = 0; i < xpos.length; i ++ ) {
     // Draw an ellipse for each element in the arrays. 
     // Color and size are tied to the loop's counter: i.
    
    rotateZ(radians(i));
    noStroke();
    fill(255-i*2, 0+i*2.5, 255, 50);
    ellipse(xpos[i],ypos[i],i,i);
  }
  popMatrix();
}

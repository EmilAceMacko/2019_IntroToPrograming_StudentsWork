/*
        By Emil Macko
*/

int trailNum = 64; // The total number of trails for both of the trail types.
float radius = 32; // The radius of both the trail "heads".

// Variables for first trail (Reas & Fry version):
float x1 = 64;
float y1 = 128;
int xPos[] = new int[trailNum];
int yPos[] = new int[trailNum];
int index = 0;
PVector velocity = new PVector(12,8); // Movement velocity vector.

// Variables for second trail (my own version):
float x2 = mouseX;
float y2 = mouseY;
float xSeg[] = new float[trailNum];
float ySeg[] = new float[trailNum];
float spacing = 16; // The space between each segment.


void setup()
{
  size(1280, 720);
  noStroke();
  ellipseMode(RADIUS);
  
  // Initiate all first trail coordinates to the start coordinates:
  for(int i = 0; i < trailNum; i++)
  {
    xPos[i] = round(x1);
    yPos[i] = round(y1);
    
    xSeg[i] = round(x2) + i * spacing; // Offset each segment by 8 pixels to start with.
    ySeg[i] = round(y2) + i * spacing; // Offset each segment by 8 pixels to start with.
  }
}

void draw()
{
  background(0);
  
  
  //------ Update & draw the first trail:
  
  // Movement:
  x1 += velocity.x;
  y1 += velocity.y;
  
  // Collision with edges:
  if(x1 + radius >= width || x1 - radius < 0) velocity.x *= -1;
  if(y1 + radius >= height || y1 - radius < 0) velocity.y *= -1;
  
  // Collision with the other trail:
  if(dist(x1, y1, x2, y2) < radius * 2) // If the two circles are closer than the sum of their radii:
  {
    // Bounce/Reflect off of the circle:
    float touchAngle = atan2(y2 - y1, x2 - x1); // The angle between the two circles.
    float currentAngle = atan2(velocity.y, velocity.x); // The current angle of velocity.
    
    float newAngle = (touchAngle + (touchAngle - (currentAngle + HALF_PI))) - HALF_PI; // New bounced/reflected angle.
    float speed = velocity.mag(); // Velocity vector length.
    
    velocity.x = speed * cos(newAngle); // New X velocity.
    velocity.y = speed * sin(newAngle); // New Y velocity.
    
    // Move out of other circle.
    x1 = x2 - cos(touchAngle) * radius * 2; // New X coordinate.
    y1 = y2 - sin(touchAngle) * radius * 2; // New Y coordinate.
  }
  
  // Trail iteration:
  xPos[index] = round(x1); // Save X at current index.
  yPos[index] = round(y1); // Save Y at current index.
  index = (index + 1) % trailNum; // Add 1 to index (and use the '%' (modulo) operator to loop back to zero when index is greater than or equal to trailNum).
  
  // Drawing:
  fill(32, 255, 64, 32); // Green color.
  for(int i = 0; i < trailNum; i++) // Loop through the trail points.
  {
    int ai = (i + index) % trailNum; // Array Index (NOT Artificial Intelligence!)
    circle(xPos[ai], yPos[ai], radius * float(i) / float(trailNum)); // Draw the circle at the current index coordinate in the array, and with a decreasing radius.
  }
  
  
  //------ Update & draw the second trail:
  
  // Movement:
  x2 = mouseX;
  y2 = mouseY;
  
  // Trail segments:
  fill(255, 16, 128, 64); // Red-ish
  for(int i = 0; i < trailNum; i++) // Loop through the trail segments.
  {
    if(i == 0) // Is this the first segment in the chain?
    {
      // The first segment is not connected to anything, so it's position cannot be restricted (other than by the mouse, of course).
      xSeg[i] = x2;
      ySeg[i] = y2;
    }
    else
    {
      float angle = atan2(ySeg[i] - ySeg[i-1], xSeg[i] - xSeg[i-1]); // Get the angle between the previous segment and this segment.
      
      // Keep the angle between the segments, but restrict the distance to the spacing variable.
      xSeg[i] = xSeg[i-1] + cos(angle) * spacing;
      ySeg[i] = ySeg[i-1] + sin(angle) * spacing;
    }
    
    circle(xSeg[i], ySeg[i], radius * (1.0 - float(i) / float(trailNum))); // Draw the segment.
  }
}

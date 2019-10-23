//Flower myFlower1;  // the first instance of the Flower class
//Flower myFlower2;
//Flower myFlower3;
Flower flowerList[]; // Making an object list so it is easier to add new flowers and to update/draw them all.
Explosion explosionList[]; // List of explosions that are happening.
float flowerToExplosionRatio = 5; /* The size ratio between flowers and their explosions.
  Currently, the base flower radius is 60, where a similar size explosion has a size of 300.
  So an explosion has a size value 5 timers larger than the flower's.
  The size value differs because the explosion's size is determined by a diminishing velocity, which controls how far the smoke can spread.
*/


//Explosion explo; // Test explosion instance (UNUSED)

boolean clickHold = false; // Whether the user is holding a mouse button.
boolean clickPressed = false; // The instant the user has started pressing a mouse button.
boolean clickReleased = false; // The instant the user has started releasing a mouse button.
boolean isHoldingPetal = false; // Whether the user is holding a petal.


void setup()
{
  size(1600, 900); // Changed from (1600,1200), since I don't have a 4K monitor and I doubt most of us do!
  background(#43AF76);
  ellipseMode(RADIUS);
  
  int _r1 = 60;
  int _petals = 7;
  float _x = width/2;
  float _y = height/2;
  int _pc = #FFA000;
  
  int n_total_flowers = 6; // The total allowed amount of flowers.
  
  // Set the list's length, and fill it with "null" to begin with.
  flowerList = new Flower[n_total_flowers]; // Declare array with length.
  for(int i = 0; i < flowerList.length; i++) flowerList[i] = null; // Loop through array and set every index to "null".
  
  // Set the list's length, and fill it with "null" to begin with.
  explosionList = new Explosion[n_total_flowers]; // Declare array with length.
  for(int i = 0; i < explosionList.length; i++) explosionList[i] = null; // Loop through array and set every index to "null".
  
  
  // Flower Creation:
  
  flowerList[0] = new Flower(_r1, _petals, _x, _y, 2, 1, TAU/600.0, _pc); // Only one flower is created, since more can be created by right-clicking anywhere on the screen.
  //flowerList[1] = new Flower(_r1, _petals, _x+random(-100,100), _y, 4, 2, 0, _pc);
  //flowerList[2] = new Flower(_r1, _petals, _x+50, _y, -2, -2, 0, _pc);
  
  //explo = null; // Test explosion declared as "null" for no explosion (UNUSED)
}

void mousePressed() // This function runs every frame that the user is holding a mouse button.
{
  if(!clickHold) clickPressed = true; // If we're not already holding the mouse button, set clickPressed to true.
  clickHold = true; // Set clickHold to true.
}

void mouseReleased() // This function runs (for 1 frame) when the mouse button is released.
{
  clickReleased = true; // Set to true, since the mouse button was released.
  clickPressed = false; // Set to false, in case the user has somehow started and stopped clicking at the same time (no idea how but, I won't run the chance).
  clickHold = false; // Set to false since the mouse button is no longer holding the mouse button.
}

void draw()
{
  background(#43AF76); // Refresh background so we don't create trails.
  stroke(0);
  
  // Loop through flower list:
  for(int i = 0; i < flowerList.length; i++)
  {
    if(flowerList[i] != null) // If this index has a flower (aka is not "null"):
    {
      flowerList[i].move(); // Move flower.
    }
    
    if(flowerList[i] != null) // Check again before displaying, in case the flower has removed itself from the list.
    {
      flowerList[i].display(); // Display flower.
    }
  }
  
  // Loop through explosion list:
  for(int i = 0; i < explosionList.length; i++)
  {
    if(explosionList[i] != null) // If this index has an explosion (aka is not "null"):
    {
      explosionList[i].update(); // Update explosion.
    }
    
    if(explosionList[i] != null) // Check again before displaying, in case the explosion has removed itself from the list.
    {
      explosionList[i].display(); // Display explosion.
    }
  }
  
  
  // Right Click to add flower:
  if(clickPressed && mouseButton == RIGHT) // If we've just pressed the button and it is the right mouse button:
  {
    int freeSpot = -1; // First mark the free spot with an index we'll never use. This way we will know if there is no free spot!
    
    // Loop through the flower list:
    for(int i = 0; i < flowerList.length; i++)
    {
      // If the current index is free (aka equal to null):
      if(flowerList[i] == null)
      {
        freeSpot = i; // Set freeSpot to that index, so we can use it later.
        break; // Stop the loop, since we already found a free spot.
      }
    }
    
    // If the freeSpot value is different than the one we set it to before (-1):
    if(freeSpot != -1)
    {
      // Make some random parameters for our flower.
      float new_radius = 32 + 96 * pow(random(1),2); // 32 is the smallest possible radius, while 32+96 is the largest. Though with the pow() function, the random value is squared, and as such higher values are rarer.
      int new_petals = round(random(1, 10));
      float new_x = mouseX;
      float new_y = mouseY;
      float new_xVel = random(0.5, 4) * (floor(random(2))*2-1);
      float new_yVel = random(0.5, 4) * (floor(random(2))*2-1);
      float new_rotVel = random(TAU/1200, TAU/180);
      colorMode(HSB);
      color new_petalColor = color(random(255), 255, 255); // Random hue, but same saturation and brightness! This results in strictly colorful flowers.
      colorMode(RGB);
      // Create a flower at the newly found index in the flower list, and give it the new random parameters.
      flowerList[freeSpot] = new Flower(new_radius, new_petals, new_x, new_y, new_xVel, new_yVel, new_rotVel, new_petalColor);
    }
  }
  
  
  
  /* DEBUG COLORRAMP TEST
  //displays a colorramp based on the colors and factors in the two arrays.
  
  color colorList[] = { // Colors:
    color(255, 0, 0, 255),
    color(0, 255, 0, 255),
    color(0, 0, 255, 255)
  };
  float facList[] = { // Factors:
    0.25,
    0.5,
    0.9
  };
  
  noStroke();
  int s = 256;
  for(int i = 0; i < s; i++) // Draw the colorramp:
  {
    fill(colorRamp(colorList, facList, float(i)/float(s)));
    rect(round(width/4.0 + (width/2.0)/float(s) * i), height*3.0/4.0, ceil((width/2.0)/float(s)), 64);
  }
  
  DEBUG END */
  
  // Reset the instantaneous click variables to false, since they're only meant to be true ONCE, until you press/release a mouse button again!
  clickPressed = false;
  clickReleased = false;
}

// Colorramp Function: Takes a list of colors and a list of corresponding factors (between 0 and 1), and uses an overarching factor value to determine which colors to blend.
color colorRamp(color col[], float colFac[], float fac)
{
  
  if(col.length < 2) return col[0]; // If the list contains only one color, just return that color.
  else if(col.length != colFac.length) return #FF00FF; // If the amount of colors and factors aren't the same, return pink as an error.
  else // Otherwise, continue...
  {
    // Default color is pink. If you receive this color from the colorramp unexpectedly, then something has gone wrong!
    float _r = 255;
    float _g = 0;
    float _b = 255;
    float _a = 255;
    
    for(int i = 0; i < col.length; i++)
    {
      if(fac <= colFac[i]) // If the factor provided is less than or equal to the current index of the factor list (aka if we're equal or below the range of the current color):
      {
        if(i == 0) // If this is the first color in the ramp:
        {
          // Return this color unchanged:
          _r = red(col[0]);
          _g = green(col[0]);
          _b = blue(col[0]);
          _a = alpha(col[0]);
        }
        else // If this is NOT the first color, then mix this and the previous colors:
        {
          // Calculate the factor (mix) between the two colors, based on their factors (colFac), and the global factor (fac).
          float mix = (fac - colFac[i-1]) / (colFac[i] - colFac[i-1]);
          // Calculate the mix between the two colors:
          _r = red(col[i-1]) + (red(col[i]) - red(col[i-1])) * mix;
          _g = green(col[i-1]) + (green(col[i]) - green(col[i-1])) * mix;
          _b = blue(col[i-1]) + (blue(col[i]) - blue(col[i-1])) * mix;
          _a = alpha(col[i-1]) + (alpha(col[i]) - alpha(col[i-1])) * mix;
        }
        
        break; // Stop the loop, since we now have our color.
      }
      else if(i == col.length - 1) // If this is the last color in the ramp:
      {
        // This means the fac value was not less than or equal to the factor of the last color... meaning the fac value is greater than the range of the color ramp.
        return col[i]; // In which case, we just return the final color in the ramp.
      }
      // Else... do nothing and let the next loop run.
    }
  
    return color(_r, _g, _b, _a); // Return the calculated color.
  }
}

class Petal
{
  /*
      Petal:
      
      Every flower has 1 or more petals connected to it.
      These petals will follow the movement and rotation of their flower as long as they are connected.
      
      Petals can be clicked on with the left mouse button.
      Once you hold a petal, you can drag it away from the flower in order to pluck it off.
      If let go after being plucked, the petal will fall down until it can't be seen, where it is then deleted.
      
      (Petals carry momentum, so you can throw them with the cursor!)
  */
  
  float angle; // The petal's position on the flower, measured by angle.
  float x, y; // Positional coordinates of the petal.
  float radius; // The radius of the petal.
  float petalPoint = 0.6; // The point on the petal that is connected to the flower.
  float petalHoldPoint = 0.75; // The point where the petal will be held.
  float stretch = 1.0; // The amount that the user is stretching a petal.
  float stretchLimit = 2.0; // The limit for stretching a petal until it becomes plucked.
  float angleHold = 0.0; // The angle that the user is plucking the petal in relation to the flower and petal's own rotation.
  float angleLimit = PI * 0.75; // Angular limit for plucking a petal.
  Flower myFlower; // The flower that the petal is connected to.
  boolean plucked = false; // Whether the petal has been plucked off of the flower.
  boolean holding = false; // Whether the user is holding the petal.
  color col; // The color of the petal.
  
  float xVel, yVel; // Velocity variables (for when plucked).
  float xOld, yOld; // Previous x/y coordinates (for calculating the speed that the user is draggin/throwing the petal).
  float grav = 0.5; // Gravity (for when plucked).
  
  Petal(Flower _myFlower, float _angle, color _col) // The Petal Constructor:
  {
    myFlower = _myFlower;
    angle = _angle;
    col = _col;
    
    // Get data from myFlower:
    radius = myFlower.r * myFlower.petalScale;
    col = myFlower.petalColor;
    
    xOld = x;
    yOld = y;
  }
  
  void update()
  {
    // If the petal has not been plucked yet:
    if(!plucked)
    {
      // Move and rotate with flower:
      x = cos(myFlower.rot + angle) * (myFlower.r * petalPoint) + myFlower.x;
      y = sin(myFlower.rot + angle) * (myFlower.r * petalPoint) + myFlower.y;
    }
    
    // If the user is not holding a petal (any petal!)
    if(!isHoldingPetal)
    {
      // If the user has just started clicking, and this petal is not plucked:
      if(clickPressed && !plucked)
      {
        // Check if the distance between the cursor and the petal's center is less than the petal's radius (aka if the cursor overlaps the petal):
        if(dist(mouseX, mouseY, x + cos(myFlower.rot + angle) * radius, y + sin(myFlower.rot + angle) * radius) < radius)
        {
          // Hold the petal!
          isHoldingPetal = true; // Mark this global boolean so other petals know that we're holding a petal.
          holding = true;
        }
      }
    }
    
    // If the petal is being held:
    if(holding)
    {
      // If not plucked yet:
      if(!plucked)
      {
        angleHold = (atan2(mouseY - y, mouseX - x) - (myFlower.rot + angle) + TAU) % TAU;
        stretch = dist(mouseX, mouseY, x, y) / (radius*2) + (1-petalHoldPoint);
        
        // Check if the petal is stretched enough to be plucked:
        if(stretch > stretchLimit)// || abs(angleHold) > angleLimit ) // Extra bit for checking the angle limit, but it didn't work correctly.
        {
          // Pluck the petal!
          plucked = true;
          stretch = 1.0; // Reset stretch variable.
          angleHold = 0.0; // Reset angle-hold variable.
          angle += myFlower.rot; // Get the flower's rotation and add it to the petal.
          myFlower.petalsConnected--; // Decrement the number of connected petals from the flower.
        }
      }
      else // Is plucked:
      {
        // Follow mouse:
        x = mouseX - cos(angle) * radius * 2 * petalHoldPoint;
        y = mouseY - sin(angle) * radius * 2 * petalHoldPoint;
      }
    }
    else // Is not holding petal:
    {
      // If petal is plucked:
      if(plucked)
      {
        // Move with velocity:
        x += xVel;
        y += yVel;
        // Add gravity:
        yVel += grav;
        
        // If outside the window edges:
        if(x <= -2*radius || x >= width + 2*radius || y > height + 2*radius)
        {
          // Find this petal instance in myFlower's petal list, and set it to null (effectively deleting the petal).
          for(int i = 0; i < myFlower.petals.length; i++) // Loop through petal list:
          {
            if(myFlower.petals[i] == this) // If this index in the list is this petal:
            {
              myFlower.petals[i] = null; // Set this instance to null.
              myFlower.petalCount--; // Decrement the flower's petal counter.
              break; // Stop the loop.
            }
          }
        }
      }
    }
    
    // Check for release:
    if(holding && clickReleased)
    {
      holding = false;
      isHoldingPetal = false;
      // If not plucked yet:
      if(!plucked)
      {
        // Reset stretch and angle:
        stretch = 1.0;
        angleHold = 0.0;
      }
      else // Is plucked:
      {
        // Calculate velocity that the petal was released at, by finding the distance between the current position and the previous.
        xVel = x - xOld;
        yVel = y - yOld;
      }
    }
    
    // Save the current position for the next frame (current becomes old).
    xOld = x;
    yOld = y;
  }
  
  void display()
  {
    push(); // Save the current draw settings:
    translate(x, y); // Move to petal's coordinate:
    rotate(myFlower.rot * int(!plucked) + angle + angleHold); // Rotate canvas by petal's angle.
    
    fill(col); // Use the petal color:
    ellipse(radius * stretch, 0, radius * stretch, radius); // Draw petal (with stretch variable).
    
    pop(); // Revert to previous draw settings:
  }
}

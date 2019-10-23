class Flower
{
  /*
      Flower:
      
      The flower bounces around on the screen with a constant velocity and angular momentum (meaning it rotates!)
      
      Flower's own an arrangement of petals that are connected to it.
      Once all the petals have been plucked off, the flower will destroy itself and create an explosion in its place.
      
      (Flowers can be added by right-clicking, only up to a certain amount of flowers can exist at once though!)
  */
  
  float r; // Radius of the flower petal
  int n_petals; // Number of petals 
  float petalScale = 0.75; // The scale of the petals, in relation to the flower's size.
  float x; // X-position of the center of the flower
  float y; // Y-position of the center of the flower
  float rot; // Rotation of the flower.
  float rotVel; // Rotational velocity (measured in radians per frame).
  float xVel; // X-velocity of the flower
  float yVel; // Y-velocity of the flower
  int petalColor; // Hexadecimal number for the color of petals
  Petal petals[]; // List of petals that belong to this flower.
  int petalCount; // The number of petals that the flower starts with.
  int petalsConnected; // The number of petals currently connected to the flower.
  boolean noPetals = false; // Whether all the petals have been plucked.
  boolean hasExploded = false; // Whether the flower has exploded.
 
  Flower(float _r, int _n_petals, float _x, float _y, float _xVel, float _yVel, float _rotVel, int _petalColor) // The Flower Constructor:
  {
    r = _r;
    n_petals = _n_petals;
    x = _x;
    y = _y;
    xVel = _xVel;
    yVel = _yVel;
    rotVel = _rotVel;
    petalColor = _petalColor;
    
    // Make petal list and add petals to it:
    petals = new Petal[n_petals];
    for(int i = 0; i < n_petals; i++)
    {
      petals[i] = new Petal(this, i * TAU/n_petals, petalColor);
    }
    
    petalCount = n_petals; // Counts the number of petals left existing after they're plucked.
    petalsConnected = n_petals; // Counts the number of petals connected to the flower.
  }
  
  void display ()
  {
    
    for(int i = 0; i < n_petals; i++)
    {
      if(petals[i] != null) petals[i].display();
    }
    
    /*float ballX;
    float ballY;
    
    fill(petalColor);
    for (float i=0;i<PI*2;i+=2*PI/n_petals) {
      //ballX=width/2 + r*cos(i);
      //ballY=height/2 + r*sin(i);
      ballX=x + r*cos(i);
      ballY=y + r*sin(i);
      ellipse(ballX,ballY,r,r);
      // Correctly ndenting your code makes it easier to tell where you are and what blocks you're in.
    }*/
    
    if(!noPetals) // Only display main flower body if there's at least one petal connected to it.
    {
      fill(255, 96, 0);
      ellipse(x, y, r, r);
    }
  }
  
  void move()
  {
    x += xVel;
    y += yVel;
    rot += rotVel;
    
    collide();
    
    // Check if all petals have been plucked:
    if(petalsConnected <= 0) noPetals = true;
    
    if(noPetals && !hasExploded)// If every petal has been plucked, and the flower has not exploded yet:
    {
      // Loop through the global explosion list:
      for(int i = 0; i < explosionList.length; i++)
      {
        // If this index is free (equal to null).
        if(explosionList[i] == null)
        {
          // Create new explosion:
          explosionList[i] = new Explosion(x, y, r * flowerToExplosionRatio);
          break; // Stop the loop.
        }
      }
      
      hasExploded = true; // Mark true, so there's only created one explosion and not several!
    }
    
    
    if(petalCount > 0) // If any petals exist:
    {
      // Update all the flower's petals:
      for(int i = 0; i < n_petals; i++)
      {
        if(petals[i] != null) petals[i].update();
      }
    }
    else // No petals exist.
    {
      // Loop through the global flower list:
      for(int i = 0; i < flowerList.length; i++)
      {
        // If this flower is in the current index:
        if(flowerList[i] == this)
        {
          // Remove this flower from the index.
          flowerList[i] = null;
        }
      }
    }
    
  }
  
  void collide()
  {
    // Collide with screen edges:
    
    if(x - r < 0 || x + r > width)
    {
      x = constrain(x, r, width-r);
      xVel *= -1;
    }
    if(y - r < 0 || y + r > height)
    {
      y = constrain(y, r, height-r);
      yVel *= -1;
    }
    
    
    // Collide with flowers:
    float fx, fy, fr;
    // Loop through the flower list:
    for(int i = 0; i < flowerList.length; i++)
    {
      // If the current index has a flower:
      if(flowerList[i] != null)
      {
        // If the current index doesn't belong to THIS flower:
        if(flowerList[i] != this)
        {
          fx = flowerList[i].x;
          fy = flowerList[i].y;
          fr = flowerList[i].r;
          
          if(!(x+r < fx-fr || x-r > fx+fr || y+r < fy-fr || y-r > fy+fr)) // Do a basic box-check first.
          {
            // Check for radii overlap:
            if(dist(x, y, fx, fy) < r+fr)
            {
              float a = atan2(yVel, xVel);            // Get the angle of this flower's velocity vector.
              float v = sqrt(xVel*xVel + yVel*yVel);  // Get the magnutude of the flower's velocity vector.
              
              float b = atan2(y-fy, x-fx); // Get the angle between the two flowers.
              
              float c = a + (b - a); // New angle (reflected 'a' around 'b').
              
              // Make a new velocity vector with the reflected angle and the old magnitude.
              xVel = cos(c) * v;
              yVel = sin(c) * v;
            }
          }
        }
      }
    }
  }
  
}

class Particle
{
  /*
      Particle:
      
      The particle is a moving entity with a simple circular shape, which has a lifespan and can change size and color.
      The particle's movement is determined by the angle and velocity given at creation, as well as deceleration and gravity.
      
      Deceleration slows down the movement of the particle by multiplying it with the velocity.
      Selecting a value like 0.99 makes the particle decelerate slower, while a value like 0.5 makes it slow down almost instantly.
      
      Gravity is added to the Y-velocity only, making the particle fall downwards (or upwards if set to a negative value!)
      Without gravity, the movement of the particle will remain linear, as if the particle were in outer space.
  */
  
  float x, y; // Positional coordinates.
  float xVel, yVel; // Velocity/movement vector variables.
  float decel, grav; // Deceleration and gravity (deceleration is multiplied by the x/y velocities, and gravity is exclusively added to the y velocity).
  int life; // The lifespan of the particle (in frames). To convert from seconds to frames, multiply by the framerate (here 60).
  int lifeMax; // Used to remember the lifespan that the particle was created with.
  float size; // The size of the particle
  
  color col[]; // The list of colors that the particle will go through.
  float colTime[]; // The times that govern when certain colors will be gone through.
  
  float visSize; // The visual size of the particle (used for drawing the particle after this size has been calculated).
  color visColor; // The visual color of the particle (used for drawing the particle after this color has been calculated).
  
  // Particle Constructor: Multiple colors:
  Particle(float _x, float _y, float angle, float velocity, float _decel, float _grav, float _size, int _life, color _col[], float _colTime[])
  {
    x = _x;
    y = _y;
    xVel = cos(angle) * velocity; // Convert angle and velocity to x-velocity.
    yVel = sin(angle) * velocity; // Convert angle and velocity to y-velocity.
    decel = _decel;
    grav = _grav;
    life = _life;
    lifeMax = life; // Set max lifespan to the current lifespan, as this is the lifespan the object starts with.
    size = _size;
    
    col = _col; // Give the color array through "pass by reference" (if that is what Processing actually does...)
    colTime = _colTime; // Give the color-times array through "pass by reference" (if that is what Processing actually does...)
  }
  // Particle Constructor: One color:
  Particle(float _x, float _y, float angle, float velocity, float _decel, float _grav, float _size, int _life, color _col)
  {
    x = _x;
    y = _y;
    xVel = cos(angle) * velocity; // Convert angle and velocity to x-velocity.
    yVel = sin(angle) * velocity; // Convert angle and velocity to y-velocity.
    decel = _decel;
    grav = _grav;
    life = _life;
    lifeMax = life; // Set max lifespan to the current lifespan, as this is the lifespan the object starts with.
    size = _size;
    
    col = new color[1]; // Make the array with just one index.
    col[0] = _col; // Add the one color to the array.
  }
  
  void update()
  {
    // If particle is alive:
    if(life > 0)
    {
      // Movement:
      x += xVel;
      y += yVel;
      // Deceleration:
      xVel *= decel;
      yVel *= decel;
      // Gravity:
      yVel += grav;
      
      float l = 1.0 - float(life)/float(lifeMax); // Normalized lifespan value going from zero to one. (Zero = birth, one = death.)
      
      // Calculate Size Animation (Identical for all particles!):
      if(l < 0.1) visSize = (1 - pow(10*l - 1, 2.0)) * size; // Scale up (quick).
      else visSize = (1 - pow((l - 0.1) / 0.9, 2.0)) * size; // Scale down (slow).
      
      // Calculate Color Animation:
      if(col.length == 1) visColor = col[0]; // If array only contains one color, just use that color.
      else visColor = colorRamp(col, colTime, l); // If array contains multiple colors, feed them into a color ramp.
      
      // Decrement life (basically age):
      life--;
    }
  }
  
  void display()
  {
    // If particle is alive:
    if(life > 0)
    {
      noStroke();
      fill(visColor); // Use the newly calculated color...
      circle(x, y, visSize); // ... and draw the circle using the coordinates, and the newly calculated size.
    }
  }
}

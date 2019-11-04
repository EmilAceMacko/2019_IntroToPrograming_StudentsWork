class Orb
{
  /*
      Orb:
      
      The orb follows the cursor and creates particles at its location, which with movement creates a trail.
      When the orb moves around after the cursor, it will grow with the increase in speed (and as will its particles).
      
      The orb also becomes "tense" when you hold a mouse button, which is visualized by the orb growing slightly, and releasing particles that have higher velocities.
  */
  
  float x, y, xOld, yOld, r; // Coordinates, old coordinates (for velocity calculation), and orb radius.
  color col; // Color of the particles created by the orb (the orb is always white!)
  Particle myParticles[]; // List of particles belonging to the orb.
  int particleCount = 0; // The current number of existing particles (that belong to the orb).
  int particleMax = 25; // The maximum number of particles allowed (by the orb).
  boolean holding = false; // Whether the mouse button is held.
  
  float rMin = 8; // Mininum radius under slowest speed.
  float rMax = 64; // Maximum radius under fastest speed.
  float rHold = 16; // Radius when holding (holding a mouse button).
  float rGrow = 0.2; // Growth rate between radii. Must be between 0 and 1, lower rate means slower growth. 1 = instant growth (looks ugly).
  
  float vMin = 0; // Minimum mouse velocity corresponding to minimum radius.
  float vMax = 64; // Maximum mouse velocity corresponding to maximum radius.
  
  int tick = 0; // Tick counter for spawning particles.
  int tickRate = 60/30; // How often to spawn particles. Normally 30/60 would mean "30 times over 60 frames", or 30 times a second. However this fraction is flipped since the tickrate counts in whole frames.
  // The tickrate here as 60/30 is really just 2. So every 2 frames it spawns a particle.
  
  color colors[]; // The color array carrying the colors which the particles fade over.
  float colorTimes[]; // The animation times for the particles' color animation.
  
  Orb(color _col) // Constructor, takes only a color for the orb's particles.
  {
    col = _col;
    
    colors = new color[3]; // The color list with the particles' colors:
    colors[0] = #FFFFFF; // Start white.
    colors[1] = col; // Go to the color from the constructor.
    colors[2] = color(col, 0); // Go to a fully transparent version of the color from the constructor.
    colorTimes = new float[3]; // The times for when certain colors should be faded to:
    colorTimes[0] = 0.0; // White.
    colorTimes[1] = 0.5; // Constructor-color.
    colorTimes[2] = 1.0; // Constructor-color (transparent).
    
    // Make list of particles and fill it with null to begin with:
    myParticles = new Particle[particleMax];
    for(int i = 0; i < myParticles.length; i++)
    {
      myParticles[i] = null;
    }
    
    r = rMin; // Set the current radius to the minimum radius.
  }
  
  void update()
  {
    // Update position to mouse coordinates:
    x = mouseX;
    y = mouseY;
    
    // Calculate radius based on velocity:
    float vel = dist(x, y, xOld, yOld); // Distance between the current and old position.
    float m = holding ? rHold : rMin;// Shortened if-statement. If holding, then use rHold, else, use rMin.
    r += (constrain(map(vel, vMin, vMax, rMin, rMax), m, rMax) - r) * rGrow;
    
    // Get whether the mouse button is held:
    holding = clickHold;
    
    // Create a trail of particles:
    tick++;
    if(tick >= tickRate) // If tick is ready to create a new particle:
    {
      tick = 0; // Reset tick back to zero.
      // If the current amount of particles in the list is lower than the maximum allowed:
      if(particleCount < particleMax)
      {
        // Create a new particle:
        particleCount++;
        
        int freeSpot = 0;
        for(int i = 0; i < myParticles.length; i++)
        {
          // If the current index in the list is free (aka equal to null).
          if(myParticles[i] == null)
          {
            freeSpot = i; // Set this equal to the current index (which we just found out is free).
            break; // Stop the loop, since we've found a free spot in the list.
          }
        }
        
        
        // Check if holding:
        if(holding)
        {
          // Create spraying particles:
          myParticles[freeSpot] = new Particle(x, y, random(TAU), random(2, 3), 0.95, 0, r*0.5, 30, colors, colorTimes);
        }
        else // Not holding:
        {
          // Create trailing particles:
          myParticles[freeSpot] = new Particle(x, y, random(TAU), random(0.5, 2), 0.95, 0, r*0.5, 30, colors, colorTimes);
        }
      }
    }
    
    // Loop through particle list and update any particles in it:
    for(int i = 0; i < myParticles.length; i++)
    {
      // If the current index being checked is not null (e.g. if it has an existing particle):
      if(myParticles[i] != null)
      {
        myParticles[i].update(); // Update the particle.
        if(myParticles[i].life <= 0) // If the particle has run out of life:
        {
          myParticles[i] = null; // Remove the particle from the list.
          particleCount--; // Decrement the particle counter by 1.
        }
      }
    }
    
    // Update old X/Y coordinates:
    xOld = x;
    yOld = y;
  }
  
  void display()
  {
    // Display particles:
    for(int i = 0; i < myParticles.length; i++)
    {
      // If the current index being checked is not null (e.g. if it has an existing particle):
      if(myParticles[i] != null)
      {
        myParticles[i].display(); // Display the particle.
      }
    }
    
    // Display orb:
    noStroke(); // No outline for the orb!
    fill(#FFFFFF); // Use a white color for the orb.
    circle(x, y, r); // Draw a circle at the orb's coordinates with the orb's radius.
  }
}

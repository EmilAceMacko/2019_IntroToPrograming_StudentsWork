class Emitter
{
  /*
      Emitter:
      
      The emitter is an invisible object that can create and manage particles.
      The speciality of the emitter is that it can move and behave like a particle on its own.
      This means, while it creates particles at its own position, it can move around like a particle and be affected by gravity and such.
      This makes the emitter ideal for being a "particle-shedding particle", basically used here to create trails of particles for debris from the explosion.
      
      The emitter has the same parameters as a particle, except for the color parameters.
      It also has a variable that controls the amount of particles the emitter is allowed to create, as well as a "tickrate" governing how often it can creates particles.
  */
  
  float x, y; // Positional coordinates.
  float xVel, yVel; // Velocity/movement vector variables.
  float decel, grav; // Deceleration and gravity (deceleration is multiplied by the x/y velocities, and gravity is exclusively added to the y velocity).
  int life; // The lifespan of the emitter (in frames). To convert from seconds to frames, multiply by the framerate (here 60).
  int lifeMax; // Used to remember the lifespan that the emitter was created with.
  float size; // The size of the emitter (used to govern the sizes of its created particles).
  
  int particleCount = 0; // The number of particles currently in the list
  int particleMax = 25; // The maximum number of particles that the emitter can create.
  Particle myParticles[]; // The array variable for the list of particles.
  
  int tick = 0; // Counts when to create particles.
  int tickRate = 60/20; // Create particles 4 times per second.
  
  boolean dead = false; // Whether the particle is truly dead (once its lifespan has run out, and all its particles are dead).
  
  Emitter(float _x, float _y, float angle, float velocity, float _decel, float _grav, float _size, int _life) // The Emitter Constructor:
  {
    x = _x;
    y = _y;
    xVel = cos(angle) * velocity; // Convert angle and velocity to x-velocity.
    yVel = sin(angle) * velocity; // Convert angle and velocity to y-velocity.
    decel = _decel;
    grav = _grav;
    size = _size;
    life = _life;
    lifeMax = life; // Set max lifespan to the current lifespan, as this is the lifespan the object starts with.
    
    // Create the list of particles and fill it with null to begin with:
    myParticles = new Particle[particleMax]; // Declare array with length.
    for(int i = 0; i < myParticles.length; i++) myParticles[i] = null; // Loop through array and set every index to "null".
  }
  
  void update()
  {
    // If emitter is alive:
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
      
      
      // Particle Creation:
      tick++;
      if(tick >= tickRate)
      {
        tick = 0;
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
          
          myParticles[freeSpot] = new Particle(x, y, random(TAU), random(0.2, 1), 0.95, 0, int(size*(1-l)), int(60*(1-l)), color(128*(1-l), 128*(1-l), 128*(1-l)));
        }
      }
      
      // Decrement life (basically age):
      life--;
    }
    
    
      
    // Loop through particle list and update any particles in it:
    for(int i = 0; i < myParticles.length; i++)
    {
      if(myParticles[i] != null)
      {
        myParticles[i].update();
        if(myParticles[i].life <= 0)
        {
          myParticles[i] = null; // If the current particle is dead, then remove it from the list.
          particleCount--;
        }
      }
    }
    
    if(life <= 0 && particleCount <= 0) // If emitter is dead, and there are no more live particles in the list:
    {
      dead = true; // Mark this emitter as truly dead.
    }
  }
  
  void display()
  {
    if(!dead)
    {
      // Loop through particle list and display any particles in it:
      for(int i = 0; i < myParticles.length; i++)
      {
        if(myParticles[i] != null) myParticles[i].display();
      }
    }
  }
}

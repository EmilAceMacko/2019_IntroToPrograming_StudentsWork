class Explosion
{
  /*
      Explosion:
      
      The explosion is made up of two types of objects: particles and emitters.
      It only has a position and a size (so it can't move around once created!).
      
      When an explosion is created, it will create both particles and emitters of its own, and keep track of them.
      The particles that the explosion creates are part of the main "cloud" of fire/smoke, that slowly disippates over time.
      The emitters make up the debris that flies off and create trails.
      
      The only VISIBLE objects in the explosion effect at any time, are always particles.
      The particles may belong to the explosion object or its emitters, but these two object types aren't visible on their own without particles.
  */
  
  float x, y;
  boolean dead = false;
  
  int emitterCount = 5;
  int particleCount = 32;
  
  Emitter myEmitters[];
  Particle myParticles[];
  
  // List of colors and animation times, used by the main particles (not the emitter particles).
  color partColors[] = {
    #FFEAB5, // Light yellow
    #FF5826, // Orange
    #821A22, // Dark red
    #404040  // Dark grey
  };
  float partColorTimes[] = {
    0.0,
    0.25,
    0.5,
    1.0
  };
  
  Explosion(float _x, float _y, float _size) // The Explosion Constructor:
  {
    x = _x;
    y = _y;
    
    float scale = (_size / 300.0);
    
    // Cloud (Particle) Variables:
    float cloudAngle = ((1 - sqrt(5)) / 2) * TAU; // Ensures evenly yet random spread.
    float cloudVelocity = 6 * scale;
    
    float cloudSizeBase = 24 * scale;
    float cloudSizeRandom = 16 * scale;
    
    int cloudLifeBase = int(90 * scale);
    int cloudLifeRandom = int(60 * scale);
    
    float cloudGravity = -0.02; // Negative gravity means going upward!
    float cloudDecel = 0.95;
    
    // Debris (Emitter) Variables:
    int emitterLifeBase = 100;
    int emitterLifeRandom = 40;
    
    float emitterVelocityBase = 4 * scale;
    float emitterVelocityRandom = 2 * scale;
    
    float emitterGravity = 0.1;
    float emitterDecel = 0.99;
    
    float emitterSize = 16 * scale;
    
    
    // Create Explosion Effects:
    
    
    // Create list and fill it with emitters:
    myEmitters = new Emitter[emitterCount];
    float randRot = random(TAU/emitterCount);
    for(int i = 0; i < myEmitters.length; i++)
    {
      // Constructor: x, y, angle, velocity, decel, grav, size, life.
      myEmitters[i] = new Emitter(x, y, TAU*float(i)/float(emitterCount) + randRot + random(-PI/16, PI/16), emitterVelocityBase + int(random(emitterVelocityRandom)), emitterDecel, emitterGravity, emitterSize, emitterLifeBase+int(random(emitterLifeRandom)));
    }
    
    // Create list and fill it with particles:
    myParticles = new Particle[particleCount];
    for(int i = 0; i < myParticles.length; i++)
    {
      float f = float(i+1)/float(particleCount);
      // Constructor: x, y, angle, velocity, decel, grav, size, life, color / colors, color-times.
      myParticles[i] = new Particle(x, y, i*cloudAngle, (1-f)*cloudVelocity, cloudDecel, cloudGravity, cloudSizeBase+random(cloudSizeRandom), cloudLifeBase+int(random(cloudLifeRandom)), partColors, partColorTimes);
    }
  }
  
  void update()
  {
    // Update emitters:
    if(emitterCount > 0)
    {
      for(int i = 0; i < myEmitters.length; i++)
      {
        if(myEmitters[i] != null)
        {
          myEmitters[i].update();
          // If emitter is dead:
          if(myEmitters[i].dead)
          {
            // Remove emitter:
            myEmitters[i] = null;
            emitterCount--;
          }
        }
      }
    }
    
    // Update particles:
    if(particleCount > 0)
    {
      for(int i = 0; i < myParticles.length; i++)
      {
        if(myParticles[i] != null)
        {
          myParticles[i].update();
          // If particle is dead:
          if(myParticles[i].life <= 0)
          {
            // Remove particle:
            myParticles[i] = null;
            particleCount--;
          }
        }
      }
    }
    
    if(emitterCount <= 0 && particleCount <= 0) dead = true;
    
    
    if(dead)
    {
      // Loop through the global explosion list:
      for(int i = 0; i < explosionList.length; i++)
      {
        // If this explosion is in the current index:
        if(explosionList[i] == this)
        {
          // Remove this explosion from the index.
          explosionList[i] = null;
        }
      }
    }
  }
  
  void display()
  {
    // Display emitters (back-most):
    if(emitterCount > 0)
    {
      for(int i = floor(myEmitters.length/2); i < myEmitters.length; i++)
      {
        if(myEmitters[i] != null)
        {
          myEmitters[i].display();
        }
      }
    }
    
    // Display particles:
    if(particleCount > 0)
    {
      for(int i = 0; i < myParticles.length; i++)
      {
        if(myParticles[i] != null)
        {
          myParticles[i].display();
        }
      }
    }
    
    // Display emitters (front-most):
    if(emitterCount > 0)
    {
      for(int i = 0; i < floor(myEmitters.length/2); i++)
      {
        if(myEmitters[i] != null)
        {
          myEmitters[i].display();
        }
      }
    }
  }
}

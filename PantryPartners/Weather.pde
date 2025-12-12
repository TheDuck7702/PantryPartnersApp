//Weather class
// controls the background image and optional particle effects (rain/snow)
class Weather {
  
  int weatherType; // 0 = Sunny, 1 = Cloudy, 2 = Rainy, 3 = Snowy
  int n; // Number of particles used for rain/snow effects
  PVector[] particles; // Array of particle positions (each PVector stores x and y)

  // Background images for each weather type
  PImage sunnyBG, cloudyBG, rainyBG, snowyBG;

  // Constructor: sets the starting weather and loads assets
  Weather(int w) {
    this.weatherType = w;
    
    // Randomize particle count to make the effect look more natural each run
    this.n = int(random(500, 1000));
    
    // Create initial particle positions
    this.particles = createCoordinates();

    // load background images
    sunnyBG  = loadImage("sunnyBG.png");
    cloudyBG = loadImage("cloudyBG.png");
    rainyBG  = loadImage("rainyBG.png");
    snowyBG  = loadImage("snowyBG.png");
  }

// Updates the current weather mode and resets particle positions
  void setWeather(int w) {
    this.weatherType = w;
    this.particles = createCoordinates(); // reset positions
  }

  // Creates a new set of particle positions across the screen
  PVector[] createCoordinates() {
    this.particles = new PVector[this.n];
    
    // 
    // Place each particle at a random (x, y) within the visible window
    for (int i = 0; i < n; i++) {
        this.particles[i] = new PVector(random(0, width), random(0, height));
    }
    return this.particles;
  }

  // Draws the correct background and runs the matching particle animation (if needed)
  void animateWeather() {

    noStroke(); //no outline
    
    // SUNNY (background only)
    if (this.weatherType == 0) {
      image(sunnyBG, 0, 0, width, height);
    } 
    // CLOUDY (background only)
    else if (this.weatherType == 1) {   // CLOUDY
      image(cloudyBG, 0, 0, width, height);
    } 
    // RAINY (background + rain particles)
    else if (this.weatherType == 2) {   // RAINY
      image(rainyBG, 0, 0, width, height);
      Rainy();
    } 
    // SNOWY (background + snow particles)
    else if (this.weatherType == 3) {   // SNOWY
      image(snowyBG, 0, 0, width, height);
      Snowy();
    }
  }

  // Rain particle animation
  void Rainy() {
  for (int i = 0; i < n; i++) {
    PVector p = this.particles[i];

    //random fall speed each frame
    float speed = random(20, 30);

    fill(98, 149, 209);   // rain colour (light blue)
    noStroke();
    ellipse(p.x, p.y, 2, 8);   // shape: thin vertical raindrop

    // Move the raindrop down the screen
    p.y += speed;

    // If a drop falls off the bottom, respawn it above the top at a new x
    if (p.y > height + 20) {
      p.y = random(-100, 0);
      p.x = random(0, width);
    }
  }
}

  // Snow particle animation
  void Snowy() {
    for (int i = 0; i < n; i++) {
      
      // Draw a white circle
      fill(255);
      circle(this.particles[i].x, this.particles[i].y, 4);
      
      //Move the snowflake: slight left/right drift and steady downward fall
      // this.particles[i].add(random x speed, random y speed);
      this.particles[i].add(random(-0.5, 0.5), random(3, 4.5));

      // make sure snow stays continuous
      if (this.particles[i].x < 0){
        this.particles[i].x = width;
      }
      if (this.particles[i].x > width){
        this.particles[i].x = 0;
      }
      if (this.particles[i].y >= height){
        this.particles[i].y = 0;
      }
    }
  }
}

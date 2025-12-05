class Weather {
  int weatherType;      // 0 = Sunny, 1 = Cloudy, 2 = Rainy, 3 = Snowy
  int n;
  PVector[] particles;

  // Background images
  PImage sunnyBG, cloudyBG, rainyBG, snowyBG;

  Weather(int w) {
    this.weatherType = w;
    this.n = int(random(500, 1000));
    this.particles = createCoordinates();

    // load background images
    sunnyBG  = loadImage("sunnyBG.png");
    cloudyBG = loadImage("cloudyBG.png");
    rainyBG  = loadImage("rainyBG.png");
    snowyBG  = loadImage("snowyBG.png");
  }

  void setWeather(int w) {
    this.weatherType = w;
    this.particles = createCoordinates(); // reset positions
  }

  PVector[] createCoordinates() {
    this.particles = new PVector[this.n];
    for (int i = 0; i < n; i++) {
      if (this.weatherType == 2) { // rain
        this.particles[i] = new PVector(random(0, width), random(0, height));
      } 
      else {
        this.particles[i] = new PVector(random(0, width), random(0, height));
      }
    }
    return this.particles;
  }

  void animateWeather() {

    noStroke();

    if (this.weatherType == 0) {
      image(sunnyBG, 0, 0, width, height);
    } 
    else if (this.weatherType == 1) {   // CLOUDY
      image(cloudyBG, 0, 0, width, height);
    } 
    else if (this.weatherType == 2) {   // RAINY
      image(rainyBG, 0, 0, width, height);
      Rainy();
    } 
    else if (this.weatherType == 3) {   // SNOWY
      image(snowyBG, 0, 0, width, height);
      Snowy();
    }
  }


  void Rainy() {
  for (int i = 0; i < n; i++) {
    PVector p = this.particles[i];

    //random speed each frame
    float speed = random(20, 30);

    fill(98, 149, 209);   // rain colour
    noStroke();
    ellipse(p.x, p.y, 2, 8);   // thin vertical raindrop

    // fall down
    p.y += speed;

    // when it goes off the bottom, reset above the screen
    if (p.y > height + 20) {
      p.y = random(-100, 0);
      p.x = random(0, width);
    }
  }
}

  void Snowy() {
    for (int i = 0; i < n; i++) {
      fill(255);
      circle(this.particles[i].x, this.particles[i].y, 4);
      
      // this.particles[i].add(random x speed, random y speed);
      this.particles[i].add(random(-0.5, 0.5), random(3, 4.5));

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

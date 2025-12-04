import g4p_controls.*;
PImage manImgGreen;
PImage manImgYellow;
PImage manImgRed;
  
PImage womenImgGreen;
PImage womenImgYellow;
PImage womenImgRed;


// GLOBAL OBJECTS
Community c;
Weather weatherSystem;
foodDonor donor;

int foodStock = 100;
String selectedWeatherName = "Sunny"; 

void setup() {
  size(1000, 800);
  createGUI();



  // start with Sunny weather: 0 = Sunny, 1 = Cloudy, 2 = Rainy, 3 = Snowy
  weatherSystem = new Weather(0);

  // food donor 
  donor = new foodDonor();
  
  //init imgs
  manImgYellow = loadImage("manImgYellow.png");
  manImgRed = loadImage("manImgRed.png");
  manImgGreen = loadImage("manImgGreen");
    
  womenImgGreen = loadImage("womenImgGreen.png");
  womenImgYellow = loadImage("womenImgYellow.png");
  womenImgRed = loadImage("womenImgRed.png");
  
  // one example community member
  c = new Community(50,   500);
  
}

//GRID//////////////////////////////////////////
void drawGrid() {
  int spacing = 10;      // small grid: every 20 px
  int labelStep = 50;   // put numbers every 100 px

  pushStyle();

  // grid lines
  stroke(0);
  strokeWeight(1);
  noFill();
  textAlign(LEFT, TOP);
  textSize(15);
  fill(0);   // label colour

  // vertical lines + x labels
  for (int x = 0; x <= width; x += spacing) {
    line(x, 0, x, height);

    if (x % labelStep == 0) {
      text(x, x + 1.5, 2);   // label near the top
    }
  }

  // horizontal lines + y labels
  for (int y = 0; y <= height; y += spacing) {
    line(0, y, width, y);

    if (y % labelStep == 0) {
      text(y, 2, y + 1.5);   // label near the left
    }
  }

  popStyle();
}

//////////////////////////////////////////

void draw() {
  //clear main sketch window
  background(0);
  

  // draw weather background + particles
  weatherSystem.animateWeather();
  
  //draw grid
  drawGrid();   

  //update food stock based on current weather
  donor.updateStock(selectedWeatherName);

  c.drawHomeless();

}

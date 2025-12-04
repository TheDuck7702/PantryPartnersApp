import g4p_controls.*;

// GLOBAL OBJECTS
Community c;
Weather weatherSystem;
foodDonor donor;

int foodStock = 100;
String selectedWeatherName = "Sunny"; 

void setup() {
  size(1000, 1200);
  createGUI();

  // one example community member
  c = new Community(50, 900);

  // start with Sunny weather: 0 = Sunny, 1 = Cloudy, 2 = Rainy, 3 = Snowy
  weatherSystem = new Weather(0);

  // food donor 
  donor = new foodDonor();
}

void draw() {
  // draw weather background + particles
  weatherSystem.animateWeather();

  //update food stock based on current weather
  donor.updateStock(selectedWeatherName);

  //draw community on top
  c.drawHomeless();

  ////simple HUD
  //fill(0, 150);
  //rect(10, 10, 220, 60);
  //fill(255);
  //textSize(14);
  //text("Weather: " + selectedWeatherName, 20, 30);
  //text("Food stock: " + foodStock, 20, 50);
}

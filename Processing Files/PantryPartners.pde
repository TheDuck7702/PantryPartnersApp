import g4p_controls.*;

//images
PImage manImgGreen;
PImage manImgYellow;
PImage manImgRed;
  
PImage womenImgGreen;
PImage womenImgYellow;
PImage womenImgRed;

<<<<<<< HEAD
=======


>>>>>>> 896ae9e32fd6705ba0a18975ae534020541ffc6e
Boolean clicked1 = false;
Boolean clicked2 = false;
Boolean clicked3 = false;
Boolean clicked4 = false;

PImage closedSign;

<<<<<<< HEAD
=======
PImage foodStockImg;

>>>>>>> 896ae9e32fd6705ba0a18975ae534020541ffc6e
// GLOBAL OBJECTS
Community[] people;
Weather weatherSystem;
foodDonor donor;

int foodStock = 100;
int totalPeople = 5;
String selectedWeatherName = "Sunny"; 
int totalPeople;

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
  manImgGreen = loadImage("manImgGreen.png");
    
  womenImgGreen = loadImage("womenImgGreen.png");
  womenImgYellow = loadImage("womenImgYellow.png");
  womenImgRed = loadImage("womenImgRed.png");
  
  closedSign = loadImage("closedSignImg.png");
<<<<<<< HEAD
       
=======
  
  foodStockImg = loadImage("foodStockImg.png");
  
  rebuildPeopleArray(totalPeople);
  // one example community member
  
  // int totalPeople = 10; //change this one to the gui slider output
  
>>>>>>> 896ae9e32fd6705ba0a18975ae534020541ffc6e
  //c3 = new Community(xHomeless+eNumb, 500,3);
  //c2 = new Community(xHomeless+eNumb, 470,5);
  //c = new Community(xHomeless+eNumb, 410,10);
 // c1 = new Community(xHomeless+eNumb, 440,3);
  
  //c4 = new Community(xHomeless+eNumb+200, 410,3);
  //c5 = new Community(xHomeless+eNumb+200, 440,10);
  //c6 = new Community(xHomeless+eNumb+200, 470,5);
  //c7 = new Community(xHomeless+eNumb+200, 500,3);
  
<<<<<<< HEAD
 //totalPeople = 100; //change this one to the gui slider output

  people = new Community[totalPeople];
  
=======
  //people = new Community[totalPeople];
  //for (int i = 0; i < totalPeople; i++) {
  //  float startx = 500;
  //  float starty = 1000; 
  //  people[i] = new Community(startx, starty); 
  //}
}

void rebuildPeopleArray(int totalPeople) {
  people = new Community[totalPeople];

>>>>>>> 896ae9e32fd6705ba0a18975ae534020541ffc6e
  for (int i = 0; i < totalPeople; i++) {
    float startx = 500;
    float starty = 1000;
    people[i] = new Community(startx, starty);
  }
}

//GRID//////////////////////////////////////////
void drawGrid() {
  int spacing = 10;  
  int labelStep = 50;   
  pushStyle();
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

////////////////////////////////////////////

void draw() {
  //clear main sketch window
  background(0);
  

  // draw weather background + particles
  weatherSystem.animateWeather();
  
  // drawGrid();   

  //update food stock based on current weather
<<<<<<< HEAD
  donor.updateStock(selectedWeatherName);

  //move and draw and sort all people :(
  for (int win = 1; win <= 4; win++) {
    //for loop runs through all 4 windows makes it so we draw in window 1, than window 2 ...
    for (int pos = 5; pos >= 0; pos --) {
      //loops through all 5 postions  
      for (int check = 0; check < people.length; check++) {
        //if statment checker to insure the index we are on belongs to the current window and the current pos in line
        Community c = people[check];
        if (c.windowNumber == win && c.posInLine == pos) {
          //draw and move the homeless
          c.moveHomeless();
          c.drawHomeless();
        }
      }
    }
  }


=======
  donor.updateStock();
  
  //draw food stock stats
  donor.drawFoodStock();
  
  donor.updateStockText();

  
  //move and draw all people
  for (int i = 0; i < people.length; i++) {
    people[i].moveHomeless();
    people[i].drawHomeless();
  }

 // c.drawHomeless();
>>>>>>> 896ae9e32fd6705ba0a18975ae534020541ffc6e

  
  if (clicked1) {
    image(closedSign, 145, 370, 115, 110);
  }
  if (clicked2) {
    image(closedSign, 340, 370, 115, 110);
  }
  if (clicked3) {
    image(closedSign, 535, 370, 115, 110);
  }
  if (clicked4) {
    image(closedSign, 730, 370, 115, 110);
  }

}

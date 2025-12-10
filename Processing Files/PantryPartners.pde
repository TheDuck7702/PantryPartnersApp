import g4p_controls.*;

//images
PImage manImgGreen;
PImage manImgYellow;
PImage manImgRed;
  
PImage womenImgGreen;
PImage womenImgYellow;
PImage womenImgRed;


Boolean clicked1 = false;
Boolean clicked2 = false;
Boolean clicked3 = false;
Boolean clicked4 = false;

Boolean showFoodStock = true;



PImage closedSign;

PImage foodStockImg;

// GLOBAL OBJECTS
Community[] people; 
Weather weatherSystem;
foodDonor donor;

int foodStock = 100;
int totalPeople = 5;
String selectedWeatherName = "Sunny"; 

// Starting window variables
boolean gameStarted = false;
GWindow startWindow;
GButton startButton;

void setup() {
  size(1000, 800);
  createStartWindow();
}

void initializeGame() {
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

  
  foodStockImg = loadImage("foodStockImg.png");
  
  rebuildPeopleArray(totalPeople);
  
  gameStarted = true;
}

void createStartWindow() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  
  startWindow = GWindow.getWindow(this, "Welcome to Pantry Partners", 0, 0, 600, 500, JAVA2D);
  startWindow.addDrawHandler(this, "startWindowDraw");
  startWindow.setActionOnClose(G4P.KEEP_OPEN);
  
  GLabel title = new GLabel(startWindow, 50, 30, 500, 40);
  title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  title.setText("Welcome to Pantry Partners");
  title.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  title.setOpaque(false);
  
  GLabel instructions1 = new GLabel(startWindow, 50, 100, 500, 30);
  instructions1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  instructions1.setText("Instructions:");
  instructions1.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions1.setOpaque(false);
  
  GLabel instructions2 = new GLabel(startWindow, 50, 140, 500, 30);
  instructions2.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions2.setText("• Manage the food pantry and serve community members");
  instructions2.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions2.setOpaque(false);
  
  GLabel instructions3 = new GLabel(startWindow, 50, 170, 500, 30);
  instructions3.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions3.setText("• Control weather conditions to affect food donations");
  instructions3.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions3.setOpaque(false);
  
  GLabel instructions4 = new GLabel(startWindow, 50, 200, 500, 30);
  instructions4.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions4.setText("• Adjust the number of people in line using the slider");
  instructions4.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions4.setOpaque(false);
  
  GLabel instructions5 = new GLabel(startWindow, 50, 230, 500, 30);
  instructions5.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions5.setText("• Open or close service windows as needed");
  instructions5.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions5.setOpaque(false);
  
  GLabel instructions6 = new GLabel(startWindow, 50, 260, 500, 30);
  instructions6.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions6.setText("• Monitor food stock levels in the top right corner");
  instructions6.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions6.setOpaque(false);
  
  startButton = new GButton(startWindow, 200, 350, 200, 60);
  startButton.setText("Start Game");
  startButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  startButton.addEventHandler(this, "startButtonClick");
  
  startWindow.loop();
}

synchronized public void startWindowDraw(PApplet appc, GWinData data) {
  appc.background(240, 248, 255);
}

public void startButtonClick(GButton source, GEvent event) {
  startWindow.noLoop();
  startWindow.dispose();
  initializeGame();
}

void rebuildPeopleArray(int totalPeople) {
  people = new Community[totalPeople];

  for (int i = 0; i < totalPeople; i++) {
    float startx = 500;
    float starty = 1000;
    people[i] = new Community(startx, starty);
  }
}

void rerouteClosedWindows() {
  boolean w1Open = !clicked1;
  boolean w2Open = !clicked2;
  boolean w3Open = !clicked3;
  boolean w4Open = !clicked4;

  boolean anyOpen = w1Open || w2Open || w3Open || w4Open;
  if (!anyOpen) return;  // all closed: let waiting logic handle anger + leaving

  // window x positions: index 1..4
  int[] wx = {0, 160, 360, 560, 760};
  boolean[] open = {false, w1Open, w2Open, w3Open, w4Open};

  for (int i = 0; i < people.length; i++) {
    Community c = people[i];
    if (c.isServed) continue;

    boolean myClosed =
      (c.windowNumber == 1 && !w1Open) ||
      (c.windowNumber == 2 && !w2Open) ||
      (c.windowNumber == 3 && !w3Open) ||
      (c.windowNumber == 4 && !w4Open);

    if (!myClosed) continue;

    // find closest open window
    int bestWin = -1;
    float bestDist = 99999;
    for (int w = 1; w <= 4; w++) {
      if (!open[w]) continue;
      float d = abs(wx[w] - wx[c.windowNumber]);
      if (d < bestDist) {
        bestDist = d;
        bestWin = w;
      }
    }
    if (bestWin == -1) continue;

    // find current max posInLine in that destination window
    int maxPos = -1;
    for (int j = 0; j < people.length; j++) {
      Community other = people[j];
      if (!other.isServed && other.windowNumber == bestWin) {
        if (other.posInLine > maxPos) maxPos = other.posInLine;
      }
    }

    // put this person at the back of that line (no cutting)
    c.windowNumber = bestWin;
    c.posInLine = maxPos + 1;
    c.atSpotOnce = false;           // they need to walk to the new spot first
    c.waitStartTime = 0;
    c.recalcTarget();
  }
}

//GRID//////////////////////////////////////////
//void drawGrid() {
//  int spacing = 10;  
//  int labelStep = 50;   
//  pushStyle();
//  stroke(0);
//  strokeWeight(1);
//  noFill();
//  textAlign(LEFT, TOP);
//  textSize(15);
//  fill(0);   // label colour

//  // vertical lines + x labels
//  for (int x = 0; x <= width; x += spacing) {
//    line(x, 0, x, height);

//    if (x % labelStep == 0) {
//      text(x, x + 1.5, 2);   // label near the top
//    }
//  }
//  // horizontal lines + y labels
//  for (int y = 0; y <= height; y += spacing) {
//    line(0, y, width, y);

//    if (y % labelStep == 0) {
//      text(y, 2, y + 1.5);   // label near the left
//    }
//  }

//  popStyle();
//}

////////////////////////////////////////////

void draw() {
  if (!gameStarted) {
    return;
  }
  
  //clear main sketch window
  background(0);
  // drawGrid(); 

  // draw weather background + particles
  weatherSystem.animateWeather();
  
  // reroute people from closed windows to nearest open window (no cutting)
  rerouteClosedWindows();
  
    // find the highest posInLine currently used so we don't skip people
  int maxPosInAnyWindow = 0;
  for (int i = 0; i < people.length; i++) {
    if (people[i].posInLine > maxPosInAnyWindow) {
      maxPosInAnyWindow = people[i].posInLine;
    }
  }
    
  //update food stock based on current weather

    //move and draw and sort all people :(
  // first, compute which windows already have a green (served) person leaving
  boolean[] windowOccupied = new boolean[5]; // index 1..4

  for (int i = 0; i < people.length; i++) {
    Community c = people[i];
    if (c.isServed && !c.hasLeftScreen() && c.windowNumber >= 1 && c.windowNumber <= 4) {
      windowOccupied[c.windowNumber] = true;
    }
  }

  for (int win = 1; win <= 4; win++) {
  //for loop runs through all 4 windows makes it so we draw in window 1, than window 2 ...
    for (int pos = maxPosInAnyWindow; pos >= 0; pos--) {
      //loops through all 5 postions  
      for (int check = 0; check < people.length; check++) {
        //if statment checker to insure the index we are on belongs to the current window and the current pos in line
        Community c = people[check];
        if (c.windowNumber == win && c.posInLine == pos) {

          // 1) update waiting / colour / angry leaving if all windows are closed
          c.updateWaitingState();

          // 2) attempt to serve this person if they reached the window AND
          //    this window isn't already serving someone green
          boolean justServed = c.checkServedAndExit(windowOccupied);

          // 3) if they just got food this frame, consume from stock
          if (justServed) {
            donor.consumeFood(1);   // 1 "unit" of food per person for now
          }

          //draw and move the homeless
          c.moveHomeless();
          c.drawHomeless();
        }
      }
    }
  }

  donor.updateStock();
  
  if(showFoodStock){
    donor.drawFoodStock();
  }
  
  donor.updateStockText();

  

  
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

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


// Helper function to find the window with the least number of people (only open windows)
int findWindowWithLeastPeople() {
  boolean w1Open = !clicked1;
  boolean w2Open = !clicked2;
  boolean w3Open = !clicked3;
  boolean w4Open = !clicked4;
  
  // Count people at each open window (only count people not yet served)
  int[] windowCounts = {0, 0, 0, 0, 0}; // index 0 unused, 1-4 for windows
  
  // Check if people array exists and is initialized
  if (people != null) {
    for (int i = 0; i < people.length; i++) {
      Community c = people[i];
      if (c != null && !c.isServed && c.windowNumber >= 1 && c.windowNumber <= 4) {
        windowCounts[c.windowNumber]++;
      }
    }
  }
  
  // Find the open window with the least people
  int bestWindow = -1;
  int minCount = 99999;
  
  if (w1Open && windowCounts[1] < minCount) {
    minCount = windowCounts[1];
    bestWindow = 1;
  }
  if (w2Open && windowCounts[2] < minCount) {
    minCount = windowCounts[2];
    bestWindow = 2;
  }
  if (w3Open && windowCounts[3] < minCount) {
    minCount = windowCounts[3];
    bestWindow = 3;
  }
  if (w4Open && windowCounts[4] < minCount) {
    minCount = windowCounts[4];
    bestWindow = 4;
  }
  
  // If all windows are closed, default to window 1
  if (bestWindow == -1) {
    bestWindow = 1;
  }
  
  return bestWindow;
}

void rebuildPeopleArray(int totalPeople) {
  people = new Community[totalPeople];

  for (int i = 0; i < totalPeople; i++) {
    float startx = 500;
    float starty = 900; // spawn from bottom of screen
    int windowNum = findWindowWithLeastPeople();
    people[i] = new Community(startx, starty, windowNum);
  }
}

void resetGame() {
  // Reset food stock
  foodStock = 100;
  
  // Reset donor
  donor = new foodDonor();
  
  // Reset weather to Sunny
  selectedWeatherName = "Sunny";
  weatherSystem.setWeather(0);
  if (weather != null) {
    weather.setSelected(0);
  }
  
  // Reset window checkboxes
  clicked1 = false;
  clicked2 = false;
  clicked3 = false;
  clicked4 = false;
  if (openOrClosed1 != null) openOrClosed1.setSelected(true);
  if (openOrClosed2 != null) openOrClosed2.setSelected(true);
  if (openOrClosed3 != null) openOrClosed3.setSelected(true);
  if (openOrClosed4 != null) openOrClosed4.setSelected(true);
  
  // Reset people array
  rebuildPeopleArray(totalPeople);
  
  // Reset slider if needed
  if (maxPeopleInLine != null) {
    maxPeopleInLine.setValue(5);
  }
}

void updateLinePositions() {
  // For each window, sort people by arrival time (first-come-first-serve)
  for (int win = 1; win <= 4; win++) {
    // Collect all people at this window who are not served
    ArrayList<Community> windowPeople = new ArrayList<Community>();
    for (int i = 0; i < people.length; i++) {
      Community c = people[i];
      if (c.windowNumber == win && !c.isServed) {
        windowPeople.add(c);
      }
    }
    
    // Separate into two groups: arrived and not arrived
    ArrayList<Community> arrived = new ArrayList<Community>();
    ArrayList<Community> notArrived = new ArrayList<Community>();
    
    for (Community c : windowPeople) {
      if (c.arrivalTime != -1) {
        arrived.add(c);
      } else {
        notArrived.add(c);
      }
    }
    
    // Sort arrived by arrival time (earliest first)
    for (int i = 0; i < arrived.size() - 1; i++) {
      for (int j = i + 1; j < arrived.size(); j++) {
        if (arrived.get(j).arrivalTime < arrived.get(i).arrivalTime) {
          Community temp = arrived.get(i);
          arrived.set(i, arrived.get(j));
          arrived.set(j, temp);
        }
      }
    }
    
    // Sort not arrived by spawn time (earliest first) - temporary positions
    for (int i = 0; i < notArrived.size() - 1; i++) {
      for (int j = i + 1; j < notArrived.size(); j++) {
        if (notArrived.get(j).spawnTime < notArrived.get(i).spawnTime) {
          Community temp = notArrived.get(i);
          notArrived.set(i, notArrived.get(j));
          notArrived.set(j, temp);
        }
      }
    }
    
    // Assign positions: arrived people get positions 0, 1, 2... (front of line)
    // Not arrived people get positions after arrived people
    int pos = 0;
    for (Community c : arrived) {
      // Always update position and recalc target to ensure smooth movement
      if (c.posInLine != pos) {
        c.posInLine = pos;
        c.recalcTarget();
        // Reset arrival tracking if position changed significantly
        if (abs(c.yPos - c.targety) > 50) {
          c.atSpotOnce = false;
        }
      }
      pos++;
    }
    
    // Assign temporary positions to not arrived people (they'll be repositioned when they arrive)
    for (Community c : notArrived) {
      // Update position if needed
      if (c.posInLine == -1 || c.posInLine < arrived.size() || c.posInLine >= pos) {
        c.posInLine = pos;
        c.recalcTarget();
      }
      pos++;
    }
  }
}

void maintainPeopleCount() {
  // Count how many people are currently in line (not served)
  int inLineCount = 0;
  for (int i = 0; i < people.length; i++) {
    if (!people[i].isServed) {
      inLineCount++;
    }
  }
  
  // If we have fewer people in line than the slider value, spawn new ones
  if (inLineCount < totalPeople) {
    int needed = totalPeople - inLineCount;
    
    // First, try to reuse slots where people have left the screen
    for (int i = 0; i < people.length && needed > 0; i++) {
      if (people[i].isServed && people[i].hasLeftScreen()) {
        // Reuse this slot for a new person
        float startx = 500;
        float starty = height + 100; // spawn from bottom of screen
        int windowNum = findWindowWithLeastPeople();
        people[i] = new Community(startx, starty, windowNum);
        needed--;
      }
    }
    
    // If we still need more people, expand the array
    if (needed > 0) {
      Community[] newPeople = new Community[people.length + needed];
      // Copy existing people
      for (int i = 0; i < people.length; i++) {
        newPeople[i] = people[i];
      }
      // Add new people
      for (int i = 0; i < needed; i++) {
        float startx = 500;
        float starty = height + 100; // spawn from bottom of screen
        int windowNum = findWindowWithLeastPeople();
        newPeople[people.length + i] = new Community(startx, starty, windowNum);
      }
      people = newPeople;
    }
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
    c.posInLine = -1; // will be assigned by updateLinePositions based on arrival
    c.atSpotOnce = false;           // they need to walk to the new spot first
    c.waitStartTime = 0;
    c.arrivalTime = -1; // reset arrival time, will be set when they reach new spot
    c.recalcTarget();
  }
}


void draw() {
  if (!gameStarted) {
    return;
  }

  //clear main sketch window
  background(0);

  // draw weather background + particles
  weatherSystem.animateWeather();
  
  // closed window
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
  
  // reroute people from closed windows to nearest open window (no cutting)
  rerouteClosedWindows();
  
  // Update line positions based on first-come-first-serve
  updateLinePositions();
  
  // Spawn new people if needed to maintain the slider count
  maintainPeopleCount();
  
    // find the highest posInLine currently used so we don't skip people
  int maxPosInAnyWindow = 0;
  for (int i = 0; i < people.length; i++) {
    if (people[i].posInLine > maxPosInAnyWindow) {
      maxPosInAnyWindow = people[i].posInLine;
    }
  }
    
  //update food stock based on current weather

    //move and draw and sort all people :(
    // first, compute which windows already have a green (served) person at the window
    // Only mark as occupied if they're still near the window (haven't moved away yet)
  boolean[] windowOccupied = new boolean[5]; // index 1..4

  for (int i = 0; i < people.length; i++) {
    Community c = people[i];
    // Only mark window as occupied if person is served and still near the window position
    // This allows the next person to be served once the previous person moves away
    if (c.isServed && c.windowNumber >= 1 && c.windowNumber <= 4) {
      // Check if they're still near the window (within 100 pixels of window x position)
      int[] wx = {0, 160, 360, 560, 760};
      float windowX = wx[c.windowNumber];
      if (abs(c.xPos - windowX) < 100 && !c.hasLeftScreen()) {
        windowOccupied[c.windowNumber] = true;
      }
    }
  }
for (int i = 0; i < people.length; i++) {
    Community c = people[i];
    
    if (c.windowNumber >= 1 && c.windowNumber <= 4 && c.posInLine >= 0) {
        // 1) update waiting / color / angry leaving if all windows are closed
        c.updateWaitingState();

        // 2) attempt to serve this person if they reached the window AND
        //    this window isn't already serving someone green
        boolean justServed = c.checkServedAndExit(windowOccupied);

        // 3) consume food if just served (only if food was actually available)
        if (justServed) {
            int foodAmount = 1;
            if (c.hungerBeforeServed >= 8) foodAmount = 8;
            else if (c.hungerBeforeServed >= 6) foodAmount = 5;
            donor.consumeFood(foodAmount);
        }

        // move and draw
        c.moveHomeless();
        c.drawHomeless();
    }
}

  donor.updateStock();
  
  if(showFoodStock){
    donor.drawFoodStock();
  }
  
  donor.updateStockText();

}

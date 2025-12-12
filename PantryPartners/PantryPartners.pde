//////////////////////////////////////////////////////////////////
//Pantry Partners
//Course: ICS 4UI - 02
//Teacher: Mr. Schattman
//Created by: Michelle Wu, Prinaka Basu, Shayaan Shaikh and John Fu
//////////////////////////////////////////////////////////////////

//Main tab 


// Import g4p
import g4p_controls.*;

//Images
PImage manImgGreen;
PImage manImgYellow;
PImage manImgRed;
  
PImage womenImgGreen;
PImage womenImgYellow;
PImage womenImgRed;

PImage closedSign;
PImage foodStockImg;

//Global variables for windows
//Window status checkbox from gui, when "true", it means that the window is CLOSED
Boolean clicked1 = false;
Boolean clicked2 = false;
Boolean clicked3 = false;
Boolean clicked4 = false;

// If true, begin the program with displaying the food stock on the top right corner
Boolean showFoodStock = true;

// GLOBAL OBJECTS
Community[] people; // Array of all community members currently in the simulation
Weather weatherSystem; // Controls background + weather particles + food donation 
foodDonor donor; // Handles food donations, food stock display
int foodStock = 100; // Default initial food stock
int totalPeople = 5; // Default initial total people that go in line
String selectedWeatherName = "Sunny"; // Default initial  weather

boolean gameStarted = false; //Game doesnt start until user clicks "Start Simulation"

// creates the sketch window
void setup() {
  size(1000, 800);
  createStartWindow();
}

// Initializes the simulation and GUI after the start button is pressed
void initializeGame() {
  //Create GUI controls
  createGUI();

  // Initialize weater (0 = Sunny, 1 = Cloudy, 2 = Rainy, 3 = Snowy)
  weatherSystem = new Weather(0);

  //Initialize food donor system
  donor = new foodDonor();
  
  //Load images
  manImgYellow = loadImage("manImgYellow.png");
  manImgRed = loadImage("manImgRed.png");
  manImgGreen = loadImage("manImgGreen.png");
    
  womenImgGreen = loadImage("womenImgGreen.png");
  womenImgYellow = loadImage("womenImgYellow.png");
  womenImgRed = loadImage("womenImgRed.png");
  
  closedSign = loadImage("closedSignImg.png");
  foodStockImg = loadImage("foodStockImg.png");
  
  //spawn initial community members
  rebuildPeopleArray(totalPeople);
  
  // Allow draw() to run the simulation
  gameStarted = true;
}


// Helper function to find the window with the least number of people (only windows that are open)
int findWindowWithLeastPeople() { 
  
  // clicked# is true when the window is CLOSED, so inverts it to get an "open" for clearer logic
  boolean w1Open = !clicked1;
  boolean w2Open = !clicked2;
  boolean w3Open = !clicked3;
  boolean w4Open = !clicked4;
  
   // Count how many active (not served) people are assigned to each window
  int[] windowCounts = {0, 0, 0, 0, 0}; // index 0 unused, 1-4 for windows
  
  // Check if people array exists and is initialized
  // Count people per window (skip nulls and people who are already leaving)
  if (people != null) {
    for (int i = 0; i < people.length; i++) {
      Community c = people[i];
      if (c != null && !c.isServed && c.windowNumber >= 1 && c.windowNumber <= 4) {
        windowCounts[c.windowNumber]++;
      }
    }
  }
  
  // Find the open window with the least people
  int bestWindow = -1; // bestWindow stores the window number (1–4) with the smallest line so far (-1 = none found yet)
  int minCount = 99999; // minCount tracks the smallest line count seen so far (start very high so the first open window wins)
  
  // Check each window only if it is open, and keep the smallest count
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
  return bestWindow; //Return the selected window number (1–4) for the next community member to join
}

// Create new people array with exactly totalPeople community members
//to update the total people (if theres less people than the slider it would to add to equal enough)
void rebuildPeopleArray(int totalPeople) {
  
  // Resize the array to match the requested number of people
  people = new Community[totalPeople];

  // Spawn each community member and assign them to the least crowded open window
  for (int i = 0; i < totalPeople; i++) {
    float startx = 500;
    float starty = 900; // spawn from bottom of screen
    int windowNum = findWindowWithLeastPeople();
    people[i] = new Community(startx, starty, windowNum);
  }
}

// RESET
void resetGame() {
  
  // Reset total food stock back to the starting amount
  foodStock = 100;
  
  // Reset donor
  donor = new foodDonor();
  
  // Reset weather to Sunny (and sync the GUI dropdown)
  selectedWeatherName = "Sunny";
  weatherSystem.setWeather(0);
  if (weather != null) {
    weather.setSelected(0);
  }
  
  // Reset all window checkboxes, and re-open all windows
  clicked1 = false;
  clicked2 = false;
  clicked3 = false;
  clicked4 = false;
  if (openOrClosed1 != null) openOrClosed1.setSelected(true);
  if (openOrClosed2 != null) openOrClosed2.setSelected(true);
  if (openOrClosed3 != null) openOrClosed3.setSelected(true);
  if (openOrClosed4 != null) openOrClosed4.setSelected(true);
  
  // Reset people array and respawn community members using the current totalPeople setting
  rebuildPeopleArray(totalPeople);
  
  // Reset the slider back to its default value (5)
  if (maxPeopleInLine != null) {
    maxPeopleInLine.setValue(5);
  }
}

//Recalculates line order at each service window (first-come-first-serve)
// Updates each person's posInLine and target position so the line stays organized as people move/leave
void updateLinePositions() {
 
  // Process each window separately (windows are numbered 1–4)
  for (int win = 1; win <= 4; win++) {
    
    // Gather all active (not served) people assigned to this window
    ArrayList<Community> windowPeople = new ArrayList<Community>();
    for (int i = 0; i < people.length; i++) {
      Community c = people[i];
      if (c.windowNumber == win && !c.isServed) {
        windowPeople.add(c);
      }
    }
    
   // Seperate into two groups:
   // - arrived: people who have reached their line spot (arrivalTime is set)
   // - notArrived: people still walking into position (arrivalTime not set yet)
    ArrayList<Community> arrived = new ArrayList<Community>();
    ArrayList<Community> notArrived = new ArrayList<Community>();
    
    for (Community c : windowPeople) {
      if (c.arrivalTime != -1) {
        arrived.add(c);
      } else {
        notArrived.add(c);
      }
    }
    
    // Sort arrived people by arrivalTime so the earliest arrival is at the front of the line
    for (int i = 0; i < arrived.size() - 1; i++) {
      for (int j = i + 1; j < arrived.size(); j++) {
        if (arrived.get(j).arrivalTime < arrived.get(i).arrivalTime) {
          Community temp = arrived.get(i);
          arrived.set(i, arrived.get(j));
          arrived.set(j, temp);
        }
      }
    }
    
    // Sort notArrived people by spawnTime so they fill in behind the arrived people 
    for (int i = 0; i < notArrived.size() - 1; i++) {
      for (int j = i + 1; j < notArrived.size(); j++) {
        if (notArrived.get(j).spawnTime < notArrived.get(i).spawnTime) {
          Community temp = notArrived.get(i);
          notArrived.set(i, notArrived.get(j));
          notArrived.set(j, temp);
        }
      }
    }
    
    // Assign linepositions: 
    // posInLine = 0 is the front of the line (closest to the window)
    // Not arrived people get positions after arrived people
    int pos = 0;
    
    for (Community c : arrived) { // Give arrived people the first positions (0, 1, 2...)
      
      // Update position and target so movement stays smooth when the line changes
      if (c.posInLine != pos) {
        c.posInLine = pos;
        c.recalcTarget();
        
        // If they were moved significantly, make them to "arrive" again before starting wait time
        if (abs(c.yPos - c.targety) > 50) {
          c.atSpotOnce = false;
        }
      }
      pos++;
    }
    
    // Assign temporary positions to not arrived people (they'll be repositioned when they arrive)
    // Put notArrived people behind arrived people
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

// Keeps the number of active (not served) community members equal to totalPeople (slider value)
// Reuses array slots for people who have fully left the screen and expands the array if necessary
void maintainPeopleCount() {
  
  // Count how many people are currently in line (not served)
  int inLineCount = 0;
  for (int i = 0; i < people.length; i++) {
    if (!people[i].isServed) {
      inLineCount++;
    }
  }
  
  // If we have fewer people in line than the slider value (totalPeople), spawn new ones
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
    
    // If we still need more people, expand the array and add new community members
    if (needed > 0) {
      Community[] newPeople = new Community[people.length + needed];
      
      // Copy existing people into the new array
      for (int i = 0; i < people.length; i++) {
        newPeople[i] = people[i];
      }
      // Add new community members
      for (int i = 0; i < needed; i++) {
        float startx = 500;
        float starty = height + 100; // spawn from bottom of screen
        int windowNum = findWindowWithLeastPeople();
        newPeople[people.length + i] = new Community(startx, starty, windowNum);
      }
      people = newPeople; //change to new array
    }
  }
}

// If a service window is closed, move waiting people assigned to that window
// to the nearest open window (and place them at the back of the new line)
void rerouteClosedWindows() {
  boolean w1Open = !clicked1;
  boolean w2Open = !clicked2;
  boolean w3Open = !clicked3;
  boolean w4Open = !clicked4;

  // If all windows are closed, do not reroute 
  boolean anyOpen = w1Open || w2Open || w3Open || w4Open;
  if (!anyOpen) return; 

  int[] wx = {0, 160, 360, 560, 760}; // Window X positions: index 1..4
  boolean[] open = {false, w1Open, w2Open, w3Open, w4Open}; // array for checking open status by window number

  // Check each person and reroute only those stuck at a closed window
  for (int i = 0; i < people.length; i++) {
    Community c = people[i];
    
     // Skip people who are already leaving / finished
    if (c.isServed) continue;

    // Determine whether this person's current window is closed
    boolean myClosed =
      (c.windowNumber == 1 && !w1Open) ||
      (c.windowNumber == 2 && !w2Open) ||
      (c.windowNumber == 3 && !w3Open) ||
      (c.windowNumber == 4 && !w4Open);

    // If their window is still open, do nothing
    if (!myClosed) continue;

    // Find the closest open window (based on horizontal distance between windows)
    int bestWin = -1; // bestWin stores the closest open window number (1–4); -1 means none found yet
    float bestDist = 99999; // bestDist stores the smallest distance found so far (start very large so the first open window)
    for (int w = 1; w <= 4; w++) {
      if (!open[w]) continue;
      float d = abs(wx[w] - wx[c.windowNumber]);
      if (d < bestDist) {
        bestDist = d;
        bestWin = w;
      }
    }
    
    // if no open window exists, do nothing
    if (bestWin == -1) continue; 

    // find current max posInLine in that destination window
    int maxPos = -1;
    for (int j = 0; j < people.length; j++) {
      Community other = people[j];
      if (!other.isServed && other.windowNumber == bestWin) {
        if (other.posInLine > maxPos) maxPos = other.posInLine;
      }
    }

    // Reassign this person to the destination window (they will be placed at the back)
    c.windowNumber = bestWin;
    c.posInLine = -1; // will be assigned by updateLinePositions based on arrival
    c.atSpotOnce = false; // they must reach the new spot before their wait timer starts
    c.waitStartTime = 0;
    c.arrivalTime = -1; // reset arrival time, will be set when they reach new spot
    c.recalcTarget(); // update targetx/targety for the new window
  }
}


void draw() {
  
   // Do nothing until the user clicks "Start Simulation" and initialization is complete
  if (!gameStarted) {
    return;
  }

  //clear main sketch window
  background(0);

  // 1) Draw the weather background and weather particle effects (rain/snow)
  weatherSystem.animateWeather();
  
  // 2) Draw "Closed" sign overlays on any windows that are currently closed
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
  
  // 3) If a window is closed, move waiting people to the nearest open window
  rerouteClosedWindows();
  
  // 4) Update line positions based on first-come-first-serve
  updateLinePositions();
  
  // 5) Spawn new people if needed to maintain the slider count
  maintainPeopleCount();

  // 6) Track which windows are currently busy serving someone
    // first, compute which windows already have a green (served) person at the window
    // Only mark as occupied if they're still near the window (haven't moved away yet)
  boolean[] windowOccupied = new boolean[5]; // index 1..4

  // Mark windows as occupied if a served person is still near the counter and has not left the screen
  for (int i = 0; i < people.length; i++) {
    Community c = people[i];
    
    // Only mark window as occupied if person is served and still near the window position
    // This allows the next person to be served once the previous person moves away
    if (c.isServed && c.windowNumber >= 1 && c.windowNumber <= 4) {
      
      // Window X positions used to check if the person is still close to the counter
      int[] wx = {0, 160, 360, 560, 760};
      float windowX = wx[c.windowNumber];
      
      // If they are still near the counter, keep the window marked as occupied
      if (abs(c.xPos - windowX) < 100 && !c.hasLeftScreen()) {
        windowOccupied[c.windowNumber] = true;
      }
    }
  }
  
 
// Update each community member (waiting logic, serving, movement, and drawing)
for (int i = 0; i < people.length; i++) {
    Community c = people[i];
    
    // Only update valid people who are assigned to a real window (1–4) and have a line position
    if (c.windowNumber >= 1 && c.windowNumber <= 4 && c.posInLine >= 0) {
        
      // Update waiting time and hunger colour; also handles leaving if ALL windows are closed
        c.updateWaitingState();

        // attempt to serve this person if they reached the window AND
        // this window isn't already serving someone green
        boolean justServed = c.checkServedAndExit(windowOccupied);

        // If food was successfully served, subtract the correct number of cans from the donor stock
        if (justServed) {
            int foodAmount = 1;  // default amount
            if (c.hungerBeforeServed >= 8) foodAmount = 8;
            else if (c.hungerBeforeServed >= 6) foodAmount = 5;
            donor.consumeFood(foodAmount);
        }

        // Move the person toward their target position and draw their current hunger colour image
        c.moveCommunity();
        c.drawCommunity();
    }
}

  // Update donations over time and refresh the food stock display text
  donor.updateStock();
  
  // draw the food stock panel in the top-right corner
  if(showFoodStock){
    donor.drawFoodStock();
  }
  
  // Display the most recent donation message 
  donor.updateStockText();

}

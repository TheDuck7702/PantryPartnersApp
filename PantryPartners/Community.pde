//Community class
// People that receive food in the simulation

class Community { //Community members that receive food donations
  
  String[] genders = {"man", "women"};  //Possible gender labels used to pick the correct images
  
  //FIELDS
  // Hunger level category (controls colour + how much food they need)
  float hungerLvl; // 1–3 = green (served), 4–5 = yellow (takes 1 can), 6–7 = red (takes 5 cans), 8–10 = red (takes 8 cans)
  float waitTime; // Seconds spent waiting at their assigned line spot
  float angerLvl; // Anger level (currently equals waitTime)
  
  // Target position this person is moving toward (line spot or exit point)
  float targetx, targety;
  
  //Current position on screen
  float xPos, yPos; 
  
  int windowNumber; //  Assigned service window number (1–4)
  int posInLine; // Position in the line (0 = front, larger = farther back)
  String gender; // Randomly assigned gender string ("man" or "woman")
  boolean isServed; //boolean true to start the walk away animation .
                    //If false it will move the line up starting from -1000. 

  int spawnTime;      // True once they have reached their line spot at least once
  boolean atSpotOnce; // True once they have reached their line spot at least once
  int waitStartTime;  // Time (millis) when they first reached their line spot (start of waiting timer)
  int arrivalTime;    // Time (millis) when they first arrived at the line spot (used for first-come-first-serve)
  float hungerBeforeServed; // Hunger level captured right before being served (used to deduct correct food amount)
                    
  //CONSTRUCTOR
  // creates one community member at a start position and assigns a window
  Community(float xPos, float yPos, int windowNum) {
    
    // Start at yellow or red only (green is reserved for people who have already been served)
    this.hungerLvl = int(random(4, 10));  // hunger level 4–5 => yellow, 6–10 => red

    // Initialize wait/anger values
    this.waitTime = 0;
    this.angerLvl = 0;
    
    // Not leaving yet
    this.isServed = false;  
    
    // Set starting position (often off-screen so they walk into the line)
    this.xPos = xPos;
    this.yPos = yPos; 
    this.gender = genders[int(random(2))]; //use the gender array to get a random gender for image selection

    // Store the assigned service window number (1–4)
    this.windowNumber = windowNum;
   
    this.posInLine = -1; //  Line position is unknown at spawn and updateLinePositions() will assign it later
    this.spawnTime = millis(); // Record spawn time
    this.atSpotOnce = false; // They have not yet reached their line spot
    this.waitStartTime = 0; // Wait timer not started yet
    this.arrivalTime = -1; // Arrival time not set until they reach the line spot
    this.hungerBeforeServed = 0; // initialize hunger before served
    
    //Calculate which target x and target y form the posInLine and windowNumber. Done in constructor because so each community member immediately knows the target x and y.
    recalcTarget();
  }

  // helper to recalc targetx/targety from windowNumber + posInLine
  // posInLine 0 = first in line (closest to window, highest y)
  void recalcTarget() {
    
    // Window 1 line target location
    if (this.windowNumber == 1) {
      this.targetx = 160; 
      this.targety = 430 + this.posInLine * 30;
    }
    
    // Window 2 line target location
    else if(this.windowNumber == 2){
      this.targetx = 360;
      this.targety = 430 + this.posInLine * 30;
    }
    
    // Window 3 line target location
    else if (this.windowNumber == 3) {
      this.targetx = 560;
      this.targety = 430 + this.posInLine * 30;
    }
    
    // Window 4 line target location
    else{
      this.targetx = 760;
      this.targety = 430 + this.posInLine * 30;
    }
  }
  
  //Methods
  void drawCommunity() { 
    
    //to pick image and draw the images
    // GREEN (served) — hungerLvl 1–3
    if ( this.hungerLvl <=3 ){  
      if (gender.equals("man")) {
        //draw GREEN image at xPos yPos of MAN
        image(manImgGreen, this.xPos, this.yPos, 73, 197);
      }
      else{
        //draw GREEN image at xPos yPos of women
        
        image(womenImgGreen, this.xPos, this.yPos, 73, 197);
      }
    }
    
    // YELLOW — hungerLvl 4–5
    else if ( this.hungerLvl <= 5 ) {  
      if ( gender.equals("man")) {
        //draw YELLOW image at xPos yPos of MAN
        image(manImgYellow, this.xPos, this.yPos, 73, 197);
      }
      else {
        //draw of YELLOW image at xPos yPos of women
        image(womenImgYellow, this.xPos, this.yPos, 73, 197);
      }
    }
    
    // RED — hungerLvl 6–10
    else {    
      if ( gender.equals("man") ) {
        //draw RED image at xPos yPos of MAN
        image(manImgRed, this.xPos, this.yPos, 73, 197);
      }
      else {
        //draw RED image at xPos yPos of women
        image(womenImgRed, this.xPos, this.yPos, 73, 197);
      }
    }
  }
  
  //Moves the person toward their target position
  void moveCommunity() {
    
    // Smoothing factor (higher = faster movement toward target)
    float speed = 0.05; // so 2 pixals per frame
    
    // Move in X direction toward targetx
    // Always move towards target, even if close (helps with smooth movement when positions update)
    if(abs(xPos - targetx) > 0.5) {
      xPos += (targetx - xPos) * speed;
    } else {
      xPos = targetx; // snap to target when very close
    }
    
    // Move in Y direction toward targety
    if(abs(yPos - targety) > 0.5) {
      yPos += (targety - yPos) * speed;
    } else {
      yPos = targety; 
    }
  }

  //Returns true when the person has moved completely off-screen
  boolean hasLeftScreen() {
    return (xPos < -150 || xPos > width + 150);
  }

  // Returns true if the person is essentially standing at their target line spot
  boolean atLineSpot() {
    return abs(xPos - targetx) < 2 && abs(yPos - targety) < 2;
  }

  // update waiting time, hunger colour, and angry leaving if ALL windows closed
  void updateWaitingState() {
    if (isServed) return;  // once they're leaving / done, stop counting

    // only start counting wait time when they have reached their spot in line
    if (atLineSpot() && !atSpotOnce) {
      atSpotOnce = true;
      waitStartTime = millis();
      // Mark arrival time for first-come-first-serve ordering
      if (arrivalTime == -1) {
        arrivalTime = millis();
      }
    }
    if (!atSpotOnce) return; // they are still walking, don't change colour yet

    // seconds since they started waiting AT THEIR SPOT
    waitTime = (millis() - waitStartTime) / 1000.0;
    angerLvl = waitTime;   // more wait time more hungry

    // colour based on wait time:
    if (waitTime < 3) {
      // at least yellow (3-5 range)
      if (hungerLvl < 4) hungerLvl = 4;
    }
    else if (waitTime < 7) {
      // at least red
      if (hungerLvl < 6) hungerLvl = 6;
    }
    else {
      // deep red
      if (hungerLvl < 8) hungerLvl = 8;
    }

    // if all windows are closed, let them get angry and eventually leave
    boolean w1Open = !clicked1;
    boolean w2Open = !clicked2;
    boolean w3Open = !clicked3;
    boolean w4Open = !clicked4;
    boolean anyOpen = w1Open || w2Open || w3Open || w4Open;

    // only apply this "leave angry" logic when ALL windows are closed
    if (!anyOpen && waitTime > 2) {  // All windows are closed and have waited 2 seconds
      // they leave WITHOUT turning green (still hungry and mad)
      isServed = true;
      if (windowNumber == 1 || windowNumber == 2) {
        targetx = -120;          // exit left
      } else {
        targetx = width + 120;   // exit right
      }
      // keep targety so they slide off horizontally
    }
  }

  // reached the window (front of line)
  boolean hasArrivedAtWindow() {
    return atLineSpot() && !isServed;
  }

  // serve person IF this window is not already serving someone
  // returns true ONLY in the frame they just got food
    boolean checkServedAndExit(boolean[] windowOccupied) {
    // only if some windows are open
    boolean w1Open = !clicked1;
    boolean w2Open = !clicked2;
    boolean w3Open = !clicked3;
    boolean w4Open = !clicked4;
    boolean anyOpen = w1Open || w2Open || w3Open || w4Open;

    if (!anyOpen) return false;  // don't "serve" people if everything is closed

    // Only serve if they are at the front of the line (posInLine == 0)
    // and have arrived at the window
    if (hasArrivedAtWindow() && posInLine == 0 && !windowOccupied[windowNumber]) {
      // Calculate how much food they need
      int foodAmount = 1;
      if (hungerLvl >= 8) foodAmount = 8;
      else if (hungerLvl >= 6) foodAmount = 5;
      
      // Check if there's enough food available
      boolean hasFood = foodStock >= foodAmount;
      
      isServed = true;

      // store hunger level before serving (for food consumption calculation)
      hungerBeforeServed = hungerLvl;

      // mark this window as currently serving (only one green per window at a time)
      windowOccupied[windowNumber] = true;

      // Only make them green if food is available, otherwise keep them red (hungry)
      if (hasFood) {
        // make them green (1-3 range)
        hungerLvl = 1;
      } else {
        // No food available - keep them red (hungry)
        // Ensure they stay red by keeping hunger level high
        if (hungerLvl < 6) hungerLvl = 6;
      }

      // Set exit direction based on window side
      if (windowNumber == 1 || windowNumber == 2) {
        // left side windows -> exit left
        targetx = -120;
      } else {
        // right side windows -> exit right
        targetx = width + 120;
      }
      // keep targety the same so they slide out horizontally

      return hasFood;  // return true only if they actually got food
    }
    // Not served this frame
    return false;
  }
}

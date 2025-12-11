class Community { //homeless people

  
  String[] genders = {"man", "women"};  //for random man or women generator
  //Fields
  float hungerLvl; // 1-3 green. 3-5 yellow. 5-10 red. 
  float waitTime;
  float angerLvl; // more wait time more anger
  float targetx; // so the objects know where to move
  float targety;
  float xPos, yPos; // starts under -1000 so they would walk up 
  int windowNumber; // to chose the target x 
  int posInLine; // to chose the target y
  String gender; // diff imgs for man or women
  boolean isServed; //boolean true to start the walk away animation .
                    //If false it will move the line up starting from -1000. 

  int spawnTime;      // when created
  boolean atSpotOnce; // has reached their line spot at least once
  int waitStartTime;  // when they first reached their spot
  int arrivalTime;    // when they first arrived at their window (for first-come-first-serve)
  float hungerBeforeServed; // store hunger level before being served (for food consumption)
                    
  //Constucter
  Community(float xPos, float yPos ) {
    // start people somewhere between yellow and red (no green people in line)
    this.hungerLvl = int(random(4, 10));   // 4–5 => yellow, >5 => red

    this.waitTime = 0;
    this.angerLvl = 0;
    this.isServed = false;  
    this.xPos = xPos;
    this.yPos = yPos; 
    this.gender = genders[int(random(2))];

    // windows 1..4 (not 0..4)
    this.windowNumber = int(random(1, 5));
    this.posInLine = 999; // will be assigned based on arrival order
    this.spawnTime = millis();
    this.atSpotOnce = false;
    this.waitStartTime = 0;
    this.arrivalTime = -1; // not arrived yet
    this.hungerBeforeServed = 0; // initialize hunger before served
    
    //calc which target x and target y form the posInLine and windowNumber. done in constructor bc so each homeless guy immediately knows the target x and y.
    recalcTarget();
  }

  // helper to recalc targetx/targety from windowNumber + posInLine
  // posInLine 0 = first in line (closest to window, highest y)
  void recalcTarget() {
    if (this.windowNumber == 1) {
      this.targetx = 160; 
      this.targety = 530 - this.posInLine * 30;
    }
    else if(this.windowNumber == 2){
      this.targetx = 360;
      this.targety = 530 - this.posInLine * 30;
    }
    else if (this.windowNumber == 3) {
      this.targetx = 560;
      this.targety = 530 - this.posInLine * 30;
    }
    else{
      this.targetx = 760;
      this.targety = 530 - this.posInLine * 30;
    }
  }
  
  //Methods
  void drawHomeless() {
    //to pick img
    if ( this.hungerLvl <=3 ){  //RED
      if (gender.equals("man")) {
        //draw GREEN image at xPos yPos of MAN
        image(manImgGreen, this.xPos, this.yPos, 73, 197);
        
      }
      else{
        //draw GREEN image at xPos yPos of women
        
        image(womenImgGreen, this.xPos, this.yPos, 73, 197);
      }
    }
    
    else if ( this.hungerLvl <= 5 ) {   //YELLOW
      if ( gender.equals("man")) {
        //draw YELLOW image at xPos yPos of MAN
        image(manImgYellow, this.xPos, this.yPos, 73, 197);
      }
      else {
        //draw of YELLOW image at xPos yPos of women
        image(womenImgYellow, this.xPos, this.yPos, 73, 197);
      }
    }
    
    else {     //this.hungerlvl <= 10    //RED
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
  
  //next method:
  void moveHomeless() {
    float speed = 0.05; // so 2 pixals per frame
    
    // Always move towards target, even if close (helps with smooth movement when positions update)
    if(abs(xPos - targetx) > 0.5) {
      xPos += (targetx - xPos) * speed;
    } else {
      xPos = targetx; // snap to target when very close
    }
    
    if(abs(yPos - targety) > 0.5) {
      yPos += (targety - yPos) * speed;
    } else {
      yPos = targety; // snap to target when very close
    }
    
  }

  // check if they have fully walked off-screen
  boolean hasLeftScreen() {
    return (xPos < -150 || xPos > width + 150);
  }

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
    angerLvl = waitTime;   // more wait time more anger

    // colour based on wait time:
    // 0–3s  -> at least yellow
    // 3–7s  -> at least red
    // 7+s   -> very red
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
    if (!anyOpen && waitTime > 10) {  // waited too long (e.g. 10 seconds)
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
      isServed = true;

      // store hunger level before serving (for food consumption calculation)
      hungerBeforeServed = hungerLvl;

      // mark this window as currently serving (only one green per window at a time)
      windowOccupied[windowNumber] = true;

      // make them green (1-3 range)
      hungerLvl = 1;

      // decide exit direction
      if (windowNumber == 1 || windowNumber == 2) {
        // left side windows -> exit left
        targetx = -120;
      } else {
        // right side windows -> exit right
        targetx = width + 120;
      }
      // keep targety the same so they slide out horizontally

      return true;  // just got food this frame
    }
    return false;
  }
}

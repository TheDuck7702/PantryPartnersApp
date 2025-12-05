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
                    
  //Constucter
  Community(float xPos, float yPos ) {
    this.hungerLvl = int(random(1,10));
    this.waitTime = 0;
    this.angerLvl = 0;
    this.isServed = false;  
    this.xPos = xPos;
    this.yPos = yPos; 
    this.gender = genders[int(random(2))];
    this.windowNumber = int(random(5));
    this.posInLine = int(random(0, 6));
    
    
    //calc which target x and target y form the posInLine and windowNumber. done in constructor bc so each homeless guy immediately knows the target x and y.
    if (this.windowNumber == 1 || this.windowNumber == 0) {
      this.targetx = 160; 
      this.targety = 530 - this.posInLine * 30;
    }
    else if(this.windowNumber == 2){ // add teh window 3 and 4 coords
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
    
    if(abs(xPos - targetx) > 1) {
      xPos += (targetx - xPos) * speed;
    }
    
    if(abs(yPos - targety) > 1) {
      yPos += (targety - yPos) * speed;
    }
    
  }
}

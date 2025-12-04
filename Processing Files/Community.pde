class Community { //homeless people

  
  String[] genders = {"man", "women"};  //for random man or women generator
  //Fields
  float hungerLvl; // 1-3 green. 3-5 yellow. 5-10 red. 
  float waitTime;
  float angerLvl; // more wait time more anger
  float xPos, yPos; // starts under -1000 so they would walk up 
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
    
    
  }
}

class Community { //homeless people
  String[] genders = {"man", "woman"};  //for random man or woman generator
  //Fields
  float hungerLvl; // 1-3 green. 3-5 yellow. 5-10 red. 
  float waitTime;
  float angerLvl; // more wait time more anger
  float xPos, yPos; // starts under -1000 so they would walk up 
  String gender; // diff imgs for man or woman
  boolean isServed; //boolean true to start the walk away animation .
                    //If false it will move the line up starting from -1000. 
                    
  
  //Constucter
  Community(float xPos, float yPos, String gender, boolean isServed ) {
    this.hungerLvl = int(random(1,10));
    this.waitTime = 0;
    this.angerLvl = 0;
    this.isServed = false;  
    this.xPos = xPos; //600;
    this.yPos = yPos; //-1200;
    this.gender = genders[int(random(2))];
    
  }
  
  //Methods
  void drawHomeless() {
    //imgs are rly bad, GUI alr uses void setup, do i use Sample SE GUI?
    //PUT IMGS IN DATA FOLDER
    //image(manImgGreen, 200, 200 );
    
    //to pick img
    if ( this.hungerLvl <=3 ){  //RED
      if (gender.equals("man")) {  //i had to use .equals() as im comparing Strings not ints 
        //draw GREEN image at xPos yPos of MAN
      }
      else{
        //draw GREEN image at xPos yPos of WOMAN
      }
    }
    
    else if ( this.hungerLvl <= 5 ) {   //YELLOW
      if ( gender.equals("man")) {
        //draw YELLOW image at xPos yPos of MAN
      }
      else {
        //draw of YELLOW image at xPos yPos of WOMaN
      }
    }
    
    else {     //this.hungerlvl <= 10    //RED
      if ( gender.equals("man") ) {
        //draw RED image at xPos yPos of MAN
      }
      else {
        //draw RED image at xPos yPos of WOMAN
      }
    }
  }
  
  //next method:
}

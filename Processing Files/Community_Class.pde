class Community { //homeless people
  //Fields
  float hungerLvl; // 1-3 green. 3-5 yellow. 5-10 red. 
  float waitTime;
  float angerLvl; // more wait time more anger
  float xPos, yPos; // starts under -1000 so they would walk up 
  boolean isServed; //boolean true to start the walk away animation .
                    //If false it will move the line up starting from -1000. 
  
  //Constucter
  Community(float xPos, float yPos) {
    this.hungerLvl = int(random(1,10));
    this.waitTime = 0;
    this.angerLvl = 0;
    this.isServed = false;  
    this.xPos = 600;
    this.yPos = -1200;
    
  }
  
  //Methods
  void joinQueue() {
    
  }
}

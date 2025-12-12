//Food donation class
class foodDonor {
  
  //timestamp in milliseconds when the next donation should occur
  int nextDonationTime;
  
  //Min and max interval between donations (10 seconds to 1 min)
  int minInterval = 10000;
  int maxInterval = 60000;
  
  //Amount in cans of most recent donation 
  float donationAmount;
  
  //Set blank value for food donation update pop-up text
  String updateText = "";
  
  //Time when the text starts showing (0)
  int updateStartTime = 0;
  
  //Time when text should stop showing
  int updateDuration = 3500; // Text stays on screen for 3.5 seconds
  
  //Number of each type of can 
  int can1;
  int can2;
  int can3;
  
  //Total number of cans
  int canNum;
  
  //Constructor
  foodDonor(){ 
    
    //Schedule the first donation by computing the nextDonationTime.
    nextDonation(); 
    
    //Divide total cans into 3 parts (rounded num)
    this.canNum = int(foodStock/3);
    
    //Set number of cans 1 and 2 to canNum
    this.can1 = this.canNum;
    this.can2 = this.canNum;
    
    //Remainder (if any) becomes the amount of the third can
    this.can3 = foodStock - (this.canNum * 2);
  } 
  
  //Update stock of food throughout the program
  void updateStock() {    
    // If the current time has reached or passed the scheduled donation time, make a donation
    if (millis() >= nextDonationTime) {
      // Determine donation amount based on current weather
      this.donationAmount = generateDonationAmount(selectedWeatherName);  
      //Update total food stock with the donation amount
      foodStock += this.donationAmount; 
      // Calculate an integer chunk size for splitting the donation across the three buckets.
      this.canNum = int(this.donationAmount / 3);
      // Add the equal chunks to can1 and can2.
      this.can1 += this.canNum;
      this.can2 += this.canNum;
      // The third bucket gets the remainder so the sum of can1+can2+can3 increases by donationAmount.
      this.can3 += this.donationAmount - (this.canNum * 2);
      //Set update text to pop-up amiount donated
      this.updateText = "+" + int(this.donationAmount) + " cans of food donated!";
      //Record time text was displayed
      this.updateStartTime = millis();
       //Schedule the next donation time so donations keep happening periodically
      this.nextDonation();      
    }    
  } 
  
  //Function to determine next donation time 
  void nextDonation() {
    nextDonationTime = millis() + int(random(minInterval, maxInterval));    
  }  

  //Generate amount donated based on selected weather condition
  int generateDonationAmount(String selectedWeatherName) {
    
    //If weather is sunny, donate between 10-40 cans
    if (selectedWeatherName.equals("Sunny")) {
      return int(random(10, 40));
    } 
    
    //If weather is rainy, donate between 5-25 cans
    else if (selectedWeatherName.equals("Rainy")) {        
      return int(random(5, 25));        
    } 
    
    //If weather is cloudy, donate between 8-35 cans
    else if (selectedWeatherName.equals("Cloudy")) {        
      return int(random(8, 35));        
    }
    
    //If the weather is snowy, donate between 15-50 cans (holiday season)
    else {  //If snowy day then have the most donations, due seasonal campaigns such as Christmas drives     
      return int(random(15, 50));       
    }    
  }
  
  //Draw the food stock image and stats on the screen
  void drawFoodStock() {
    //Draw the image at the top right corner
      image(foodStockImg, 775, 25); 
      fill(0);
      textSize(25);
      //Number of cans in each type of can 
      text(this.can1, 825, 90);
      text(this.can2, 825, 130);
      text(this.can3, 825, 170);
  }
  
  //Display the donation update text to inform user that more food has been donated
  void updateStockText(){ 
     //Only draw the update text while the elapsed time since updateStartTime is less than updateDuration
    if (millis() - this.updateStartTime < this.updateDuration) {
      fill(0);
      textSize(15);
      //Draw the text pop-up right above the foodStock image
      text(this.updateText, 770, 20);
    }
  }  
  
  //Remove food from food stock based on how much is taken
  void consumeFood(int amount) {
    // reduce overall food stock but not below zero
    foodStock = max(0, foodStock - amount);

    // take from cans roughly evenly
    for (int i = 0; i < amount; i++) {
      //Prefer to remove from can1 if it's >= can2 and can3 and greater than zero
      if (can1 >= can2 && can1 >= can3 && can1 > 0) {
        can1--;
      } 
      //Else remove from can2 if it's >= can3 and greater than zero.
      else if (can2 >= can3 && can2 > 0) {
        can2--;
      } 
      //Otherwise remove from can3 if it has any cans available
      else if (can3 > 0) {
        can3--;
      }
    }
  }
} 

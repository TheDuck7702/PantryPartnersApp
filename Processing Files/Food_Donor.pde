class foodDonor {
  
  int nextDonationTime;
  
  int minInterval = 10000;
  int maxInterval = 60000;
  
  float donationAmount;
  
  String updateText = "";
  int updateStartTime = 0;
  int updateDuration = 2000;
  
  int can1;
  int can2;
  int can3;
  int canNum;
  
  foodDonor(){ 
    nextDonation();   
    this.canNum = int(foodStock/3);
    this.can1 = this.canNum;
    this.can2 = this.canNum;
    this.can3 = foodStock - (this.canNum * 2);
  } 
  
  void updateStock(){
    if(millis() >= nextDonationTime){
     this.donationAmount = generateDonationAmount(selectedWeatherName);  
     foodStock += this.donationAmount; 
     this.canNum = int(this.donationAmount / 3);
     this.can1 += this.canNum;
     this.can2 += this.canNum;
     this.can3 += this.donationAmount - (this.canNum*2);
     this.updateText = "+" + int(this.donationAmount) + " food donated!";
     this.updateStartTime = millis();
     this.nextDonation();      
    }    
  } 
  
  void nextDonation(){
    nextDonationTime = millis() + int(random(minInterval, maxInterval));    
  }  
  int generateDonationAmount(String selectedWeatherName){
    if(selectedWeatherName.equals("Sunny")){
      return int((random(10, 40)));
    }      
      else if(selectedWeatherName.equals("Rainy")){        
        return int((random(5, 25)));        
      }      
      else if(selectedWeatherName.equals("Cloudy")){        
        return int((random(8, 35)));        
      }      
      else{        
        return int((random(15, 50)));       
      }    
    }
    
    void drawFoodStock(){
      image(foodStockImg, 775, 25); 
      fill(0);
      textSize(25);
      text(this.can1, 825, 90);
      text(this.can2, 825, 130);
      text(this.can3, 825, 170);
      //NEED TO CHANGE TO DISPLAY DIF NUMBERS FOR EACH CAN 
    }
    
    void updateStockText(){ 
     if(millis() - this.updateStartTime < this.updateDuration){
       fill(0);
       textSize(15);
       text(this.updateText, 800, 20);
     }
    }  
}

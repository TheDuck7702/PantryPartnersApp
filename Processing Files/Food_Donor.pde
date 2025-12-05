class foodDonor {
  
  int nextDonationTime;
  
  int minInterval = 10000;
  int maxInterval = 60000;
  
  float donationAmount;
  
  String updateText = "";
  int updateStartTime = 0;
  int updateDuration = 2000;
  
  foodDonor(){ 
    nextDonation();   
  } 
  
  void updateStock(){
    if(millis() >= nextDonationTime){
     this.donationAmount = generateDonationAmount(selectedWeatherName);  
     foodStock += this.donationAmount; 
     updateText = "+" + int(this.donationAmount) + " food donated!";
     updateStartTime = millis();
     nextDonation();      
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
    }
    
    void updateStockText(){ 
     if(millis() - updateStartTime < updateDuration){
       fill(0);
       textSize(15);
       text(updateText, 800, 20);
     }
    }  
}

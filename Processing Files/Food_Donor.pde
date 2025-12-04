class foodDonor {
  
  int nextDonationTime;
  
  int minInterval = 10000;
  int maxInterval = 60000;
  
  float donationAmount;
  
  foodDonor(){
    
    nextDonation();
    
  }
  
  void updateStock(String weather){
    
    if(millis() >= nextDonationTime){

     this.donationAmount = generateDonationAmount(weather);
     
     foodStock += this.donationAmount;
     
     nextDonation();
      
    }
    
  }
  
  
  void nextDonation(){
    
    nextDonationTime = millis() + int(random(minInterval, maxInterval));
    
  }
  
  int generateDonationAmount(String selectedWeather){

      
      if(selectedWeather.equals("Sunny")){
        
        return int((random(10, 40)));
        
      }
      
      else if(selectedWeather.equals("Rainy")){
        
        return int((random(5, 25)));
        
      }
      
      else if(selectedWeather.equals("Cloudy")){
        
        return int((random(8, 35)));
        
      }
      
      else{
        
        return int((random(15, 50)));
        
      }
        
    }
    
  
}

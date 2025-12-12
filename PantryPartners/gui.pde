/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

// Starting window variables
GWindow startWindow;
GButton startButton;

void createStartWindow() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  
  startWindow = GWindow.getWindow(this, "Welcome to Pantry Partners", 0, 0, 600, 500, JAVA2D);
  startWindow.addDrawHandler(this, "startWindowDraw");
  startWindow.setActionOnClose(G4P.CLOSE_WINDOW);
  
  GLabel title = new GLabel(startWindow, 50, 30, 500, 40);
  title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  title.setText("Welcome to Pantry Partners!");
  title.setLocalColorScheme(GCScheme.CYAN_SCHEME);;
  title.setOpaque(false);
  
  GLabel instructions1 = new GLabel(startWindow, 20, 80, 500, 30);
  instructions1.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions1.setText("Instructions:");
  instructions1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  instructions1.setOpaque(false);
  
  GLabel instructions2 = new GLabel(startWindow, 50, 110, 500, 30);
  instructions2.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions2.setText("• Select the weather or season for the day from the dropdown menu");
  instructions2.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions2.setOpaque(false);
  
  GLabel instructions3 = new GLabel(startWindow, 50, 140, 500, 30);
  instructions3.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions3.setText("• Manage the food pantry and serve community members");
  instructions3.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions3.setOpaque(false);
  
  
  GLabel instructions4 = new GLabel(startWindow, 50, 170, 500, 30);
  instructions4.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions4.setText("• Monitor food stock levels in the top right corner");
  instructions4.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions4.setOpaque(false);
  
  
  GLabel instructions5 = new GLabel(startWindow, 50, 200, 500, 30);
  instructions5.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions5.setText("• Adjust the total number of people in line using the slider");
  instructions5.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions5.setOpaque(false);
  
  GLabel instructions6 = new GLabel(startWindow, 50, 230, 500, 30);
  instructions6.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions6.setText("• Open or close service windows as needed");
  instructions6.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  instructions6.setOpaque(false);
  
  GLabel instructions7 = new GLabel(startWindow, 20, 260, 500, 30);
  instructions7.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions7.setText("COLUR LEGEND:");
  instructions7.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  instructions7.setOpaque(false);
  
  GLabel instructions8 = new GLabel(startWindow, 50, 290, 500, 30);
  instructions8.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions8.setText("• Green: Satisfied person, has already received food.");
  instructions8.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  instructions8.setOpaque(false);
  
  GLabel instructions9 = new GLabel(startWindow, 50, 320, 500, 30);
  instructions9.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions9.setText("• Yellow: Very hungry person, will take 5 cans of food");
  instructions9.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  instructions9.setOpaque(false);
  
  GLabel instructions10 = new GLabel(startWindow, 50, 350, 500, 30);
  instructions10.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  instructions10.setText("• Red: Very hungry person, will take 8 cans of food");
  instructions10.setLocalColorScheme(GCScheme.RED_SCHEME);
  instructions10.setOpaque(false);
  
  startButton = new GButton(startWindow, 200, 390, 200, 60);
  startButton.setText("Start Simulation");
  startButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  startButton.addEventHandler(this, "startButtonClick");
  
  startWindow.loop();
}

synchronized public void startWindowDraw(PApplet appc, GWinData data) {
  appc.background(240, 248, 255);
}

public void startButtonClick(GButton source, GEvent event) {
  if (startWindow != null) {
    startWindow.noLoop();
    startWindow.setVisible(false);
    startWindow.dispose();
    startWindow = null;
  }
  initializeGame();
}

synchronized public void GUIWindowDraw(PApplet appc, GWinData data) { //_CODE_:GUIWindow:359935:
  appc.background(230);
} //_CODE_:GUIWindow:359935:

public void weatherControl(GDropList source, GEvent event) { //_CODE_:weather:376609:

  String selectedWeather = source.getSelectedText();
  // update global string used by foodDonor
  selectedWeatherName = selectedWeather;
  
  int type = 0; // default Sunny
  if (selectedWeather.equals("Sunny")) {
    type = 0;
  } 
  else if (selectedWeather.equals("Cloudy")) {
    type = 1;
  } 
  else if (selectedWeather.equals("Rainy")) {
    type = 2;
  } 
  else if (selectedWeather.equals("Snowy")) {
    type = 3;
  }

  // update Weather object
  weatherSystem.setWeather(type);
}

public void maxPeopleInLineSlider(GCustomSlider source, GEvent event) { //_CODE_:maxPeopleInLine:800754:
  totalPeople = maxPeopleInLine.getValueI();  
  // Don't rebuild array here - maintainPeopleCount() will handle maintaining the count
}

public void button1_click1(GButton source, GEvent event) { //_CODE_:button1:515551:
  resetGame();
} //_CODE_:button1:515551:

public void openOrClosedBox1(GCheckbox source, GEvent event) { //_CODE_:openOrClosed1:449196:
  clicked1 = !clicked1;
}

public void openOrClosedBox2(GCheckbox source, GEvent event) { //_CODE_:openOrClosed2:716764:
  clicked2 = !clicked2;
} //_CODE_:openOrClosed2:716764:

public void openOrClosedBox3(GCheckbox source, GEvent event) { //_CODE_:openOrClosed3:914672:
  clicked3 = !clicked3;
} 

public void openOrClosedBox4(GCheckbox source, GEvent event) { //_CODE_:openOrClosed4:296472:
  clicked4 = !clicked4;
} //_CODE_:openOrClosed4:296472:

public void showFoodBox(GCheckbox source, GEvent event) { //_CODE_:showFood:950188:
  println("showFood - GCheckbox >> GEvent." + event + " @ " + millis());
  showFoodStock = !showFoodStock;
} //_CODE_:showFood:950188:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  GUIWindow = GWindow.getWindow(this, "GUI", 0, 0, 400, 300, JAVA2D);
  GUIWindow.noLoop();
  GUIWindow.setActionOnClose(G4P.KEEP_OPEN);
  GUIWindow.addDrawHandler(this, "GUIWindowDraw");
  openOrClosed1 = new GCheckbox(GUIWindow, 20, 200, 120, 20);
  openOrClosed1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  openOrClosed1.setText("Window 1 Open?");
  openOrClosed1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  openOrClosed1.setOpaque(false);
  openOrClosed1.addEventHandler(this, "openOrClosedBox1");
  openOrClosed1.setSelected(true);
  weather = new GDropList(GUIWindow, 100, 60, 90, 100, 4, 10);
  weather.setItems(loadStrings("list_376609"), 0);
  weather.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  weather.addEventHandler(this, "weatherControl");
  weather2 = new GLabel(GUIWindow, 20, 60, 80, 20);
  weather2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  weather2.setText("Weather");
  weather2.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  weather2.setOpaque(false);
  maxPeopleInLine = new GCustomSlider(GUIWindow, 100, 120, 100, 40, "purple18px");
  maxPeopleInLine.setShowValue(true);
  maxPeopleInLine.setLimits(5, 5, 10);
  maxPeopleInLine.setNbrTicks(5);
  maxPeopleInLine.setShowTicks(true);
  maxPeopleInLine.setNumberFormat(G4P.INTEGER, 0);
  maxPeopleInLine.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  maxPeopleInLine.setOpaque(false);
  maxPeopleInLine.addEventHandler(this, "maxPeopleInLineSlider");
  peopleInLine = new GLabel(GUIWindow, 20, 120, 80, 40);
  peopleInLine.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  peopleInLine.setText("Max Num Of Peope In Line");
  peopleInLine.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  peopleInLine.setOpaque(false);
  button1 = new GButton(GUIWindow, 260, 130, 80, 30);
  button1.setText("Reset");
  button1.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  button1.addEventHandler(this, "button1_click1");
  openOrClosed2 = new GCheckbox(GUIWindow, 20, 250, 120, 20);
  openOrClosed2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  openOrClosed2.setText("Window 2 Open?");
  openOrClosed2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  openOrClosed2.setOpaque(false);
  openOrClosed2.addEventHandler(this, "openOrClosedBox2");
  openOrClosed2.setSelected(true);
  openOrClosed3 = new GCheckbox(GUIWindow, 220, 200, 120, 20);
  openOrClosed3.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  openOrClosed3.setText("Window 3 Open?");
  openOrClosed3.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  openOrClosed3.setOpaque(false);
  openOrClosed3.addEventHandler(this, "openOrClosedBox3");
  openOrClosed3.setSelected(true);
  openOrClosed4 = new GCheckbox(GUIWindow, 220, 250, 120, 20);
  openOrClosed4.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  openOrClosed4.setText("Window 4 Open?");
  openOrClosed4.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  openOrClosed4.setOpaque(false);
  openOrClosed4.addEventHandler(this, "openOrClosedBox4");
  openOrClosed4.setSelected(true);
  instructions = new GLabel(GUIWindow, 0, 15, 400, 20);
  instructions.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  instructions.setText("You can adjust the following controls to alternate the outcome");
  instructions.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  instructions.setOpaque(false);
  showFood = new GCheckbox(GUIWindow, 220, 60, 150, 20);
  showFood.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  showFood.setText("Show Food Supply?");
  showFood.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  showFood.setOpaque(false);
  showFood.addEventHandler(this, "showFoodBox");
  showFood.setSelected(true);
  GUIWindow.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow GUIWindow;
GCheckbox openOrClosed1; 
GDropList weather; 
GLabel weather2; 
GCustomSlider maxPeopleInLine; 
GLabel peopleInLine; 
GButton button1; 
GCheckbox openOrClosed2; 
GCheckbox openOrClosed3; 
GCheckbox openOrClosed4; 
GLabel instructions; 
GCheckbox showFood; 

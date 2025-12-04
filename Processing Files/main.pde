import g4p_controls.*;
PImage manImgGreen;

Community c;

int foodStock = 100;

void setup(){
  //gui
  size(1000, 1200);
  createGUI();
  c = new Community(50, 10); // spawns 1 tweaker
                             //tweaker too large need to resize
                             //someome make thhe building class
  manImgGreen = loadImage("homeless_guy.png");

  

  //c.drawHomeless();
}

void draw(){
  //background(0);
  c.drawHomeless(); 
  //image(manImgGreen, 200, 200);
}

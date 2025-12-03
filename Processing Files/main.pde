import g4p_controls.*;

PImage manImgGreen;

void setup(){
  //gui
  size(1000, 1200);
  createGUI();
  
  //init imgs
  manImgGreen = loadImage("homeless_guy.png");
  //manImgYellow = loadImage();
  //manImgRed = loadImage(); 
}

void draw(){
  background(0);

  image(manImgGreen, 400, 30);
}

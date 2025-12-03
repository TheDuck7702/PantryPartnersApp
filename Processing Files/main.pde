import g4p_controls.*;

Community c;

PImage manImgGreen;
PImage manImgYellow;
PImage manImgRed;

PImage womanImgGreen;
PImage womanImgYellow;
PImage womanImgRed;

void setup(){
  //gui
  size(1000, 1200);
  createGUI();
  
  //init imgs
  manImgGreen = loadImage("homeless_guy.png");
  manImgYellow = loadImage("manImgYellow.png");
  manImgRed = loadImage("manImgRed.png");
  
  womanImgGreen = loadImage("womanImgGreen.png");
  womanImgYellow = loadImage("womanImgYellow.png");
  womanImgRed = loadImage("womanImgRed.png");
  
  //manImgYellow = loadImage();
  //manImgRed = loadImage(); 
}

void draw(){
  background(0);

  image(manImgGreen, 400, 30);
}

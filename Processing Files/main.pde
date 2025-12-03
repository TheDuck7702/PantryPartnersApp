import g4p_controls.*;

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
feiefej
  //manImgYellow = loadImage();
  //manImgRed = loadImage(); 
}

void draw(){
  background(0);

  image(manImgGreen, 400, 30);
}

import controlP5.*;

ControlP5 cp5;
ControlP5 button;

int backgroundR = 0, backgroundG = 0,   backgroundB = 0;
int deadCellR = 0,   deadCellG = 0,     deadCellB = 0;
int livingCellR = 0, livingCellG = 255, livingCellB = 0;



void sliders() {
  cp5 = new ControlP5(this);
  
  
  //slider initiated
  
  int x = 10;
  int y = 10;
  
  int distanceY = 40;
  int distanceGroup = 20;
  // addSlider(nom de la fenêtre, min, max, valeur par défaut, x1, y1, x2, y2)



  // background colours
  cp5.addSlider("backgroundR", 0, 255, backgroundR, x, y += distanceY, 200, 30);
  cp5.addSlider("backgroundG", 0, 255, backgroundG, x, y += distanceY, 200, 30);
  cp5.addSlider("backgroundB", 0, 255, backgroundB, x, y += distanceY, 200, 30);
   
  y += distanceGroup;
  
  // living cell's colours
  cp5.addSlider("livingCellR", 0, 255, livingCellR, x, y += distanceY, 200, 30);
  cp5.addSlider("livingCellG", 0, 255, livingCellG, x, y += distanceY, 200, 30);
  cp5.addSlider("livingCellB", 0, 255, livingCellB, x, y += distanceY, 200, 30);

  y += distanceGroup;

  // dead cell's colours
  cp5.addSlider("deadCellR", 0, 255, deadCellR, x, y += distanceY, 200, 30);
  cp5.addSlider("deadCellG", 0, 255, deadCellG, x, y += distanceY, 200, 30);
  cp5.addSlider("deadCellB", 0, 255, deadCellB, x, y += distanceY, 200, 30);

  y += distanceGroup;

  // cell size
  cp5.addSlider("cellSize", 5, 20, cellSize, x, y += distanceY, 200, 30);

  y += distanceGroup;

  // update interval
  cp5.addSlider("interval", 100, 1000, 300, x, y += distanceY, 200, 30);
};

Button doc;



void button() {
  cp5 = new ControlP5(this);

  cp5.addToggle("togglePause")
       .setPosition(10,10)
       .setImages(loadImage("disabled.png"), loadImage("disabled.png"), loadImage("enabled.png"))
       .updateSize();
}

void docButton () {
  button = new ControlP5(this);
  
  button.addButton("doc")
    .setPosition(width - 50, height - 50)
    .setSize(40, 40);
      
  
}

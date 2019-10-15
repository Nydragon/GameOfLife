import controlP5.*;

ControlP5 jControl;

// Taille des cellules
int cellSize = 5;

// Pourcentage des cellules vivantes au début
float probCellsAliveStart = 15;

// Variables pour le temps
int interval = 50;
int lastRecordedTime = 0;



// Tableau de cellules
int[][] cells; 
//Tampon pour enregistrer l'état des cellules et l'utiliser tout en modifiant les autres dans les interations
int[][] cellsBuffer; 

//OPTION : 
// Pause
boolean pause = false;

// Taille de la fenêtre de l'executable
public void settings() {
  size(1280, 720);
}

//variables for the colors of the background
int backgroundR = 0;
int backgroundG = 0;
int backgroundB = 0;

void setup() {
  
  jControl = new ControlP5(this);
  
  //slider initiated
  Slider sR = jControl.addSlider("backgroundR", 0, 255, 100, 10, 10, 200, 30);
  Slider sG = jControl.addSlider("backgroundG", 0, 255, 100, 10, 50, 200, 30);
  Slider sB = jControl.addSlider("backgroundB", 0, 255, 100, 10, 90, 200, 30);
  
  // Initialisation des tableaux
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // Dessiner le background en blanc


  // Initialisation des cellules
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      float state = random (100);
      if (state > probCellsAliveStart) { 
        state = 0;
      } else {
        state = 1;
      }
      cells[x][y] = int(state); // Sauvegarder l'état de chaque cellule
    }
  }
  background(255); // Remplir en blanc si les cases ne couvrent pas toutes les fenêtres
}

// Couleur des cases vivantes ou mortes
color alive = color(0, 200, 0);
color dead = color(0);

void draw() {
  stroke(backgroundR, backgroundG, backgroundB);
  //Dessiner la grille
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      if (cells[x][y] == 1) {
        fill(alive); // Cellule vivante
      } else {
        fill(dead); // Cellule morte
      }
      rect (x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
  
  // Itérer si la minuterie ..
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }
  
  // créer nouvelles cellules manuellement en pause
  if (pause && mousePressed) {
    // Mapper et eviter les erreurs hots limites
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Verifier les cellules dans le tampon
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cellule en vie
      cells[xCellOver][yCellOver]=0; // Tuer
      fill(dead); // remplir avec couleur de tuer
    }
    else { // Cellule morte
      cells[xCellOver][yCellOver]=1; // Faire revivre
      fill(alive); // Remplir avec couleur de vie
    }
  }
  else if (pause && !mousePressed) { // Et puis sauvegarder dans le tampon une fois que la souris monte
  // Sauvegarder les cellules dans le tampon (on opère donc avec un tableau en gardant l'autre intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}

void iteration() {
  // Quand minuterie arrive à zero
  // Sauvegarder les cellules dans le tampon (on opère donc avec un tableau en gardant l'autre intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  // Visiter chaque cellule
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // Visiter les voisins de chque cellule
      int neighbours = 0;//On compte les voisins
      for (int xx=x-1; xx<=x+1; xx++) {
        for (int yy=y-1; yy<=y+1; yy++) {
          if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<height/cellSize))) {  // S'assurer qu'on reste dans les limites
            if (!((xx==x)&&(yy==y))) {    // Verifier la cellule
              if (cellsBuffer[xx][yy]==1) {
                neighbours ++;   // Verfier les voisins
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      if (cellsBuffer[x][y]==1) {   // La cellule est en vie : la tuer si necessaire
        if (neighbours < 2 || neighbours > 3) {
          cells[x][y] = 0;   // Mourir sauf si il a 2/3 voisins
        }
      } else {   // La cellule est morte : la ranimer si necessaire
        if (neighbours == 3 ) {
          cells[x][y] = 1;    // Seulement si elle a 3 voisins
        }
      } // End of if
    } // End of y loop
  } // End of x loop
} // End of function

// OPTION : 
// Si on allume manuellement une cellule
void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart : réinitialisation des cellules (TOUCHE 'R' ??)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        if (state > probCellsAliveStart) {
          state = 0;
        } else {
          state = 1;
        }
        cells[x][y] = int(state);  // Sauver l'état des cellules
      }
    }
  }
  if (key==' ') { // ON/OFF de pause (TOUCHE BARRE ESPACE ??)
    pause = !pause;
  }
  if (key=='c' || key == 'C') { // // Faire un clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Tout remettre à zeros
      }
    }
  }
}

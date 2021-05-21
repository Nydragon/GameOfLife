// PROBLEMES A REGLES
// Ajouter commentaires pour les variables et pour les lignes de code confuses
// La togglePause en jeu ne fonctionne pas
// Cellules ne bougent pas sur les lignes extérieures -> Pourquoi ??

Toggle boutonPlay;

float prevY;

float lastFrameY;

float LivingCellCounter = 0;
float DeadCellCounter = 0;
float percentage = 0;
float LivingCell = 0;
float DeadCell = 0;

// Pourcentage des cellules vivantes au début
float probCellsAliveStart = 15;

// Variables pour le temps
int interval = 10;
int lastRecordedTime = 0;

// Tableau de cellules
int[][] cells;
//Tampon pour enregistrer l'état des cellules et l'utiliser tout en modifiant les autres dans les interations
int[][] cellsBuffer;

//OPTION :
// togglePause
boolean togglePause = false;

// Taille de la fenêtre de l'executable
public void settings() {
  size(1200, 800);
//  String[] args = {"TwoFrameTest"};
//  Graph sa = new Graph();
//  PApplet.runSketch(args, sa);
}

// Taille des cellules
int cellSize = 5;

// Couleur des cases mortes
color dead = color(0);


void setup() {
   surface.setTitle("The Circle of Life");

  sliders();

  // Initialisation des tableaux
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];


  // Initialisation des cellules
  for(int x = 0; x < width/cellSize; x++) {
    for(int y = 0; y < height/cellSize; y++) {
      float state = random (100);
      if(state > probCellsAliveStart) {
        state = 0;
      } else {
        state = 1;
      }
      cells[x][y] = int(state); // Sauvegarder l'état de chaque cellule
    }
  }
  background(255); // Remplir en blanc si les cases ne couvrent pas toutes les fenêtres
}


void draw() {
  stroke(backgroundR, backgroundG, backgroundB);
  //Dessiner la grille
  for(int x = 0; x < width/cellSize; x++) {
    for(int y = 0; y < height/cellSize; y++) {
      if(cells[x][y] == 1) {
        LivingCellCounter++;
        fill(livingCellR, livingCellG, livingCellB); // Cellule vivante
      } else {
        DeadCellCounter++;
        fill(deadCellR, deadCellG, deadCellB); // Cellule morte
      }
      rect (x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
  DeadCell = DeadCellCounter;
  LivingCell = LivingCellCounter;

  percentage =  (LivingCell / (LivingCell + DeadCell)) * 100.0 ;
  percentage = percentage * 1000;
  percentage = round(percentage);
  percentage = percentage/1000;
  //println(round(LivingCell) + " / " + round(DeadCell) + " / " + percentage +"%");

  LivingCellCounter = 0;
  DeadCellCounter = 0;
  // Itérer si la minuterie ..
  if(millis() - lastRecordedTime > interval) {
    if(togglePause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // créer nouvelles cellules manuellement en togglePause
  if(togglePause == false && mousePressed) {

    // Mapper et eviter les erreurs hots limites
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Verifier les cellules dans le tampon
    if(cellsBuffer[xCellOver][yCellOver] == 1) { // Cellule en vie
      cells[xCellOver][yCellOver] = 0; // Tuer
      fill(dead); // remplir avec couleur de tuer
    } else { // Cellule morte
      cells[xCellOver][yCellOver] = 1; // Faire revivre
      fill(livingCellR, livingCellG, livingCellB); // Remplir avec couleur de vie
    }
  } else if(togglePause && !mousePressed) { // Et puis sauvegarder dans le tampon une fois que la souris monte
    // Sauvegarder les cellules dans le tampon (on opère donc avec un tableau en gardant l'autre intact)
    for(int x = 0; x < width/cellSize; x++) {
      for(int y = 0; y < height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
  line(frameCount-1, 100-lastFrameY, frameCount, 100-frameRate);
  lastFrameY = frameRate;
}

void iteration() {
  // Quand minuterie arrive à zero
  // Sauvegarder les cellules dans le tampon (on opère donc avec un tableau en gardant l'autre intact)
  for(int x = 0; x < width/cellSize; x++) {
    for(int y = 0; y < height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visiter chaque cellule
  for(int x = 0; x < width/cellSize; x++) {
    for(int y = 0; y < height/cellSize; y++) {
      // Visiter les voisins de chaque cellule
      int neighbours = 0; //On compte les voisins
      for(int xx = x-1; xx <= x+1; xx++) {
        for(int yy = y-1; yy <= y+1; yy++) {
          if(((xx >= 0) && (xx < width/cellSize)) && ((yy >= 0) && (yy < height/cellSize))) {  // S'assurer qu'on reste dans les limites
            if(!((xx == x)&&(yy == y))) {   // Verifier la cellule
              if(cellsBuffer[xx][yy] == 1) {
                neighbours++;   // Verifier les voisins
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } // End of xx loop
      if(cellsBuffer[x][y] == 1) {   // La cellule est en vie : la tuer si necessaire
        if(neighbours < 2 || neighbours > 3) {
          cells[x][y] = 0;   // Mourir sauf si il a 2/3 voisins
        }
      } else {   // La cellule est morte : la ranimer si necessaire
        if(neighbours == 3 ) {
          cells[x][y] = 1;    // Seulement si elle a 3 voisins
        }
      } // End of if
    } // End of y loop
  } // End of x loop
} // End of function



// OPTION :
void keyPressed() {
  if(key == 'r' || key == 'R') {
    for(int x = 0; x < width/cellSize; x++) {
      for(int y = 0; y < height/cellSize; y++) {
        float state = random (100);
        if(state > probCellsAliveStart) {
          state = 0;
        } else {
          state = 1;
        }
        cells[x][y] = int(state);  // Sauver l'état des cellules
      }
    }
  }

  if(key == ' ') {
    boutonPlay.setValue(!togglePause);
  }

  if(key == 'c' || key == 'C') {
    for(int x = 0; x < width/cellSize; x++) {
      for(int y = 0; y < height/cellSize; y++) {
        cells[x][y] = 0;
      }
    }
  }
}

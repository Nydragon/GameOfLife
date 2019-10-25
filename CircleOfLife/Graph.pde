public class Graph extends PApplet {

  public void settings() {
    size(300, 200);
    background(0);
  }

  void setup() {
    frameRate(30);
    drawStuff();
  }

  void draw() {
    float plotVar = -percentage;
    stroke(255, 0, 0);
    line(frameCount - 1, (prevY + 300), frameCount, (plotVar + 200));
    prevY = percentage;
  }

  void drawStuff() {
    clear();

    for (int i = 0; i <= width; i += 50) {
      fill(0, 255, 0);
      text(i/2, i - 10, height - 15);
      stroke(255);
      line(i, height, i, 1);
    }

    for (int j = 0; j < height; j += 33) {
      fill(0, 255, 0);
      text(6 - j/(height/6), 0, j);
      stroke(255);
      line(0, j, width, j);
    }
  }
}

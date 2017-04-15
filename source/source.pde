Component[] activeComps = new Component[1000];
Component[] historyComps = new Component[1000];
int numComps = 0, numHistoryComps = 0;

PFont fnt;
PGraphics g;

void setup() {
  size(500, 500);
  fnt = createFont("Monospaced-48", 16, true);
  g = createGraphics(500, 500);
  
  g.beginDraw();
  g.smooth();
  resetStyle(g);
  g.textFont(fnt, 16);
  g.endDraw();
  
  drawScene();
}

void resetStyle(PGraphics g) {
  g.strokeWeight(3);
  g.stroke(255);
  g.fill(255);
}

Cursor cursor = new Cursor();
Mode mode = new SelectionMode();

void keyDown(int code) {
  mode.select(code);
  mode.key(code);
  drawScene();
}

void draw() {
  updateInput();
  
  if (fastMode && keyDownLong[fastKey]) {
    mode.select(fastKey);
    
    // draw for fast mode
    drawScene();
  }
  if (mode.name == "label") {
     drawScene(); // so that blinker updates
  }
  
  println(frameRate);
}

void drawScene() {
  g.beginDraw();
  g.background(0);
  
  cursor.draw(g);
  mode.draw(g);
  
  for (int i = 0; i < numComps; i++) {
    activeComps[i].draw(g);
  }
  g.endDraw();
  
  image(g, 50, 50);
}

// save reversed out image (black on white)
void printScene() {
  save("out");
  println("Saved");
}
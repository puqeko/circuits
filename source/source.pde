Component[] activeComps = new Component[1000];
Component[] historyComps = new Component[1000];
int numComps = 0, numHistoryComps = 0;

boolean isPrintStyle = false;

PFont fnt;
PGraphics g;

void setup() {
  size(500, 500);
  SCALE = 2;
  smooth();
  // leave this, then use noSmooth + blur and custom
  // downscaling for image export.
  
  fnt = createFont("Monospaced-48", 16, true);
  g = createGraphics(500, 500);
  
  g.beginDraw();
  resetStyle(g);
  g.textFont(fnt, 16);
  g.endDraw();
  
  drawScene();
}

void resetStyle(PGraphics g) {
  resetThick(g);
  
  if (!isPrintStyle) {
    g.stroke(255);
    g.fill(255);
  } else {
    g.stroke(0);
    g.fill(0);
  }
  
  g.strokeCap(SQUARE);
}

void thickStyle(PGraphics g) {
  g.strokeWeight(4 * SCALE);
}

void resetThick(PGraphics g) {
  g.strokeWeight(2 * SCALE);
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
  
  //println(frameRate);
}

void drawScene() {
  background(0);
  g.beginDraw();
  g.clear();
  
  cursor.draw(g);
  mode.draw(g);
  
  for (int i = 0; i < numComps; i++) {
    activeComps[i].draw(g);
  }
  g.endDraw();
  if (!isPrintStyle) image(g, 0, 0, 500, 500);
}

// save reversed out image (black on white)
void printScene() {
  isPrintStyle = true;
  
  resetStyle(g);
  drawScene();
  g.save("out.png");
  isPrintStyle = false;
  drawScene();
  println("Saved");
}
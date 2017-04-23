Component[] activeComps = new Component[1000];
Component[] historyComps = new Component[1000];
int numComps = 0, numHistoryComps = 0;

boolean isPrintStyle = false;
color drawingColour = color(0);
color printBackground = color(255);
float alpha = 0;

PFont fnt;
PGraphics g;

void setup() {
  size(500, 500);
  
  initScene(); // init graphics and font
  drawScene();
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
  background(253, 246, 227);
  g.beginDraw();
  g.background(
    isPrintStyle ? printBackground : drawingColour,
    isPrintStyle ? 255 : alpha);
  g.endDraw();
  
  g.beginDraw();
  cursor.draw(g);
  mode.draw(g);
  
  for (int i = 0; i < numComps; i++) {
    activeComps[i].draw(g);
  }
  g.endDraw();
  if (!isPrintStyle) image(g, 0, 0, 500, 500);
}

// save reversed out image (black on white)
void printScene(boolean transparent) {
  isPrintStyle = !transparent; // set white background if not transparent
  cursor.isSuppressed = true;
  resetStyle(g);
  drawScene();
  g.save("out.png");
  isPrintStyle = false;
  cursor.isSuppressed = false;
  resetStyle(g);
  drawScene();
  println("Saved");
}
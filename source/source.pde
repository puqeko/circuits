Component[] activeComps = new Component[1000];
Component[] historyComps = new Component[1000];
int numComps = 0, numHistoryComps = 0;

boolean isPrintStyle = false;
color drawingColour = color(0);

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
  g.background(drawingColour, 0);
  g.endDraw();
  
  g.beginDraw();
  if (!isPrintStyle) cursor.draw(g);
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
  drawingColour = color(0);
  resetStyle(g);
  drawScene();
  g.save("out.png");
  isPrintStyle = false;
  drawingColour = color(0); //toggle
  resetStyle(g);
  drawScene();
  println("Saved");
}
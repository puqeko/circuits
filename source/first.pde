Component[] activeComps = new Component[1000];
Component[] historyComps = new Component[1000];
int numComps = 0, numHistoryComps = 0;

void setup() {
  size(500, 500);
  stroke(255);
  fill(255);
  strokeWeight(2);
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
}

void drawScene() {
  background(0);
  drawScene(false);
}

// save reversed out image (black on white)
void printScene() {
  stroke(0);
  fill(0);
  background(255);
  drawScene(true);
  save("out");
  stroke(255);
  fill(255);
  
  println("Saved");
  drawScene();
}

void drawScene(boolean forPrint) {
  
  if (!forPrint) cursor.draw();
  mode.draw();
  
  for (int i = 0; i < numComps; i++) {
    activeComps[i].draw();
  }
}
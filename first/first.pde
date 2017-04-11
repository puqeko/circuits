Component[] activeComps = new Component[100];
int numComps = 0;

void setup() {
  size(500, 500);
  fill(0);
  smooth();
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
  background(204);
  cursor.draw();
  mode.draw();
  
  for (int i = 0; i < numComps; i++) {
    activeComps[i].draw();
  }
}

float leng(int x, int y, int u, int v) {
  return sqrt(sq(u - x) + sq(v - y));
}
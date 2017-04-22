void undo() {
  println("undo");
  if (numComps > 0)
    historyComps[numHistoryComps++] = activeComps[--numComps];
}

void redo() {
  println("redo");
  if (numHistoryComps > 0)
    activeComps[numComps++] = historyComps[--numHistoryComps];
}

float leng(float x, float y, float u, float v) {
  return sqrt(sq(u - x) + sq(v - y));
}

void arrow(PGraphics g, float x, float y, float u, float v, float arrSize) {
  float len = leng(x, y, u, v);
  
  g.pushMatrix();
  g.translate(x, y);
  g.rotate(atan2(v-y, u-x));
  g.line(0, 0, len, 0);
  
  g.beginShape();
  g.vertex(len - arrSize - 2, arrSize/2);
  g.vertex(len - 2, 0);
  g.vertex(len - arrSize - 2, -arrSize/2);
  g.endShape();
  
  g.popMatrix();
}

// Special styles

void textTopStyle(PGraphics g) {
  g.textAlign(CENTER, BOTTOM);
}

void textSideStyle(PGraphics g) {
  g.textAlign(LEFT, CENTER);
}

void textLeftStyle(PGraphics g) {
  g.textAlign(RIGHT, CENTER);
}

void thickStyle(PGraphics g) {
  g.strokeWeight(4 * SCALE);
  // note that 1, 3, 6 etc align with pixel grid, but look shit for circles.
}

void resetThick(PGraphics g) {
  g.strokeWeight(2 * SCALE);
}

void resetStyle(PGraphics g) {
  resetThick(g);
  
  g.stroke(drawingColour);
  g.fill(drawingColour);
  g.strokeCap(SQUARE);
}

void initScene() {
    smooth();
  // leave this, then use noSmooth + blur and custom
  // downscaling for image export.
  
  fnt = createFont("Monospaced-48", 16, true);
  g = createGraphics(500, 500);
  
  g.beginDraw();
  resetStyle(g);
  textTopStyle(g);
  g.textFont(fnt, 16);
  g.endDraw();
}
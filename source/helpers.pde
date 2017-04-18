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
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

float leng(int x, int y, int u, int v) {
  return sqrt(sq(u - x) + sq(v - y));
}
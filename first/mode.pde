class Mode {
  String name;
  
  void draw() {}
  void key(int code) {}
  
  int step = 10;
  void select(int code) {
    switch(code) {
      case LEFT: cursor.x -= step; break;
      case RIGHT: cursor.x += step; break;
      case UP: cursor.y -= step; break;
      case DOWN: cursor.y += step; break;
    }
  }
}

// allways active
class Cursor extends Mode {
  int x = 50, y = 50;
  
  Cursor() {
    super.name = "cursor";
  }
  
  @Override void draw() {
    rectMode(CENTER);
    rect(x - x % 10, y - y % 10, 5, 5);
  }
}

class SelectionMode extends Mode {
  SelectionMode() {
    super.name = "select";
    println(super.name);
  }
  
  @Override void key(int code) {
    switch(code) {
      case ' ':
         mode = new DrawMode();
    }
  }
}

class DrawMode extends Mode {
  
  int x, y;
  Component cur;
  
  DrawMode() {
    super.name = "draw";
    x = cursor.x; y = cursor.y;
    cur = new Wire(x, y, x + 1, y);
    println(super.name);
  }
  
  @Override void key(int code) {
    switch(code) {
      case ENTER:
      case RETURN:
      case ESC:
         mode = new SelectionMode();
         break;
      case ' ':
         activeComps[numComps++] = cur;
         mode = new DrawMode();
         break;
      case 'r': cur = new Resistor(x, y, cursor.x, cursor.y); break;
      case 'w': cur = new Wire(x, y, cursor.x, cursor.y); break;
      case 'c': cur = new Capacitor(x, y, cursor.x, cursor.y); break;
      case 'i': cur = new Inductor(x, y, cursor.x, cursor.y); break;
      case 'b': cur = new Cell(x, y, cursor.x, cursor.y); break;
      case 'o': cur = new Terminal(x, y, cursor.x, cursor.y); break;
    }
  }
  
  @Override void draw() {
    cur.resize(x, y, cursor.x, cursor.y);
    cur.draw();
  }
}
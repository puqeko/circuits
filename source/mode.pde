class Mode {
  String name;
  
  void draw() {}
  void key(int code) {}
  
  int step = 10;
  void select(int code) {
    switch(code) {
      case LEFT: case 'a': case 'A': case 'h': case 'H': cursor.x -= step; break;
      case RIGHT: case 'd': case 'D': case 'l': case 'L': cursor.x += step; break;
      case UP: case 'w': case 'W': case 'k': case 'K': cursor.y -= step; break;
      case DOWN: case 's': case 'S': case 'j': case 'J': cursor.y += step; break;
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
         break;
      case 'p':
        printScene(); // print mode
        break;
      case 'u': // undo
        undo();
        break;
      case 'R': // redo
        redo();
        break;
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
      case ESC:
      case DELETE:
      case 8: // delete mac / backspace
         mode = new SelectionMode();
         break;
      case ENTER:
      case RETURN:
        cur.terminates = true;
      case ' ':
         activeComps[numComps++] = cur;
         if (cur.terminates) mode = new SelectionMode();
         else mode = new DrawMode();
         break;
      case 'u': // undo
        undo();
        break;
      case 'R': // redo
        redo();
        break;
      case 'r': cur = new Resistor(x, y, cursor.x, cursor.y); break;
      case 'e': case ';': cur = new Wire(x, y, cursor.x, cursor.y); break;
      case 'c': cur = new Capacitor(x, y, cursor.x, cursor.y); break;
      case 'i': cur = new Inductor(x, y, cursor.x, cursor.y); break;
      case 'b': cur = new Cell(x, y, cursor.x, cursor.y); break;
      case 'o': cur = new Terminal(x, y, cursor.x, cursor.y); break;
    }
  }
  
  @Override void select(int code) {
    // behaviour by qaudrent
    int u = cursor.x - x, v = cursor.y - y;
    //println(u, v);
    
    // on x-axis
    
    if (v == 0) {
      switch(code) {
        case LEFT: case 'a': case 'A': case 'h': case 'H': cursor.x -= step; break; // can move left and right
        case RIGHT: case 'd': case 'D': case 'l': case 'L': cursor.x += step; break;
        case UP: case 'w': case 'W': case 'k': case 'K':
          if (u == 0) cursor.y -= step; // at center
          else moveToDiag(code, u, v);
          break;
        case DOWN: case 's': case 'S': case 'j': case 'J':
          if (u == 0) cursor.y += step; // at center
          else moveToDiag(code, u, v);
          break;
      }
    }
    
    // on y-axis
    
    else if (u == 0) { 
      switch(code) {
        case UP: case 'w': case 'W': case 'k': case 'K': cursor.y -= step; break; // can move up and down
        case DOWN: case 's': case 'S': case 'j': case 'J': cursor.y += step; break;
        case LEFT: case 'a': case 'A': case 'h': case 'H': moveToDiag(code, u, v); break; // since allready handled center case
        case RIGHT: case 'd': case 'D': case 'l': case 'L': moveToDiag(code, u, v); break;
      }
    } 
    
    // in diagonal position
    
    else if (code == DOWN || code == 's' || code == 'S' || code == 'j' || code == 'J') {
      if (v > 0) extendDiag(u, v); // bellow x-axis
      else moveToAxis(u, v, 0, v); // above, so move down to x-axis, -ve since above is -ve v value
    }
    
    else if (code == UP || code == 'w' || code == 'W' || code == 'k' || code == 'K') {
      if (v > 0) moveToAxis(u, v, 0, v); //bellow axis, so move up to it
      else extendDiag(u, v); // above so extend
    }
    
    else if (code == LEFT || code == 'a' || code == 'A' || code == 'h' || code == 'H') {
      if (u < 0) extendDiag(u, v);
      else moveToAxis(u, v, u, 0);
    }
    
    else if (code == RIGHT || code == 'd' || code == 'D' || code == 'l' || code == 'L') {
      if (u < 0) moveToAxis(u, v, u, 0); // since v is -ve
      else extendDiag(u, v);
    }
  }
  
  @Override void draw() {
    cur.resize(x, y, cursor.x, cursor.y);
    cur.draw();
  }
  
  // draw mode helpers
  
  void moveToDiag(int code, int u, int v) {
    if (v == 0) //on x-axis
      cursor.y += abs(u) * (code == UP || code == 'w' || code == 'W' || code == 'k' || code == 'K' ? -1 : 1);
    else // on y-axis
      cursor.x += abs(v) * (code == LEFT || code == 'a' || code == 'A' || code == 'h' || code == 'H' ? -1 : 1);
  }
  
  // u, v, and scaling factor as u, 0 or 0, v
  void moveToAxis(int a, int b, int u, int v) {
    
    // 16 is shift key
    if (keyDown[16]) {
      cursor.x -= u; // shift is held, so allow changing angles
      cursor.y -= v;
    } else {
      extendDiag(-a, -b);
    }
  }
  
  void extendDiag(int u, int v) {
    int m = (u > 0 ? 1 : -1);
    if (u == v) {
      cursor.x += m * cursor.step;
      cursor.y += m * cursor.step;
    } else {
      cursor.x += m * cursor.step;
      cursor.y += -m * cursor.step;
    }
  }
  
}
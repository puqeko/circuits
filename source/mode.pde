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
    
    // keep in screen bounds
    if (cursor.x < 0) cursor.x = 0;
    if (cursor.y < 0) cursor.y = 0;
    if (cursor.x > 500) cursor.x = 500;
    if (cursor.y > 500) cursor.y = 500;
  }
}

// allways active
class Cursor extends Mode {
  int x = 50, y = 50;
  boolean freeze = false;
  
  Cursor() {
    super.name = "cursor";
  }
  
  @Override void draw() {
    rectMode(CENTER);
    rect(x - x % 10, y - y % 10, 5, 5);
  }
  
  @Override void select(int code) {
    if (!freeze) super.select(code);
  }
}

class LabelMode extends Mode {
  
  Component c;
  int time;
  boolean blink = false;
  String text = "";
  
  LabelMode(Component cm) {
    super.name = "LabelMode";
    
    if (!cm.labeled) {
      this.key(ESC); // pull out
    }
    
    cursor.freeze = true;
    c = cm;
    time = millis();
  }
  
  @Override void draw() {
    if (text != "") c.labelText = text;
    else {
      c.labelText = blink ? "_" : "";
      
      int curTime = millis();
      if (curTime - time > 500) {
        time = curTime;
        blink = !blink;
      }
    }
  }
  
  @Override void select(int code) {
    if (code >= 48 && code <= 122) { //common chars
          text += char(code);
    } else if (code == 8) { // delete
      if (text.length() > 0) text = text.substring(0, text.length() - 1);
    }
  }
  
  @Override void key(int code) {
    switch(code) {
      case ESC:
        c.labelText = "";
      case RETURN:
      case ENTER:
      case ' ':
      case LEFT: case RIGHT: case UP: case DOWN:
      case 'j': case 'k': case 'l': case 'h':
      case 'w': case 'a': case 's': case 'd':
        cursor.freeze = false;
        if (c.labelText == "_") c.labelText = "";
        mode = new DrawMode();
        break;
    }
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
      case 's':
      case 'p':
        printScene(); // print mode
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
         
         println(cur.labeled);
         if (cur.terminates) mode = new SelectionMode();
         else if (keyDown[16] || !cur.labeled) mode = new DrawMode(); // shift to bipass entering label text
         else mode = new LabelMode(cur);
         break;
      case 'u': // undo
        println("undo");
        if (numComps > 0)
          historyComps[numHistoryComps++] = activeComps[--numComps];
        break;
      case 'R': // redo
        if (numHistoryComps > 0)
          activeComps[numComps++] = historyComps[--numHistoryComps];
        break;
      case 'r': cur = new Resistor(x, y, cursor.x, cursor.y); break;
      case 'w': cur = new Wire(x, y, cursor.x, cursor.y); break;
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
        case LEFT: cursor.x -= step; break; // can move left and right
        case RIGHT: cursor.x += step; break;
        case UP:
          if (u == 0) cursor.y -= step; // at center
          else moveToDiag(code, u, v);
          break;
        case DOWN:
          if (u == 0) cursor.y += step; // at center
          else moveToDiag(code, u, v);
          break;
      }
    }
    
    // on y-axis
    
    else if (u == 0) { 
      switch(code) {
        case UP: cursor.y -= step; break; // can move up and down
        case DOWN: cursor.y += step; break;
        case LEFT: moveToDiag(code, u, v); break; // since allready handled center case
        case RIGHT: moveToDiag(code, u, v); break;
      }
    } 
    
    // in diagonal position
    
    else if (code == DOWN) {
      if (v > 0) extendDiag(u, v); // bellow x-axis
      else moveToAxis(u, v, 0, v); // above, so move down to x-axis, -ve since above is -ve v value
    }
    
    else if (code == UP) {
      if (v > 0) moveToAxis(u, v, 0, v); //bellow axis, so move up to it
      else extendDiag(u, v); // above so extend
    }
    
    else if (code == LEFT) {
      if (u < 0) extendDiag(u, v);
      else moveToAxis(u, v, u, 0);
    }
    
    else if (code == RIGHT) {
      if (u < 0) moveToAxis(u, v, u, 0); // since v is -ve
      else extendDiag(u, v);
    }
  }
  
  void moveToDiag(int code, int u, int v) {
    if (v == 0) //on x-axis
      cursor.y += abs(u) * (code == UP ? -1 : 1);
    else // on y-axis
      cursor.x += abs(v) * (code == LEFT ? -1 : 1);
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
  
  @Override void draw() {
    cur.resize(x, y, cursor.x, cursor.y);
    cur.draw();
  }
}
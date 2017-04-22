class Mode {
  String name;
  
  void draw(PGraphics g) {}
  void key(int code) {}
  
  int step = 10;
  void select(int code) {
    switch(code) {
      case LEFT: case 'a': case 'A': /* case 'h': case 'H': */ cursor.x -= step; break;
      case RIGHT: case 'd': case 'D': /* case 'l': case 'L': */ cursor.x += step; break;
      case UP: case 'w': case 'W': /* case 'k': case 'K': */ cursor.y -= step; break;
      case DOWN: case 's': case 'S': /* case 'j': case 'J': */ cursor.y += step; break;
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
  
  @Override void draw(PGraphics g) {
    g.rectMode(CENTER);
    g.rect(x - x % 10, y - y % 10, 5, 5);
  }
  
  @Override void select(int code) {
    if (!freeze) super.select(code);
  }
}

class LabelMode extends Mode {
  
  Component c;
  int time = 0;
  boolean blink = true; // start with _ char
  String text = "";
  
  LabelMode(Component cm) {
    super.name = "label";
    println(super.name);
    
    if (!cm.isLabeled) {
      this.key(ESC); // pull out
    }
    
    cursor.freeze = true;
    c = cm;
    time = millis();
  }
  
  @Override void draw(PGraphics g) {
    if (text.length() > 0) c.labelText = text;
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
    // 32 is space
    if ((code >= 48 && code <= 122) || code == 32 || code == ' ') { //common chars
          text += char(code);
          println("add");
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
      case LEFT: case RIGHT: case UP: case DOWN:
        cursor.freeze = false;
        if (c.labelText == "_") c.labelText = "";
        if (c.isTerminating) mode = new SelectionMode();
        else mode = new DrawMode();
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
        cur.isTerminating = true;
      case ' ':
         if (leng(x, y, cursor.x, cursor.y) > cur.minLen / 2) {
           activeComps[numComps++] = cur;
         
           if (!cur.isLabeled) {
             if (cur.isTerminating) mode = new SelectionMode();
             else mode = new DrawMode();
           } else if (keyDown[16]) { // shift override
             mode = new DrawMode();
           } else {
             mode = new LabelMode(cur);
           }
         } else { // discard if too short
           mode = new SelectionMode();
         }
         break;
      case 'u': // undo
        undo();
        break;
      case 'R': // redo
        redo();
        break;
      case 'r': cur = new Resistor(x, y, cursor.x, cursor.y); break;
      case ';': cur = new Wire(x, y, cursor.x, cursor.y); break;
      case 'c': cur = new Capacitor(x, y, cursor.x, cursor.y); break;
      case 'l': cur = new Inductor(x, y, cursor.x, cursor.y); break;
      case 'b':
        if (cur instanceof Cell) cur = new TwoCell(x, y, cursor.x, cursor.y);
        else cur = new Cell(x, y, cursor.x, cursor.y);
        break;
      case 'o': cur = new Terminal(x, y, cursor.x, cursor.y); break;
      case 'i':
        if (!(cur instanceof CurrentSource)) {
          cur = new CurrentSource(x, y, cursor.x, cursor.y);
          break;
        }
        // else make dependant
      case 'I': cur = new DepCurrentSource(x, y, cursor.x, cursor.y); break;
      case 'v':
        if (!(cur instanceof VoltageSource)) {
          cur = new VoltageSource(x, y, cursor.x, cursor.y);
          break;
        }
        // else make dependant
      case 'V': cur = new DepVoltageSource(x, y, cursor.x, cursor.y); break;
      case 'g': cur = new Ground(x, y, cursor.x, cursor.y); break;
      case 't':
        // toggle 
        boolean isPNP = true;
        if (cur instanceof BJTransistor)
          ((BJTransistor)cur).isPNP = !((BJTransistor)cur).isPNP;
        else cur = new BJTransistor(x, y, cursor.x, cursor.y, isPNP);
        break;
      case 'f':
        // toggle 
        boolean isNChannel = true;
        if (cur instanceof FETransistor)
          ((FETransistor)cur).isNChannel = !((FETransistor)cur).isNChannel;
        else cur = new FETransistor(x, y, cursor.x, cursor.y, isNChannel);
        break;
    }
  }
  
  @Override void select(int code) {
    // behaviour by qaudrent
    int u = cursor.x - x, v = cursor.y - y;
    //println(u, v);
    
    // on x-axis
    
    if (v == 0) {
      switch(code) {
        case LEFT: case 'a': case 'A': /* case 'h': case 'H': */ cursor.x -= step; break; // can move left and right
        case RIGHT: case 'd': case 'D': /* case 'l': case 'L': */ cursor.x += step; break;
        case UP: case 'w': case 'W': /* case 'k': case 'K': */
          if (u == 0) cursor.y -= step; // at center
          else moveToDiag(code, u, v);
          break;
        case DOWN: case 's': case 'S': /* case 'j': case 'J': */
          if (u == 0) cursor.y += step; // at center
          else moveToDiag(code, u, v);
          break;
      }
    }
    
    // on y-axis
    
    else if (u == 0) { 
      switch(code) {
        case UP: case 'w': case 'W': /* case 'k': case 'K': */ cursor.y -= step; break; // can move up and down
        case DOWN: case 's': case 'S': /* case 'j': case 'J': */ cursor.y += step; break;
        case LEFT: case 'a': case 'A': /* case 'h': case 'H': */ moveToDiag(code, u, v); break; // since allready handled center case
        case RIGHT: case 'd': case 'D': /* case 'l': case 'L': */ moveToDiag(code, u, v); break;
      }
    } 
    
    // in diagonal position
    
    else if (code == DOWN || code == 's' || code == 'S' /* || code == 'j' || code == 'J' */) {
      if (v > 0) extendDiag(u, v); // bellow x-axis
      else moveToAxis(u, v, 0, v); // above, so move down to x-axis, -ve since above is -ve v value
    }
    
    else if (code == UP || code == 'w' || code == 'W' /* || code == 'k' || code == 'K' */) {
      if (v > 0) moveToAxis(u, v, 0, v); //bellow axis, so move up to it
      else extendDiag(u, v); // above so extend
    }
    
    else if (code == LEFT || code == 'a' || code == 'A' /* || code == 'h' || code == 'H' */) {
      if (u < 0) extendDiag(u, v);
      else moveToAxis(u, v, u, 0);
    }
    
    else if (code == RIGHT || code == 'd' || code == 'D' /* || code == 'l' || code == 'L' */) {
      if (u < 0) moveToAxis(u, v, u, 0); // since v is -ve
      else extendDiag(u, v);
    }
  }
  
  @Override void draw(PGraphics g) {
    cur.resize(x, y, cursor.x, cursor.y);
    cur.draw(g);
  }
  
  // draw mode helpers
  
  void moveToDiag(int code, int u, int v) {
    if (v == 0) //on x-axis
      cursor.y += abs(u) * (code == UP || code == 'w' || code == 'W' /* || code == 'k' || code == 'K' */ ? -1 : 1);
    else // on y-axis
      cursor.x += abs(v) * (code == LEFT || code == 'a' || code == 'A' /* || code == 'h' || code == 'H' */ ? -1 : 1);
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
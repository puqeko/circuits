
//int x = 10, y = 10;
//int x1, y1;
//Component[] qu = new Component[100];
//int len = 0;

//void setup() {
//  size(500, 500);
//  fill(0);
//  smooth();
//  strokeWeight(2);
//}

//int mode = 0;
//boolean once = false;
//boolean run = false;
//int runCount = 0;
//boolean terminated = false;

//String type = "ind";

//void keyDown() {
//  print(key);
//}

//void draw() {
//  background(204);
//  rectMode(CENTER);
//  rect(x - x % 10, y - y % 10, 5, 5);
  
//  if (keyPressed) {
//    runCount++;
//  } else {
//    runCount = 0;
//  }
  
//  run = runCount > 15;
  
//  if ((!once || run) && keyPressed && key == CODED) {
//    int mult = 10; once = true;
//    switch(keyCode) {
//      case LEFT: x -= mult; break;
//      case RIGHT: x += mult; break;
//      case UP: y -= mult; break;
//      case DOWN: y += mult; break;
//    }
//  } else if (!keyPressed) {
//    once = false;
//  }
  
//  for (int i = 0; i < len; i++) {
//    qu[i].draw();
//  }
  
//  if (mode == 0) {
//    if (keyPressed && key == ' ' && !terminated) {
//      mode = 1;
//      x1 = x;
//      y1 = y;
//    }
//    else if (!keyPressed) terminated = false;
//  } else if (mode == 1) {
//    Component c;
//    switch(type) {
//      case "res": c = new Resistor(x, y, x1, y1); break;
//      case "cap": c = new Capacitor(x, y, x1, y1); break;
//      case "ind": c = new Inductor(x, y, x1, y1); break;
//      case "cell": c = new Cell(x, y, x1, y1); break;
//      case "term": c = new Terminal(x, y, x1, y1); break;
//      default: c = new Wire(x, y, x1, y1);
//    }
//    c.x = x1;
//    c.y = y1;
//    c.xend = x;
//    c.yend = y;
//    c.draw();
    
//    if (keyPressed) {
//      switch(key) {
//        case ' ':
//          if (leng(x, y, x1, y1) > 5) {
//            qu[len] = c;
//            y1 = y;
//            x1 = x;
//            len ++;
            
//            if (c.terminates) {
//              mode = 0;
//              terminated = true;
//            }
//            type = "wire";
//          }
//          break;
//        case 'r': type = "res"; break;
//        case 'w': type = "wire"; break;
//        case 'c': type = "cap"; break;
//        case 'i': type = "ind"; break;
//        case 'b': type = "cell"; break;
//        case 'o': type = "term"; break;
//      }
//    }
    
//    if (keyPressed && (key == ENTER | key == RETURN)) {
//      mode = 0;
//      type = "wire";
      
//      if (leng(x, y, x1, y1) > 5) {
//        qu[len] = c;
//        y1 = y;
//        x1 = x;
//        len ++;
//      }
//    }
//  }
//}

//float leng(int x, int y, int u, int v) {
//  return sqrt(sq(u - x) + sq(v - y));
//}
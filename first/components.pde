class Component {
  float scale = 4;
  float len, minLen;
  float x, y;
  float xend, yend;
  boolean terminates = false;
  
  void draw() {
    pushMatrix();
    translate(x, y);
    pushMatrix();
    rotate(atan2(yend - y, xend - x));
    drawShape();
    popMatrix();
    drawText();
    popMatrix();
  }
  
  void drawShape() {
    line(0, 0, 0 + len, 0);
  }
  
  void drawText() {
    
  }
}

class Resistor extends Component {
  
  float zigs = 3, zigLen;
  float tails;
  
  // from x, y to u, v
  Resistor(int x, int y, int u, int v) {
    zigLen = 4 * super.scale * zigs;
    minLen = zigLen + 4 * super.scale;
    len = max(leng(x, y, u, v), minLen);
    tails = (len - zigLen) / 2;
  }
  
  @Override void drawShape() {
    float i = super.scale;
    float x = 0 + tails, y = 0;
    
    line(0, 0, x, y);
    
    float start = 0, j = 0;
    for (j = 0; j < 3; j++) {
      start = x + j * 4 * i;
      line(start, y, start + 1 * i, y + 2 * i);
      line(start + 1 * i, y + 2 * i, start + 3 * i, y - 2 * i);
      line(start + 3 * i, y - 2 * i, start + 4 * i, y);
    }
    
    line(start + 4 * i, y, start + 4 * i + tails, y);
  }
}

class Inductor extends Component {
  
  float zigs = 3, zigLen;
  float tails;
  
  // from x, y to u, v
  Inductor(int x, int y, int u, int v) {
    zigLen = 4 * super.scale * zigs;
    minLen = zigLen + 4 * super.scale;
    len = max(leng(x, y, u, v), minLen);
    tails = (len - zigLen) / 2;
  }
  
  @Override void drawShape() {
    float i = super.scale;
    float x = tails;
    
    line(0, 0, x, 0);
    noFill();
    float start = 0, j = 0;
    for (j = 0; j < 3; j++) {
      start = x + j * 4 * i;
      arc(start + 2 * i, 0, 4 * i, 8 * i, -PI, 0);
    }
    fill(0);
    line(start + 4 * i, 0, start + 4 * i + tails, 0);
  }
}

class Capacitor extends Component {
  
  float capLen = super.scale * 2;
  float tails;
  
  // from x, y to u, v
  Capacitor(int x, int y, int u, int v) {
    minLen = super.scale * 4;
    len = max(leng(x, y, u, v), minLen);
    tails = (len - capLen) / 2;
  }
  
  @Override void drawShape() {
    float i = super.scale;
    float x = 0 + tails;
    
    line(0, 0, x, 0);
    //strokeWeight(2);
    line(x, 0 - i * 4, x, 0 + i * 4);
    float capEnd = x + capLen;
    line(capEnd, 0 - i * 4, capEnd, 0 + i * 4);
    //strokeWeight(1);
    line(capEnd, 0, capEnd + tails, 0);
  }
}

class Cell extends Component {
  
  float capLen = super.scale * 2;
  float tails;
  
  // from x, y to u, v
  Cell(int x, int y, int u, int v) {
    minLen = super.scale * 4;
    len = max(leng(x, y, u, v), minLen);
    tails = (len - capLen) / 2;
  }
  
  @Override void drawShape() {
    float i = super.scale;
    float x = 0 + tails;
    
    line(0, 0, x, 0);
    //strokeWeight(2);
    line(x, 0 - i * 2, x, 0 + i * 2);
    float capEnd = x + capLen;
    line(capEnd, 0 - i * 5, capEnd, 0 + i * 5);
    //strokeWeight(1);
    line(capEnd, 0, capEnd + tails, 0);
  }
}

class Terminal extends Component {
  
  float capLen = super.scale * 2;
  float tails;
  
  // from x, y to u, v
  Terminal(int x, int y, int u, int v) {
    super.terminates = true;
    minLen = super.scale * 4;
    len = max(leng(x, y, u, v), minLen);
    tails = (len - capLen) / 2;
  }
  
  @Override void drawShape() {
    float i = super.scale;
    float x = 0 + tails;
    
    line(0, 0, x, 0);
    //strokeWeight(2);
    noFill();
    ellipseMode(CENTER);
    ellipse(x + i, 0, 2 * i, 2 * i);
    fill(0);
  }
}

class Wire extends Component {
  
  Wire(int x, int y, int u, int v) {
    super.len = max(super.scale, leng(x, y, u, v));
    super.minLen = super.scale;
  }
}
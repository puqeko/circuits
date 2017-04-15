class Component {
  float scale = 4;
  float len, minLen;
  int x, y;
  float xend, yend;
  
  boolean terminates = false;
  boolean labeled = true;
  String labelText = "";
  int labelDistanceFactor = 6;
  
  void draw(PGraphics g) {
    g.pushMatrix();
    g.translate(x, y);
    g.pushMatrix();
    
    float ang = atan2(yend - y, xend - x);
    g.rotate(ang);
    
    if (x > xend) g.scale(1, -1); // correct orientation
    drawShape(g);
    
    g.popMatrix();
    if (labeled && labelText.length() > 0) {
      drawText(g, ang);
    }
    g.popMatrix();
  }
  
  void drawShape(PGraphics g) {
    g.line(0, 0, 0 + len, 0);
  }
  
  void drawText(PGraphics g, float ang) {
    // To do: Add centering adjustment
    
    // midpoint
    float xnew = len * cos(ang) / 2;
    float ynew = len * sin(ang) / 2;
    
    // adjust to place left or on top of component
    ang += PI/2 * (ang <= - PI/2 || ang > PI/2 ? -1 : 1);
    
    g.text(labelText,
      xnew - cos(ang) * scale * labelDistanceFactor,
      ynew - sin(ang) * scale * labelDistanceFactor);
  }
  
  void resize(int x1, int y1, int u, int v) {
    x = x1; y = y1;
    xend = u; yend = v;
    len = max(leng(x, y, u, v), minLen);
  }
}

class Resistor extends Component {
  
  float zigs = 3, zigLen;
  float tails;
  
  // from x, y to u, v
  Resistor(int x, int y, int u, int v) {
    super.labelDistanceFactor = 5;
    zigLen = 4 * super.scale * zigs;
    minLen = zigLen + 4 * super.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - zigLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    float x = 0 + tails, y = 0;
    
    g.line(0, 0, x, y);
    float start = 0, j = 0;
    thickStyle(g);
    for (j = 0; j < 3; j++) {
      start = x + j * 4 * i;
      g.line(start, y, start + 1 * i, y + 2 * i);
      g.line(start + 1 * i, y + 2 * i, start + 3 * i, y - 2 * i);
      g.line(start + 3 * i, y - 2 * i, start + 4 * i, y);
    }
    resetThick(g);
    g.line(start + 4 * i, y, start + 4 * i + tails, y);
  }
}

class Inductor extends Component {
  
  float zigs = 3, zigLen;
  float tails;
  
  // from x, y to u, v
  Inductor(int x, int y, int u, int v) {
    super.labelDistanceFactor = 7;
    zigLen = 4 * super.scale * zigs;
    minLen = zigLen + 4 * super.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - zigLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    float x = tails;
    
    g.line(0, 0, x, 0);
    g.noFill();
    float start = 0, j = 0;
    thickStyle(g);
    for (j = 0; j < 3; j++) {
      start = x + j * 4 * i;
      g.arc(start + 2 * i, 0, 4 * i, 8 * i, -PI, 0);
    }
    resetThick(g);
    g.fill(255);
    g.line(start + 4 * i, 0, start + 4 * i + tails, 0);
  }
}

class Capacitor extends Component {
  
  float capLen = super.scale * 2;
  float tails;
  
  // from x, y to u, v
  Capacitor(int x, int y, int u, int v) {
    super.labelDistanceFactor = 7;
    minLen = super.scale * 4;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - capLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    float x = 0 + tails;
    
    g.line(0, 0, x, 0);
    thickStyle(g);
    g.line(x, 0 - i * 4, x, 0 + i * 4);
    float capEnd = x + capLen;
    g.line(capEnd, 0 - i * 4, capEnd, 0 + i * 4);
    resetThick(g);
    g.line(capEnd, 0, capEnd + tails, 0);
  }
}

class Cell extends Component {
  
  float capLen = super.scale * 2;
  float tails;
  
  // from x, y to u, v
  Cell(int x, int y, int u, int v) {
    minLen = super.scale * 4;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - capLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    float x = 0 + tails;
    
    g.line(0, 0, x, 0);
    thickStyle(g);
    g.line(x, 0 - i * 2, x, 0 + i * 2);
    float capEnd = x + capLen;
    g.line(capEnd, 0 - i * 5, capEnd, 0 + i * 5);
    resetThick(g);
    g.line(capEnd, 0, capEnd + tails, 0);
  }
}

class Terminal extends Component {
  // from x, y to u, v
  Terminal(int x, int y, int u, int v) {
    super.terminates = true;
    super.minLen = super.scale * 4;
    super.resize(x, y, u, v);
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    
    g.line(0, 0, super.len - 4 * i, 0);
    g.ellipse(super.len - 3 * i, 0, 2 * i, 2 * i);
  }
  
  @Override void drawText(PGraphics g, float ang) {
    // adjust to place left or on top of component
    //ang += PI/2 * (ang <= - PI/2 || ang > PI/2 ? -1 : 1);
    
    g.text(labelText, len + super.scale * 2, 6);
  }
}

class Wire extends Component {
  
  Wire(int x, int y, int u, int v) {
    super.minLen = 1;
    super.resize(x, y, u, v);
    super.labeled = false;
  }
}
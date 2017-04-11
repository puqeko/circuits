class Component {
  float scale = 4;
  float len, minLen;
  float x, y;
  float xend, yend;
  
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
  
  @Override void drawText() {
    
  }
}

class Wire extends Component {
  
  Wire(int x, int y, int u, int v) {
    super.len = max(super.scale, leng(x, y, u, v));
    super.minLen = super.scale;
  }
}
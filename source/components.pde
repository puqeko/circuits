float SCALE = 1;

class Component {
  float scale = SCALE * 4;
  float len, minLen;
  int x, y;
  float xend, yend;
  
  float labelOffset = 6;
  
  boolean isTerminating = false;
  boolean isLabeled = false;
  boolean shouldMirror = false;
  String labelText = "";
  
  void draw(PGraphics g) {
    g.pushMatrix();
    g.translate(x, y);
    g.pushMatrix();
    
    float ang = atan2(yend - y, xend - x);
    g.rotate(ang);
    
    if (x > xend || // correct orientation
      (x == xend && y > yend)) { // consisent vertial case
      
      if (shouldMirror) g.scale(1, -1);
    }
    
    drawShape(g);
    
    g.popMatrix();
    if (isLabeled && labelText.length() > 0) {
      drawText(g, ang);
    }
    g.popMatrix();
  }
  
  void drawShape(PGraphics g) {
    g.line(0, 0, len, 0);
  }
  
  void drawText(PGraphics g, float ang) {
    
    // midpoint
    float xnew = len * cos(ang) / 2;
    float ynew = len * sin(ang) / 2;
    float offset = labelOffset;
    
    // adjust to place left or on top of component
    ang += PI/2 * (ang <= - PI/2 || ang > PI/2 ? -1 : 1);
    
    if (x != xend && y == yend) textTopStyle(g); // x-axis
    else if (y != yend && x == xend) textSideStyle(g); // y-axis
    else {
      offset += 2; // extra room when diagonal
      
      if (xend - x == yend - y) // +ve/-ve diagonals
        textSideStyle(g);
      else textLeftStyle(g); // oppisite diagonals
    }
    
    g.text(labelText,
      xnew - cos(ang) * scale * offset,
      ynew - sin(ang) * scale * offset);
  }
  
  void resize(int x1, int y1, int u, int v) {
    x = x1; y = y1;
    xend = u; yend = v;
    len = max(leng(x, y, u, v), minLen);
  }
}

class Wire extends Component {
  Wire(int x, int y, int u, int v) {
    this.minLen = 1;
    this.resize(x, y, u, v);
  }
} 

class Resistor extends Component {
  
  float zigs = 3, zigLen;
  float tails;
  
  // from x, y to u, v
  Resistor(int x, int y, int u, int v) {
    this.isLabeled = true;
    this.labelOffset = 3;
    zigLen = 4 * this.scale * zigs;
    minLen = zigLen + 4 * this.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - zigLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = this.scale;
    float x = 0 + tails, y = 0;
    
    g.line(0, 0, x, y);
    float start = 0, j = 0;
    thickStyle(g);
    g.noFill();
    g.strokeJoin(BEVEL);
    g.beginShape();
    g.vertex(x + j * 4 * i, y - 1);
    for (j = 0; j < 3; j++) {
      start = x + j * 4 * i;
      g.vertex(start + 1 * i, y + 2 * i);
      g.vertex(start + 3 * i, y - 2 * i);
      g.vertex(start + 4 * i, y + 1);
    }
    g.endShape();
    resetStyle(g);
    g.line(start + 4 * i, y, start + 4 * i + tails, y);
  }
}

class Inductor extends Component {
  
  float zigs = 3, zigLen;
  float tails;
  
  // from x, y to u, v
  Inductor(int x, int y, int u, int v) {
    this.isLabeled = true;
    this.shouldMirror = true;
    this.labelOffset = 7;
    zigLen = 4 * this.scale * zigs;
    minLen = zigLen + 4 * this.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - zigLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = this.scale;
    float x = tails;
    
    g.line(0, 0, x, 0);
    g.noFill();
    float start = 0, j = 0;
    thickStyle(g);
    for (j = 0; j < 3; j++) {
      start = x + j * 4 * i;
      g.arc(start + 2 * i, 0, 4 * i, 8 * i, -PI, 0);
    }
    resetStyle(g);
    g.line(start + 4 * i, 0, start + 4 * i + tails, 0);
  }
}

class Capacitor extends Component {
  
  float capLen = this.scale * 2;
  float tails;
  
  // from x, y to u, v
  Capacitor(int x, int y, int u, int v) {
    this.isLabeled = true;
    this.labelOffset = 7;
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
    this.isLabeled = true;
    this.labelOffset = 7;
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

class TwoCell extends Component {
  
  float capLen = super.scale * 2;
  float tails;
  
  // from x, y to u, v
  TwoCell(int x, int y, int u, int v) {
    this.isLabeled = true;
    this.labelOffset = 7;
    minLen = this.scale * 8;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - 3 * capLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = this.scale;
    float x = 0 + tails;
    
    g.line(0, 0, x, 0);
    thickStyle(g);
    g.line(x, 0 - i * 2, x, 0 + i * 2);
    float capMid = x + capLen;
    g.line(capMid, 0 - i * 5, capMid, 0 + i * 5);
    float capNext = capMid + capLen;
    g.line(capNext, 0 - i * 2, capNext, 0 + i * 2);
    float capEnd = capNext + capLen;
    g.line(capEnd, 0 - i * 5, capEnd, 0 + i * 5);
    resetThick(g);
    g.line(capEnd, 0, capEnd + tails, 0);
  }
}

class Terminal extends Component {
  // from x, y to u, v
  Terminal(int x, int y, int u, int v) {
    this.isLabeled = true;
    this.isTerminating = true;
    this.minLen = super.scale * 4;
    super.resize(x, y, u, v);
  }
  
  @Override void drawShape(PGraphics g) {
    float i = this.scale;
    
    g.line(0, 0, this.len - 4 * i, 0);
    g.noFill();
    g.ellipse(this.len - 3 * i, 0, 2 * i, 2 * i);
    resetStyle(g);
  }
  
  @Override void drawText(PGraphics g, float ang) {
    // adjust to place left or on top of component
    //ang += PI/2 * (ang <= - PI/2 || ang > PI/2 ? -1 : 1);
    
    g.text(labelText, len + this.scale * 2, 6);
  }
}

class Ground extends Component {
  // from x, y to u, v
  Ground(int x, int y, int u, int v) {
    this.isTerminating = true;
    this.minLen = this.scale * 4;
    this.resize(x, y, u, v);
  }
  
  @Override void drawShape(PGraphics g) {
    float i = this.scale;
    
    g.line(0, 0, len - 4 * i, 0);
    
    // ground symbol
    thickStyle(g);
    g.line(len - 4 * i, -i * 4, len - 4 * i, i * 4);
    g.line(len - 2 * i, -i * 2.5, len - 2 * i, i * 2.5);
    g.line(len, -i, len, i); 
    resetThick(g);
  }
  
  @Override void drawText(PGraphics g, float ang) {
    // adjust to place left or on top of component
    //ang += PI/2 * (ang <= - PI/2 || ang > PI/2 ? -1 : 1);
    
    g.text(labelText, len + this.scale * 2, 6);
  }
}

class CurrentSource extends Component {
  
  float tails;
  float circLen;
  
  // from x, y to u, v
  CurrentSource(int x, int y, int u, int v) {
    this.isLabeled = true;
    
    circLen = 8 * this.scale;
    this.minLen = circLen + 2 * this.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - circLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0;
    
    g.line(0, 0, x, y); // leader line
    
    g.noFill();
    g.ellipse(x + circLen / 2, y, circLen, circLen); // circle
    resetStyle(g);
    
    float arrowStart = x + circLen / 5;
    float arrowPoint = x + 4 * circLen / 5;
    
    //thickStyle(g);
    arrow(g, arrowStart, y, arrowPoint, y, this.scale *  1.5);
    resetThick(g);
    
    g.line(x + circLen, y, x + circLen + tails, y); // trail line
  }
}

class VoltageSource extends Component {
  
  float tails;
  float circLen;
  
  // from x, y to u, v
  VoltageSource(int x, int y, int u, int v) {
    this.isLabeled = true;
    
    circLen = 8 * super.scale;
    this.minLen = circLen + 2 * super.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - circLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0;
    
    g.line(0, 0, x, y); // leader line
   
    g.noFill();
    g.ellipse(x + circLen / 2, y, circLen, circLen);
    resetStyle(g);
    
    float start = x + circLen / 10;
    float end = x + 9 * circLen / 10;
    
    // minus
    //thickStyle(g);
    g.line(start, y, start + 3 * circLen / 10, y);
    
    // plus
    g.line(end, y, end - 4 * circLen / 10, y);
    g.line(end - 4 / 2 * circLen / 10, 4 / 2 * circLen / 10,
    end - 4 / 2 * circLen / 10, -4 / 2 * circLen / 10 - 0.5); // correct pixel error temporerarly
    resetThick(g);
    
    g.line(x + circLen, y, x + circLen + tails, y); // trail line
  }
}

class DepCurrentSource extends Component {
  
  float tails;
  float diamLen, extraLen;
  
  // from x, y to u, v
  DepCurrentSource(int x, int y, int u, int v) {
    this.isLabeled = true;
    
    diamLen = 8 * this.scale;
    extraLen = 2 * this.scale;
    minLen = diamLen + extraLen + 2 * this.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - diamLen - extraLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0, tot = extraLen + diamLen;
    
    g.line(0, 0, x, y); // leader line
    
    g.noFill();
    //g.ellipse(x + diamLen / 2, y, diamLen, diamLen); // circle
    g.quad(x, y, x + tot / 2, y + diamLen / 2,
      x + tot, y, x + tot / 2, y - diamLen / 2);
    resetStyle(g);
    
    x += extraLen / 2; // to start of arrow, make sure in same place as current source
    
    float arrowStart = x + diamLen / 5;
    float arrowPoint = x + 4 * diamLen / 5;
    
    //thickStyle(g);
    arrow(g, arrowStart, y, arrowPoint, y, this.scale *  1.5);
    resetThick(g);
    
    x += extraLen / 2; 
    x += diamLen; // to end of diagonal
    
    g.line(x, y, x + tails, y); // trail line
  }
}

class DepVoltageSource extends Component {
  
  float tails;
  float diamLen, extraLen;
  
  // from x, y to u, v
  DepVoltageSource(int x, int y, int u, int v) {
    this.isLabeled = true;
    
    diamLen = 8 * this.scale;
    extraLen = 2 * this.scale;
    minLen = diamLen + extraLen + 2 * this.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - diamLen - extraLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0, tot = extraLen + diamLen;
    
    g.line(0, 0, x, y); // leader line
    
    g.noFill();
    //g.ellipse(x + diamLen / 2, y, diamLen, diamLen); // circle
    g.quad(x, y, x + tot / 2, y + diamLen / 2,
      x + tot, y, x + tot / 2, y - diamLen / 2);
    resetStyle(g);
    
    x += extraLen / 2; // to start of arrow, make sure in same place as current source
    
    float start = x + diamLen / 10;
    float end = x + 9 * diamLen / 10;
    
    // minus
    //thickStyle(g);
    g.line(start, y, start + 3.5 * diamLen / 10, y);
    
    // plus
    g.line(end, y, end - 4 * diamLen / 10, y);
    g.line(end - 4 / 2 * diamLen / 10, 4 / 2 * diamLen / 10,
    end - 4 / 2 * diamLen / 10, -4 / 2 * diamLen / 10 + 1); // correct pixel error temporerarly
    resetThick(g);
    
    x += extraLen / 2; 
    x += diamLen; // to end of diagonal
    
    g.line(x, y, x + tails, y); // trail line
  }
}

class BJTransistor extends Component {
  
  float capLen = super.scale * 2;
  float circSize = super.scale * 10;
  int leadingTail;
  
  boolean isPNP;
  
  // from x, y to u, v
  BJTransistor(int x, int y, int u, int v, boolean isPNP) {
    this.isTerminating = true;
    this.shouldMirror = true;
    this.resize(x, y, u, v);
    this.isPNP = isPNP;
    this.minLen = circSize;
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    float tail = len - circSize;
    leadingTail = int(tail - tail % 10) + 10;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    float x = leadingTail, y = 0;
    float tot = circSize;
    
    g.noFill();
    g.ellipse(x + tot / 2, y, tot, tot); // circle
    resetStyle(g);
    
    x += circSize / 3;
    g.line(0, 0, x, 0);
    
    thickStyle(g);
    g.line(x, 0 - i * 3.5, x, 0 + i * 3.5);
    resetThick(g);
    
    float xterm = leadingTail + circSize - 10;
    float yterm = sqrt(sq(circSize / 2) - sq(circSize / 2 - 10)); // align to circle
    
    // angles
    if (isPNP) {
      arrow(g, x, i * 1.5, xterm, yterm, i * 2);
      g.line(x, -i * 1.5, xterm, -yterm);
    }
    else {
      g.line(x, i * 1.5, xterm, yterm);
      arrow(g, xterm, -yterm, x, -i * 1.5, 2 * i);
    }
    
    // terminals
    g.line(xterm, yterm, xterm, circSize);
    g.line(xterm, -yterm, xterm, -circSize);
  }
}

class FETransistor extends Component {
  
  float capLen = super.scale * 2;
  float circSize = super.scale * 10;
  int leadingTail;
  
  boolean isNChannel;
  
  // from x, y to u, v
  FETransistor(int x, int y, int u, int v, boolean isNChannel) {
    this.isTerminating = true;
    this.shouldMirror = true;
    this.resize(x, y, u, v);
    this.isNChannel = isNChannel;
    this.minLen = circSize;
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    float tail = len - circSize;
    leadingTail = int(tail - tail % 10) + 10;
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    float x = leadingTail, y = 0;
    float tot = circSize;
    
    g.noFill();
    g.ellipse(x + tot / 2, y, tot, tot); // circle
    resetStyle(g);
    
    x += 2 * circSize / 5;
    if (isNChannel) {
      arrow(g, 0, 0, x, 0, i * 2);
    } else {
      g.line(0, 0, x, 0);
      arrow(g, x, 0, x - i * 4, 0, i * 2);
    }
    
    // channel
    thickStyle(g);
    g.line(x, 0 - i * 3.5, x, 0 + i * 3.5);
    resetThick(g);
    
    float xterm = leadingTail + circSize - 10;
    float yoffset = i * 2;
    
    // terminals
    g.noFill();
    g.beginShape();
    g.vertex(x, -yoffset);
    g.vertex(xterm, -yoffset);
    g.vertex(xterm, -circSize);
    g.endShape();
    
    g.beginShape();
    g.vertex(x, yoffset);
    g.vertex(xterm, yoffset);
    g.vertex(xterm, circSize);
    g.endShape();
    
    resetStyle(g);
  }
}
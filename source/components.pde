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
    
    if (x > xend || // correct orientation
      (x == xend && y > yend)) // consisent vertial case
      g.scale(1, -1);
    
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
    //for (j = 0; j < 3; j++) {
    //  start = x + j * 4 * i;
    //  g.line(start, y, start + 1 * i, y + 2 * i);
    //  g.line(start + 1 * i, y + 2 * i, start + 3 * i, y - 2 * i);
    //  g.line(start + 3 * i, y - 2 * i, start + 4 * i, y);
    //}
    g.noFill();
    g.strokeJoin(BEVEL);
    g.beginShape();
    g.vertex(x + j * 4 * i, y);
    for (j = 0; j < 3; j++) {
      start = x + j * 4 * i;
      g.vertex(start + 1 * i, y + 2 * i);
      g.vertex(start + 3 * i, y - 2 * i);
      g.vertex(start + 4 * i, y);
    }
    g.endShape();
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
    resetStyle(g);
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
    g.noFill();
    g.ellipse(super.len - 3 * i, 0, 2 * i, 2 * i);
    resetStyle(g);
  }
  
  @Override void drawText(PGraphics g, float ang) {
    // adjust to place left or on top of component
    //ang += PI/2 * (ang <= - PI/2 || ang > PI/2 ? -1 : 1);
    
    g.text(labelText, len + super.scale * 2, 6);
  }
}

class Ground extends Component {
  // from x, y to u, v
  Ground(int x, int y, int u, int v) {
    super.terminates = true;
    super.minLen = super.scale * 4;
    super.resize(x, y, u, v);
  }
  
  @Override void drawShape(PGraphics g) {
    float i = super.scale;
    
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
    
    g.text(labelText, len + super.scale * 2, 6);
  }
}

class CurrentSource extends Component {
  
  float tails;
  float circLen;
  
  // from x, y to u, v
  CurrentSource(int x, int y, int u, int v) {
    circLen = 8 * super.scale;
    minLen = circLen + 2 * super.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - circLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0;
    
    g.line(0, 0, x, y); // leader line
    thickStyle(g);
    g.noFill();
    g.ellipse(x + circLen / 2, y, circLen, circLen); // circle
    resetStyle(g);
    float arrowStart = x + circLen / 5;
    float arrowPoint = x + 4 * circLen / 5;
    float arrowHeadStart = x + 2 * circLen / 3;
    float arrowHeadHeight = (arrowPoint - arrowHeadStart); // / 5 * 4;
    //g.triangle(arrowPoint, y,
    //  arrowHeadStart, arrowHeadHeight,
    //  arrowHeadStart, -arrowHeadHeight + 0.5);
    
    // arrow
    g.line(arrowStart, y, arrowPoint, y);
    
    // arrow head
    g.noFill();
    g.beginShape();
    g.vertex(arrowHeadStart, arrowHeadHeight);
    g.vertex(arrowPoint, y);
    g.vertex(arrowHeadStart, -arrowHeadHeight);
    g.endShape();
    resetStyle(g);
    
    g.line(x + circLen, y, x + circLen + tails, y); // trail line
  }
}

class VoltageSource extends Component {
  
  float tails;
  float circLen;
  
  // from x, y to u, v
  VoltageSource(int x, int y, int u, int v) {
    circLen = 8 * super.scale;
    minLen = circLen + 2 * super.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - circLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0;
    
    g.line(0, 0, x, y); // leader line
    thickStyle(g);
    g.noFill();
    g.ellipse(x + circLen / 2, y, circLen, circLen);
    resetStyle(g);
    float start = x + circLen / 5;
    float end = x + 4 * circLen / 5;
    
    // minus
    g.line(start, y, start + circLen / 5, y);
    
    // plus
    g.line(end - circLen / 5, y, end, y);
    g.line(end - circLen / 10, circLen / 10,
    end - circLen / 10, - circLen / 10 + 1); // correct pixel error temporerarly
    
    g.line(x + circLen, y, x + circLen + tails, y); // trail line
  }
}

class DepCurrentSource extends Component {
  
  float tails;
  float diamLen, extraLen;
  
  // from x, y to u, v
  DepCurrentSource(int x, int y, int u, int v) {
    diamLen = 8 * super.scale;
    extraLen = 2 * super.scale;
    minLen = diamLen + extraLen + 2 * super.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - diamLen - extraLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0, tot = extraLen + diamLen;
    
    g.line(0, 0, x, y); // leader line
    thickStyle(g);
    g.noFill();
    //g.ellipse(x + diamLen / 2, y, diamLen, diamLen); // circle
    g.quad(x, y, x + tot / 2, y + diamLen / 2,
      x + tot, y, x + tot / 2, y - diamLen / 2);
    resetStyle(g);
    
    x += extraLen / 2; // to start of arrow, make sure in same place as current source
    
    float arrowStart = x + diamLen / 5;
    float arrowPoint = x + 4 * diamLen / 5;
    float arrowHeadStart = x + 2 * diamLen / 3;
    float arrowHeadHeight = (arrowPoint - arrowHeadStart); // / 5 * 4;
    
    // arrow
    g.line(arrowStart, y, arrowPoint, y);
    
    // arrow head
    g.noFill();
    g.beginShape();
    g.vertex(arrowHeadStart, arrowHeadHeight);
    g.vertex(arrowPoint, y);
    g.vertex(arrowHeadStart, -arrowHeadHeight);
    g.endShape();
    resetStyle(g);
    
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
    diamLen = 8 * super.scale;
    extraLen = 2 * super.scale;
    minLen = diamLen + extraLen + 2 * super.scale;
    this.resize(x, y, u, v);
  }
  
  @Override void resize(int a, int b, int u, int v) {
    super.resize(a, b, u, v);
    tails = (len - diamLen - extraLen) / 2;
  }
  
  @Override void drawShape(PGraphics g) {
    float x = tails, y = 0, tot = extraLen + diamLen;
    
    g.line(0, 0, x, y); // leader line
    thickStyle(g);
    g.noFill();
    //g.ellipse(x + diamLen / 2, y, diamLen, diamLen); // circle
    g.quad(x, y, x + tot / 2, y + diamLen / 2,
      x + tot, y, x + tot / 2, y - diamLen / 2);
    resetStyle(g);
    
    x += extraLen / 2; // to start of arrow, make sure in same place as current source
    
    float start = x + diamLen / 5;
    float end = x + 4 * diamLen / 5;
    
    // minus
    g.line(start, y, start + diamLen / 5, y);
    
    // plus
    g.line(end - diamLen / 5, y, end, y);
    g.line(end - diamLen / 10, diamLen / 10,
    end - diamLen / 10, - diamLen / 10); // correct pixel error temporerarly
    
    x += extraLen / 2; 
    x += diamLen; // to end of diagonal
    
    g.line(x, y, x + tails, y); // trail line
  }
}


class Wire extends Component {
  
  Wire(int x, int y, int u, int v) {
    super.minLen = 1;
    super.resize(x, y, u, v);
    super.labeled = false;
  }
}
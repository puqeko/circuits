boolean keyDown[] = new boolean[256];
boolean keyDownLong[] = new boolean[256];
int keyTime[] = new int[256];

int waitTime = 200;

void keyPressed() {
  if ((key == CODED || key <= 256)) {
    int code = key == CODED ? keyCode : key;
    if (!keyDown[code]) {
      keyTime[code] = millis();
      keyDown[code] = true;
      keyDown(code);
      println("down: " + code);
    }
  }
  
  if (key == ESC)
    key = 0;
}

void keyReleased() {
  if (key == CODED || key <= 256) {
    int code = key == CODED ? keyCode : key;
    keyDown[code] = keyDownLong[code] = false;
    println("up: " + code);
  }
}

boolean fastMode = false;
int fastKey = 0;

void updateInput() {
  if (keyPressed) {
    int code = key == CODED ? keyCode : key;
    
    // only apply fastKey to these ones
    if (code == LEFT || code == RIGHT || code == UP || code == DOWN ||
    "hjklwasdWASD".indexOf(char(code)) != -1) {
      
      // not registered as long press yet, but pressed down
      if (!keyDownLong[code] && keyDown[code]) {
        if (millis() - keyTime[code] > waitTime) {
          keyDownLong[code] = true;
          println("fast: " + code);
          //keyLongDown(code);
          fastKey = code;
          fastMode = true;
        }
      }
    }
  }
}
boolean keyDown[] = new boolean[256];
boolean keyDownLong[] = new boolean[256];
int keyTime[] = new int[256];

int waitTime = 200;

void keyPressed() {
  if ((key == CODED || key <= 256)) {
    int code = key == CODED ? keyCode : key;
    println(code);
    
    if (!keyDown[code]) {
      
      // 65 => 90; 97 => 122
      if (key == CODED && code == SHIFT) { // change lower case downs to upper case
        for (int i = 97; i <= 122; i++) {
          if (keyDown[i]) {
            keyDown[i] = false;
            keyDown[i - 32] = true;
          }
        }
      } else if (key != CODED && keyDown[SHIFT] && code >= 97 && code <= 122) { // ensure upper case
        keyTime[code - 32] = millis();
        keyDown[code - 32] = true;
        keyDown(code - 32);
      } else {
        keyTime[code] = millis();
        keyDown[code] = true;
        keyDown(code);
      }
    }
    
    
  }
  
  if (key == ESC)
    key = 0;
}

void keyReleased() {
  if (key == CODED || key <= 256) {
    int code = key == CODED ? keyCode : key;
    
    if (key == CODED && code == SHIFT) {
      for (int i = 65; i <= 90; i++) {
        if (keyDown[i]) {
          keyDown[i] = false;
          keyDown[i + 32] = true;
        }
      }
    } else if (key != CODED && code >= 97 && code <= 122) { // ensure undo upper case when no shift
      keyDown[code] = keyDown[code - 32] = keyDownLong[code] = keyDownLong[code - 32] = false;
    } else {
      keyDown[code] = keyDownLong[code] = false;
    }
  }
}

boolean fastMode = false;
int fastKey = 0;

void updateInput() {
  if (keyPressed) {
    int code = key == CODED ? keyCode : key;
    
    // only apply fastKey to these ones
    if (code == LEFT || code == RIGHT || code == UP || code == DOWN ||
    "wasdWASD".indexOf(char(code)) != -1) {
      
      // not registered as long press yet, but pressed down
      if (!keyDownLong[code] && keyDown[code]) {
        if (millis() - keyTime[code] > waitTime) {
          keyDownLong[code] = true;
          fastKey = code;
          fastMode = true;
        }
      }
    }
  }
}
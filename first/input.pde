boolean keyDown[] = new boolean[256];
boolean keyDownLong[] = new boolean[256];
int keyTime[] = new int[256];

int waitTime = 200;

void keyPressed() {
  if ( (key == CODED || key <= 256) && !keyDown[keyCode]) {
    int code = key == CODED ? keyCode : key;
    keyTime[code] = millis();
    keyDown[code] = true;
    keyDown(code);
  }
  
  if (key == ESC)
    key = 0;
}

void keyReleased() {
  if (key == CODED || key <= 256) {
    int code = key == CODED ? keyCode : key;
    keyDown[code] = keyDownLong[code] = false;
  }
}

boolean fastMode = false;
int fastKey = 0;

void updateInput() {
  if (keyPressed) {
    int code = key == CODED ? keyCode : key;
    if (!keyDownLong[code] && keyDown[code]) {
      if (millis() - keyTime[code] > waitTime) {
        keyDownLong[code] = true;
        //keyLongDown(code);
        fastKey = code;
        fastMode = true;
      }
    }
  }
}
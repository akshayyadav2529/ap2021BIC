GameWorld world;

int physicsStepMs = 1000 / 60;
int nextPhysicsAt;
int updatePhysics;

boolean upHold, leftHold, rightHold, rHold, pHold, oldPHold;

void setup() {
  size(1280, 720, P2D);
  pixelDensity(1);
  rectMode(CENTER);
  noStroke();
  frameRate(1000);

  world = new GameWorld();
  nextPhysicsAt = millis() + physicsStepMs;
}

void draw() {
  computePhysicsUpdates();
  world.update();
}

void computePhysicsUpdates() {
  if (nextPhysicsAt < millis()) {
    updatePhysics = (millis() - nextPhysicsAt) / physicsStepMs;
    nextPhysicsAt += updatePhysics * physicsStepMs;
  } else {
    updatePhysics = 0;
  }
}

void keyPressed() {
  if (keyCode == UP) upHold = true;
  if (keyCode == LEFT) leftHold = true;
  if (keyCode == RIGHT) rightHold = true;
  if (key == 'r' || key == 'R') rHold = true;
  if (key == 'p' || key == 'P') pHold = true;
}

void keyReleased() {
  if (keyCode == UP) upHold = false;
  if (keyCode == LEFT) leftHold = false;
  if (keyCode == RIGHT) rightHold = false;
  if (key == 'r' || key == 'R') rHold = false;
  if (key == 'p' || key == 'P') pHold = false;
}

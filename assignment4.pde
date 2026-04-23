GameWorld world;

void setup() {
  size(960, 540);
  world = new GameWorld();
}

void draw() {
  world.update();
  world.render();
}

void keyPressed() {
  world.handleKeyPressed(key, keyCode);
}

void keyReleased() {
  world.handleKeyReleased(key, keyCode);
}

GameWorld world;

void setup() {
  size(1000, 600);
  smooth(4);
  world = new GameWorld();
}

void draw() {
  world.update();
  world.render();
}

void keyPressed() {
  world.onKeyPressed(key, keyCode);
}

void keyReleased() {
  world.onKeyReleased(key, keyCode);
}

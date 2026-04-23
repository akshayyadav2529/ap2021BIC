class Checkpoint extends Entity {
  boolean activated = false;

  Checkpoint(float x, float y) {
    super(x, y, 16, 44);
  }

  void render() {
    stroke(35);
    strokeWeight(2);
    line(x + 2, y, x + 2, y + h);
    noStroke();
    fill(activated ? color(80, 230, 120) : color(230, 170, 70));
    triangle(x + 2, y + 2, x + 2, y + 20, x + 20, y + 11);
  }
}

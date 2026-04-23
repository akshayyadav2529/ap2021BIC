class SolidBlock extends Entity {
  SolidBlock(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  void render() {
    noStroke();
    fill(75, 90, 120);
    rect(x, y, w, h);
    fill(105, 120, 150);
    rect(x, y, w, 5);
  }
}

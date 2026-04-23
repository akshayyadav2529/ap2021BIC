class Hazard extends Entity {
  Hazard(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  void render() {
    noStroke();
    fill(220, 70, 70);
    rect(x, y, w, h);
    fill(255, 110, 110);
    for (int i = 0; i < int(w); i += 12) {
      triangle(x + i, y, x + i + 6, y - 8, x + i + 12, y);
    }
  }
}

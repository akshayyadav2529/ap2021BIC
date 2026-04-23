class Coin extends Entity {
  boolean collected = false;

  Coin(float x, float y) {
    super(x, y, 18, 18);
  }

  void render() {
    if (collected) {
      return;
    }
    noStroke();
    fill(255, 210, 60);
    ellipse(x + w * 0.5, y + h * 0.5, w, h);
    fill(255, 240, 140);
    ellipse(x + w * 0.5, y + h * 0.5, w * 0.5, h * 0.5);
  }
}

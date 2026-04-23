class Coin extends Collider {
  boolean collected;

  Coin(float x, float y) {
    super(x, y);
    halfW = 10;
    halfH = 10;
  }

  void render() {
    if (collected) return;
    drawBox(color(255, 220, 60));
  }
}

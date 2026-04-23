class Coin extends Entity {
  boolean collected = false;

  Coin(float x, float y) {
    super(x, y, 18, 18);
  }

  void display(int tick) {
    if (collected) return;
    float pulse = 2 + 1.5 * sin((tick + pos.x * 0.2) * 0.08);
    noStroke();
    fill(255, 224, 88);
    ellipse(pos.x + w * 0.5, pos.y + h * 0.5, w + pulse, h + pulse);
    fill(255, 248, 170);
    ellipse(pos.x + w * 0.5, pos.y + h * 0.5, w * 0.45, h * 0.45);
  }
}

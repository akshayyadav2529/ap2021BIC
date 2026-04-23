class MovingHazard extends Entity {
  float minX;
  float maxX;
  float speed;

  MovingHazard(float x, float y, float range, float speed) {
    super(x, y, 30, 30);
    this.minX = x - range;
    this.maxX = x + range;
    this.speed = speed;
    vel.x = speed;
  }

  void update() {
    pos.x += vel.x;
    if (pos.x < minX) {
      pos.x = minX;
      vel.x *= -1;
    }
    if (pos.x > maxX) {
      pos.x = maxX;
      vel.x *= -1;
    }
  }

  void display(int tick) {
    float bob = 2.5 * sin((tick + pos.x) * 0.08);
    noStroke();
    fill(213, 72, 66);
    rect(pos.x, pos.y + bob, w, h, 5);
    stroke(255, 207, 120);
    strokeWeight(2);
    line(pos.x + 6, pos.y + 8 + bob, pos.x + w - 6, pos.y + h - 8 + bob);
    line(pos.x + w - 6, pos.y + 8 + bob, pos.x + 6, pos.y + h - 8 + bob);
    noStroke();
  }
}

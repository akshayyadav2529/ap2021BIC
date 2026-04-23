class Collider {
  PVector loc;
  PVector vel;
  float halfW;
  float halfH;

  Collider(float x, float y) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
  }

  boolean overlaps(Collider other) {
    return abs(loc.x - other.loc.x) < (halfW + other.halfW) &&
      abs(loc.y - other.loc.y) < (halfH + other.halfH);
  }

  void drawBox(int c) {
    fill(c);
    rect(loc.x, loc.y, halfW * 2, halfH * 2);
  }
}

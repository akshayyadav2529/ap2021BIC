class Entity {
  PVector pos;
  PVector vel;
  float w;
  float h;

  Entity(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    this.w = w;
    this.h = h;
  }

  float left() {
    return pos.x;
  }

  float right() {
    return pos.x + w;
  }

  float top() {
    return pos.y;
  }

  float bottom() {
    return pos.y + h;
  }
}

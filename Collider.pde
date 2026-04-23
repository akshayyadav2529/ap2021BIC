class Collider {
  static boolean overlap(Entity a, Entity b) {
    return overlap(a.left(), a.top(), a.w, a.h, b.left(), b.top(), b.w, b.h);
  }

  static boolean overlap(Entity a, SolidBlock b) {
    return overlap(a.left(), a.top(), a.w, a.h, b.x, b.y, b.w, b.h);
  }

  static boolean overlap(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh) {
    return ax < bx + bw && ax + aw > bx && ay < by + bh && ay + ah > by;
  }
}

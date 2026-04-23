class SolidBlock {
  float x;
  float y;
  float w;
  float h;

  SolidBlock(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    noStroke();
    fill(76, 118, 68);
    rect(x, y, w, h, 6);
    fill(108, 160, 96);
    rect(x, y, w, 8, 6, 6, 0, 0);
  }
}

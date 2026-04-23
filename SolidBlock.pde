class SolidBlock extends Collider {
  final int TYPE_SOLID = 0;
  final int TYPE_DEATH = 1;
  final int TYPE_WIN = 2;
  final int TYPE_CHECKPOINT = 3;

  int type;

  SolidBlock(float x, float y, float w, float h) {
    this(x, y, w, h, 0);
  }

  SolidBlock(float x, float y, float w, float h, int type) {
    super(x, y);
    halfW = w * 0.5;
    halfH = h * 0.5;
    this.type = type;
  }

  boolean isSolid() {
    return type == TYPE_SOLID || type == TYPE_CHECKPOINT;
  }

  void render() {
    if (type == TYPE_DEATH) drawBox(color(210, 80, 95));
    else if (type == TYPE_WIN) drawBox(color(255, 225, 120));
    else if (type == TYPE_CHECKPOINT) drawBox(color(80, 220, 230));
    else drawBox(color(95, 125, 160));
  }
}

class Runner extends Entity {
  float vx = 0;
  float vy = 0;
  boolean moveLeft = false;
  boolean moveRight = false;
  boolean jumpPressed = false;
  boolean onGround = false;

  final float speed = 4.1;
  final float gravity = 0.62;
  final float jumpSpeed = -11.5;
  final float terminalVelocity = 12;

  Runner(float x, float y) {
    super(x, y, 28, 34);
  }

  void update(ArrayList<SolidBlock> blocks) {
    float targetVx = 0;
    if (moveLeft) targetVx -= speed;
    if (moveRight) targetVx += speed;
    vx = lerp(vx, targetVx, 0.38);

    if (jumpPressed && onGround) {
      vy = jumpSpeed;
      onGround = false;
    }
    jumpPressed = false;

    vy = min(vy + gravity, terminalVelocity);

    x += vx;
    for (SolidBlock b : blocks) {
      if (Collider.overlaps(this, b)) {
        if (vx > 0) {
          x = b.x - w;
        } else if (vx < 0) {
          x = b.x + b.w;
        }
        vx = 0;
      }
    }

    y += vy;
    onGround = false;
    for (SolidBlock b : blocks) {
      if (Collider.overlaps(this, b)) {
        if (vy > 0) {
          y = b.y - h;
          onGround = true;
        } else if (vy < 0) {
          y = b.y + b.h;
        }
        vy = 0;
      }
    }
  }

  void render() {
    noStroke();
    fill(84, 182, 255);
    rect(x, y, w, h, 5);
    fill(215);
    rect(x + 6, y + 7, 5, 5, 2);
    rect(x + 17, y + 7, 5, 5, 2);
  }
}

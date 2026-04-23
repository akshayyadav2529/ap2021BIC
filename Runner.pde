class Runner extends Entity {
  boolean onGround = false;
  int facing = 1;
  int dashFrames = 0;
  int dashCooldown = 0;
  int deaths = 0;

  Runner(float x, float y) {
    super(x, y, 30, 42);
  }

  void update(ArrayList<SolidBlock> solids, boolean leftHeld, boolean rightHeld, boolean jumpPressed) {
    float inputX = 0;
    if (leftHeld) inputX -= 1;
    if (rightHeld) inputX += 1;
    if (inputX != 0) facing = (int)inputX;

    if (dashCooldown > 0) dashCooldown--;
    if (dashFrames > 0) {
      dashFrames--;
      vel.y = 0;
    } else {
      vel.x = lerp(vel.x, inputX * 5.0, 0.35);
      vel.y = min(vel.y + 0.85, 15);
    }

    if (jumpPressed && onGround) {
      vel.y = -13;
      onGround = false;
    }

    pos.x += vel.x;
    resolveX(solids);

    pos.y += vel.y;
    onGround = false;
    resolveY(solids);
  }

  void startDash() {
    if (dashCooldown > 0 || dashFrames > 0) return;
    dashFrames = 8;
    dashCooldown = 80;
    vel.x = facing * 14;
    vel.y = 0;
  }

  void resolveX(ArrayList<SolidBlock> solids) {
    for (SolidBlock block : solids) {
      if (Collider.overlap(this, block)) {
        if (vel.x > 0) pos.x = block.x - w;
        if (vel.x < 0) pos.x = block.x + block.w;
        vel.x = 0;
      }
    }
  }

  void resolveY(ArrayList<SolidBlock> solids) {
    for (SolidBlock block : solids) {
      if (Collider.overlap(this, block)) {
        if (vel.y > 0) {
          pos.y = block.y - h;
          onGround = true;
        }
        if (vel.y < 0) pos.y = block.y + block.h;
        vel.y = 0;
      }
    }
  }

  void display(int tick) {
    noStroke();
    fill(52, 76, 225);
    rect(pos.x, pos.y, w, h, 6);
    fill(255);
    ellipse(pos.x + (facing > 0 ? 21 : 9), pos.y + 14, 8, 8);

    if (dashFrames > 0) {
      stroke(118, 220, 255, 180);
      strokeWeight(4);
      line(pos.x + w * 0.5, pos.y + h * 0.5, pos.x + w * 0.5 - facing * 24, pos.y + h * 0.5 + sin(tick * 0.4) * 6);
      noStroke();
    }
  }
}

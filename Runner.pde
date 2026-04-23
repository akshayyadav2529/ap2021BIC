class Runner extends Collider {
  boolean grounded;
  boolean dead;
  boolean won;
  boolean touchedGoal;

  Runner(float x, float y) {
    super(x, y);
    halfW = 16;
    halfH = 16;
  }

  void update(ArrayList<SolidBlock> blocks) {
    if (dead || won) return;

    touchedGoal = false;

    for (int i = 0; i < updatePhysics; i++) {
      float move = 0;
      if (leftHold) move -= 0.7;
      if (rightHold) move += 0.7;

      // Yesterday tuning: keep movement responsive but stable.
      vel.x += move;
      vel.x *= 0.9;

      if (grounded && upHold) {
        vel.y = -14.5;
        grounded = false;
      }

      vel.y += 0.7;
      if (vel.y > 16) vel.y = 16;

      loc.x += vel.x;
      resolve(blocks, true);

      loc.y += vel.y;
      grounded = false;
      resolve(blocks, false);
    }
  }

  void resolve(ArrayList<SolidBlock> blocks, boolean horizontal) {
    for (SolidBlock b : blocks) {
      if (!overlaps(b)) continue;

      if (b.type == b.TYPE_DEATH) {
        dead = true;
        continue;
      }
      if (b.type == b.TYPE_WIN) {
        touchedGoal = true;
        continue;
      }
      if (!b.isSolid()) continue;

      if (horizontal) {
        if (vel.x > 0) loc.x = b.loc.x - (b.halfW + halfW);
        else if (vel.x < 0) loc.x = b.loc.x + (b.halfW + halfW);
        vel.x = 0;
      } else {
        if (vel.y > 0) {
          loc.y = b.loc.y - (b.halfH + halfH);
          grounded = true;
        } else if (vel.y < 0) {
          loc.y = b.loc.y + (b.halfH + halfH);
        }
        vel.y = 0;
      }
    }
  }

  void render() {
    if (dead) drawBox(color(255, 120, 120));
    else if (won) drawBox(color(255, 235, 120));
    else drawBox(color(235, 245, 255));
  }
}

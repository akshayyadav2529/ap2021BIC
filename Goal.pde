class Goal extends Entity {
  Goal(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  void render(boolean unlocked) {
    noStroke();
    fill(unlocked ? color(90, 220, 120) : color(130, 130, 145));
    rect(x, y, w, h, 4);
    fill(unlocked ? color(230, 255, 235) : color(200, 200, 210));
    textAlign(CENTER, CENTER);
    textSize(12);
    text(unlocked ? "GOAL" : "LOCKED", x + w * 0.5, y + h * 0.5);
  }
}

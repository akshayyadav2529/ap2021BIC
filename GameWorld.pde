class GameWorld {
  static final int PLAYING = 0;
  static final int PAUSED = 1;
  static final int DEAD = 2;
  static final int WON = 3;

  Runner runner;
  ArrayList<SolidBlock> blocks = new ArrayList<SolidBlock>();
  ArrayList<Coin> coins = new ArrayList<Coin>();
  ArrayList<Hazard> hazards = new ArrayList<Hazard>();
  ArrayList<Checkpoint> checkpoints = new ArrayList<Checkpoint>();
  Goal goal;

  int state = PLAYING;
  int coinsCollected = 0;
  int activeCheckpointIndex = 0;
  PVector spawnPoint = new PVector(70, 430);

  String checkpointMessage = "";
  int checkpointMessageTimer = 0;
  int goalLockedTimer = 0;

  GameWorld() {
    setupLevel();
    runner = new Runner(spawnPoint.x, spawnPoint.y);
  }

  void setupLevel() {
    blocks.clear();
    coins.clear();
    hazards.clear();
    checkpoints.clear();

    blocks.add(new SolidBlock(0, 500, width, 40));
    blocks.add(new SolidBlock(120, 420, 130, 20));
    blocks.add(new SolidBlock(320, 360, 120, 20));
    blocks.add(new SolidBlock(520, 305, 130, 20));
    blocks.add(new SolidBlock(730, 255, 180, 20));
    blocks.add(new SolidBlock(520, 180, 110, 18));
    blocks.add(new SolidBlock(390, 140, 95, 18));

    hazards.add(new Hazard(255, 500, 60, 18));
    hazards.add(new Hazard(465, 500, 60, 18));
    hazards.add(new Hazard(680, 500, 60, 18));
    hazards.add(new Hazard(580, 500, 50, 18));

    coins.add(new Coin(160, 390));
    coins.add(new Coin(360, 330));
    coins.add(new Coin(560, 275));
    coins.add(new Coin(780, 225));
    coins.add(new Coin(860, 225));
    coins.add(new Coin(545, 150));
    coins.add(new Coin(420, 110));

    checkpoints.add(new Checkpoint(95, 456));
    checkpoints.add(new Checkpoint(690, 211));
    checkpoints.get(0).activated = true;

    goal = new Goal(900, 210, 40, 40);
  }

  void update() {
    if (state != PLAYING) {
      if (goalLockedTimer > 0) goalLockedTimer--;
      if (checkpointMessageTimer > 0) checkpointMessageTimer--;
      return;
    }

    runner.update(blocks);

    for (Coin c : coins) {
      if (!c.collected && Collider.overlaps(runner, c)) {
        c.collected = true;
        coinsCollected++;
      }
    }

    for (Hazard h : hazards) {
      if (Collider.overlaps(runner, h)) {
        state = DEAD;
        return;
      }
    }

    for (int i = 0; i < checkpoints.size(); i++) {
      Checkpoint cp = checkpoints.get(i);
      if (Collider.overlaps(runner, cp) && !cp.activated) {
        for (Checkpoint c : checkpoints) c.activated = false;
        cp.activated = true;
        activeCheckpointIndex = i;
        spawnPoint.set(cp.x - 8, cp.y - runner.h);
        checkpointMessage = "Checkpoint reached!";
        checkpointMessageTimer = 150;
      }
    }

    if (Collider.overlaps(runner, goal)) {
      if (coinsCollected == coins.size()) {
        state = WON;
      } else {
        goalLockedTimer = 120;
      }
    }

    if (runner.y > height + 120) {
      state = DEAD;
    }

    if (goalLockedTimer > 0) goalLockedTimer--;
    if (checkpointMessageTimer > 0) checkpointMessageTimer--;
  }

  void render() {
    drawBackground();

    for (SolidBlock b : blocks) b.render();
    for (Hazard h : hazards) h.render();
    for (Coin c : coins) c.render();
    for (Checkpoint cp : checkpoints) cp.render();
    goal.render(coinsCollected == coins.size());
    runner.render();

    drawHud();
    drawStateOverlay();
  }

  void drawBackground() {
    background(26, 32, 44);
    noStroke();
    fill(35, 42, 58);
    rect(0, 0, width, 58);
  }

  void drawHud() {
    fill(230);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Coins: " + coinsCollected + "/" + coins.size() + "    Checkpoint: " + (activeCheckpointIndex + 1), 14, 10);

    textSize(12);
    text("A/D or ←/→ move   W/Space/↑ jump   P pause   R restart", 14, 33);

    if (checkpointMessageTimer > 0) {
      fill(120, 235, 150);
      textAlign(CENTER, TOP);
      textSize(16);
      text(checkpointMessage, width * 0.5, 62);
    } else if (goalLockedTimer > 0) {
      fill(255, 180, 110);
      textAlign(CENTER, TOP);
      textSize(15);
      text("Collect all coins to unlock the goal", width * 0.5, 62);
    }
  }

  void drawStateOverlay() {
    if (state == PLAYING) return;

    fill(0, 170);
    rect(0, 0, width, height);

    textAlign(CENTER, CENTER);
    fill(245);
    textSize(36);

    if (state == PAUSED) {
      text("PAUSED", width * 0.5, height * 0.45);
      textSize(18);
      text("Press P to resume", width * 0.5, height * 0.55);
    } else if (state == DEAD) {
      text("YOU DIED", width * 0.5, height * 0.45);
      textSize(18);
      text("Press R to respawn at checkpoint", width * 0.5, height * 0.55);
    } else if (state == WON) {
      text("LEVEL COMPLETE!", width * 0.5, height * 0.45);
      textSize(18);
      text("All coins collected. Press R to play again.", width * 0.5, height * 0.55);
    }
  }

  void handleKeyPressed(char k, int keyCode) {
    if (k == 'p' || k == 'P') {
      if (state == PLAYING) state = PAUSED;
      else if (state == PAUSED) state = PLAYING;
      return;
    }

    if (k == 'r' || k == 'R') {
      resetFromCheckpoint();
      return;
    }

    if (state != PLAYING) return;

    if (k == 'a' || k == 'A' || keyCode == LEFT) runner.moveLeft = true;
    if (k == 'd' || k == 'D' || keyCode == RIGHT) runner.moveRight = true;
    if (k == 'w' || k == 'W' || k == ' ' || keyCode == UP) runner.jumpPressed = true;
  }

  void handleKeyReleased(char k, int keyCode) {
    if (k == 'a' || k == 'A' || keyCode == LEFT) runner.moveLeft = false;
    if (k == 'd' || k == 'D' || keyCode == RIGHT) runner.moveRight = false;
  }

  void resetFromCheckpoint() {
    if (state == WON) {
      state = PLAYING;
      coinsCollected = 0;
      activeCheckpointIndex = 0;
      spawnPoint.set(70, 430);
      for (Coin c : coins) c.collected = false;
      for (Checkpoint cp : checkpoints) cp.activated = false;
      checkpoints.get(0).activated = true;
    } else {
      state = PLAYING;
    }

    runner.x = spawnPoint.x;
    runner.y = spawnPoint.y;
    runner.vx = 0;
    runner.vy = 0;
    runner.moveLeft = false;
    runner.moveRight = false;
    runner.jumpPressed = false;
    goalLockedTimer = 0;
  }
}

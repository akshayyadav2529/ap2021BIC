class GameWorld {
  final float CHECKPOINT_PULSE_BASE = 46;
  final float CHECKPOINT_PULSE_AMPLITUDE = 6;
  final float CHECKPOINT_PULSE_FREQUENCY = TWO_PI / 18.0;

  Runner hero;
  ArrayList<SolidBlock> blocks = new ArrayList<SolidBlock>();
  ArrayList<Coin> coins = new ArrayList<Coin>();

  PVector cam = new PVector();
  boolean paused;

  int score;
  int totalCoins;
  PVector checkpointPos;
  SolidBlock checkpointBlock;
  boolean checkpointActive;
  int checkpointPulseFrames;
  int checkpointPulseTick;
  int goalHintFrames;

  GameWorld() {
    resetLevelFresh();
    cam.set(hero.loc.x, hero.loc.y);
  }

  void resetLevelFresh() {
    score = 0;
    checkpointPos = new PVector(120, 200);
    checkpointActive = false;
    checkpointPulseFrames = 0;
    checkpointPulseTick = 0;
    goalHintFrames = 0;
    buildLevel();
    hero = new Runner(checkpointPos.x, checkpointPos.y);
  }

  void respawnAtCheckpoint() {
    hero = new Runner(checkpointPos.x, checkpointPos.y);
    paused = false;
  }

  void buildLevel() {
    blocks.clear();
    coins.clear();

    blocks.add(new SolidBlock(640, 680, 1400, 80));
    blocks.add(new SolidBlock(380, 560, 240, 40));
    blocks.add(new SolidBlock(660, 500, 240, 40));
    blocks.add(new SolidBlock(940, 440, 240, 40));

    // Today extension: simple extra path to make progression feel larger.
    blocks.add(new SolidBlock(1160, 380, 220, 40));
    blocks.add(new SolidBlock(1360, 330, 180, 40));

    blocks.add(new SolidBlock(1030, 640, 180, 40, 1));

    checkpointBlock = new SolidBlock(940, 390, 40, 40, 3);
    blocks.add(checkpointBlock);

    blocks.add(new SolidBlock(1460, 250, 120, 120, 2));

    coins.add(new Coin(380, 520));
    coins.add(new Coin(660, 460));
    coins.add(new Coin(940, 400));
    coins.add(new Coin(1160, 340));
    coins.add(new Coin(1360, 290));

    totalCoins = coins.size();
  }

  void update() {
    handleGlobalInput();

    background(8, 18, 28);

    if (!paused && !hero.dead && !hero.won) {
      hero.update(blocks);
      updateCoins();
      updateCheckpointTrigger();
      updateGoalState();
    }

    if (hero.dead) {
      respawnAtCheckpoint();
    }

    if (checkpointPulseFrames > 0) {
      checkpointPulseFrames--;
      checkpointPulseTick++;
    }
    if (goalHintFrames > 0) goalHintFrames--;

    updateCamera();

    pushMatrix();
    applyCameraTransform();

    renderWorld();

    popMatrix();

    drawHud();
  }

  void updateCoins() {
    for (Coin c : coins) {
      if (!c.collected && hero.overlaps(c)) {
        c.collected = true;
        score++;
      }
    }
  }

  void updateCheckpointTrigger() {
    if (!checkpointActive && hero.overlaps(checkpointBlock)) {
      checkpointActive = true;
      checkpointPos.set(checkpointBlock.loc.x, checkpointBlock.loc.y - 50);
      checkpointPulseFrames = 60;
      checkpointPulseTick = 0;
    }
  }

  void updateGoalState() {
    if (!hero.touchedGoal) return;

    if (score >= totalCoins) {
      hero.won = true;
    } else {
      goalHintFrames = 90;
    }
  }

  void renderWorld() {
    for (SolidBlock b : blocks) {
      b.render();

      if (b == checkpointBlock && checkpointPulseFrames > 0) {
        noFill();
        stroke(80, 220, 230, 210);
        float pulse = CHECKPOINT_PULSE_BASE + CHECKPOINT_PULSE_AMPLITUDE * sin(checkpointPulseTick * CHECKPOINT_PULSE_FREQUENCY);
        rect(b.loc.x, b.loc.y, pulse, pulse);
        noStroke();
      }
    }

    for (Coin c : coins) c.render();
    hero.render();
  }

  void handleGlobalInput() {
    if (rHold) {
      resetLevelFresh();
      paused = false;
      rHold = false;
    }

    if (pHold && !oldPHold && !hero.won) {
      paused = !paused;
    }
    oldPHold = pHold;
  }

  void updateCamera() {
    float smooth = 0.12;
    cam.x = lerp(cam.x, hero.loc.x, smooth);
    cam.y = lerp(cam.y, hero.loc.y, smooth);
  }

  void applyCameraTransform() {
    translate(width * 0.5 - cam.x, height * 0.5 - cam.y);
  }

  void drawHud() {
    fill(180, 210, 235);
    textSize(16);
    text("Arrow keys move, UP jumps, P pauses, R resets", 20, 28);
    text("Coins: " + score + " / " + totalCoins, 20, 52);

    String cpText = "Checkpoint: ";
    if (checkpointActive) cpText += "Active";
    else cpText += "Start";
    text(cpText, 20, 76);

    // Yesterday polish: clearer state text on top of gameplay.
    if (paused) {
      fill(190, 220, 255);
      textSize(28);
      text("Paused", width * 0.5 - 50, 90);
    } else if (hero.won) {
      fill(255, 235, 150);
      textSize(28);
      text("You Win - Press R to play again", width * 0.5 - 205, 90);
    } else if (goalHintFrames > 0) {
      fill(255, 215, 120);
      textSize(24);
      text("Collect all coins to unlock the goal", width * 0.5 - 220, 90);
    }

    if (checkpointPulseFrames > 0) {
      fill(120, 240, 240);
      textSize(20);
      text("Checkpoint activated!", width * 0.5 - 110, 120);
    }
  }
}

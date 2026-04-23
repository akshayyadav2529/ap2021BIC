class GameWorld {
  Runner player;
  ArrayList<SolidBlock> solids = new ArrayList<SolidBlock>();
  ArrayList<Coin> coins = new ArrayList<Coin>();
  ArrayList<MovingHazard> hazards = new ArrayList<MovingHazard>();
  ArrayList<PVector> checkpoints = new ArrayList<PVector>();

  int totalCoins = 0;
  int collectedCoins = 0;
  int activeCheckpoint = 0;
  int tick = 0;

  float worldWidth = 2800;
  float cameraX = 0;

  boolean leftHeld = false;
  boolean rightHeld = false;
  boolean jumpQueued = false;

  GameWorld() {
    buildLevel();
    player = new Runner(checkpoints.get(0).x, checkpoints.get(0).y);
  }

  void buildLevel() {
    solids.add(new SolidBlock(0, 550, worldWidth, 80));

    solids.add(new SolidBlock(220, 470, 120, 24));
    solids.add(new SolidBlock(420, 420, 120, 24));
    solids.add(new SolidBlock(620, 370, 120, 24));
    solids.add(new SolidBlock(840, 450, 150, 24));
    solids.add(new SolidBlock(1040, 395, 160, 24));

    solids.add(new SolidBlock(1260, 500, 120, 24));
    solids.add(new SolidBlock(1440, 445, 120, 24));
    solids.add(new SolidBlock(1620, 390, 120, 24));
    solids.add(new SolidBlock(1800, 335, 120, 24));
    solids.add(new SolidBlock(1970, 390, 170, 24));
    solids.add(new SolidBlock(2210, 450, 200, 24));
    solids.add(new SolidBlock(2460, 500, 220, 24));

    hazards.add(new MovingHazard(520, 520, 90, 2.3));
    hazards.add(new MovingHazard(1120, 365, 60, 1.9));
    hazards.add(new MovingHazard(1540, 520, 140, 2.4));
    hazards.add(new MovingHazard(2110, 520, 120, 2.1));

    addCoinRow(250, 425, 3, 48);
    addCoinRow(650, 325, 3, 48);
    addCoinRow(1070, 350, 3, 48);

    addCoinRow(1460, 400, 4, 45);
    addCoinRow(1810, 290, 3, 45);
    addCoinRow(2250, 405, 4, 42);

    checkpoints.add(new PVector(70, 500));
    checkpoints.add(new PVector(1290, 450));
    checkpoints.add(new PVector(2250, 400));

    totalCoins = coins.size();
  }

  void addCoinRow(float x, float y, int count, float spacing) {
    for (int i = 0; i < count; i++) {
      coins.add(new Coin(x + i * spacing, y));
    }
  }

  void update() {
    tick++;

    player.update(solids, leftHeld, rightHeld, jumpQueued);
    jumpQueued = false;

    for (MovingHazard hazard : hazards) {
      hazard.update();
      if (Collider.overlap(player, hazard)) {
        respawn();
      }
    }

    for (Coin coin : coins) {
      if (!coin.collected && Collider.overlap(player, coin)) {
        coin.collected = true;
        collectedCoins++;
      }
    }

    checkCheckpointProgress();

    if (player.top() > height + 200) {
      respawn();
    }

    float targetCam = player.pos.x - width * 0.35;
    cameraX = constrain(lerp(cameraX, targetCam, 0.12), 0, worldWidth - width);
  }

  void checkCheckpointProgress() {
    for (int i = activeCheckpoint + 1; i < checkpoints.size(); i++) {
      PVector c = checkpoints.get(i);
      if (abs(player.pos.x - c.x) < 30 && abs(player.pos.y - c.y) < 80) {
        activeCheckpoint = i;
      }
    }
  }

  void respawn() {
    player.deaths++;
    PVector cp = checkpoints.get(activeCheckpoint);
    player.pos.x = cp.x;
    player.pos.y = cp.y;
    player.vel.set(0, 0);
  }

  void render() {
    drawBackground();

    pushMatrix();
    translate(-cameraX, 0);

    drawCheckpointMarkers();

    for (SolidBlock block : solids) block.display();
    for (Coin coin : coins) coin.display(tick);
    for (MovingHazard hazard : hazards) hazard.display(tick);

    drawGoalFlag();
    player.display(tick);

    popMatrix();

    drawHUD();
  }

  void drawBackground() {
    for (int y = 0; y < height; y++) {
      float t = map(y, 0, height, 0, 1);
      stroke(lerpColor(color(122, 204, 255), color(234, 249, 255), t));
      line(0, y, width, y);
    }

    noStroke();
    fill(150, 190, 220, 100);
    for (int i = 0; i < 8; i++) {
      float mx = (i * 340 - cameraX * 0.25) % (width + 340) - 140;
      triangle(mx, 470, mx + 120, 310, mx + 240, 470);
    }
  }

  void drawCheckpointMarkers() {
    for (int i = 1; i < checkpoints.size(); i++) {
      PVector c = checkpoints.get(i);
      boolean active = i <= activeCheckpoint;
      stroke(active ? color(80, 220, 120) : color(220, 220, 220));
      strokeWeight(3);
      line(c.x, c.y - 70, c.x, c.y - 5);
      noStroke();
      fill(active ? color(80, 220, 120) : color(255, 250, 200));
      triangle(c.x, c.y - 70, c.x + 28, c.y - 58, c.x, c.y - 46);

      if (!active && abs(player.pos.x - c.x) < 140) {
        fill(20, 40, 70, 215);
        rect(c.x - 46, c.y - 110, 92, 24, 6);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(12);
        text("CHECKPOINT", c.x, c.y - 98);
      }
    }
  }

  void drawGoalFlag() {
    float gx = worldWidth - 90;
    stroke(80);
    strokeWeight(4);
    line(gx, 520, gx, 420);
    noStroke();
    fill(255, 190, 56);
    triangle(gx, 420, gx + 48, 435, gx, 450);

    if (player.pos.x > worldWidth - 180) {
      fill(15, 40, 70, 220);
      rect(gx - 160, 60, 220, 52, 10);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("Finish reached!", gx - 50, 86);
    }
  }

  void drawHUD() {
    fill(12, 28, 48, 210);
    rect(14, 12, 310, 88, 10);

    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Coins: " + collectedCoins + " / " + totalCoins, 26, 24);
    text("Deaths: " + player.deaths, 26, 48);
    text("Checkpoint: " + (activeCheckpoint + 1) + " / " + checkpoints.size(), 26, 70);

    float cd = map(player.dashCooldown, 80, 0, 0, 100);
    fill(255, 255, 255, 140);
    rect(200, 28, 100, 12, 6);
    fill(player.dashCooldown == 0 ? color(102, 230, 170) : color(255, 188, 90));
    rect(200, 28, cd, 12, 6);
    fill(255);
    textSize(11);
    text(player.dashCooldown == 0 ? "Dash Ready" : "Dash Charging", 202, 46);
  }

  void onKeyPressed(char k, int code) {
    if (k == 'a' || code == LEFT) leftHeld = true;
    if (k == 'd' || code == RIGHT) rightHeld = true;
    if (k == 'w' || k == ' ' || code == UP) jumpQueued = true;
    if (k == 'k' || k == 'K' || code == SHIFT) player.startDash();
    if (k == 'r' || k == 'R') respawn();
  }

  void onKeyReleased(char k, int code) {
    if (k == 'a' || code == LEFT) leftHeld = false;
    if (k == 'd' || code == RIGHT) rightHeld = false;
  }
}

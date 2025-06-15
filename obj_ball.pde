class Ball {
  float x, y, w, h, dx, dy, centerX, centerY, velocity, launchDegrees, randomLaunchDegrees;
  boolean isAboveRacket, isOnTopOfRacket, isHigherThanRacket;
  Item tmp_item;


  Ball() {
    // ボールの大きさをブロックの高さの4/5から15までに制限
    w = constrain(blocks.h*4/5, min(blocks.w, blocks.h)*4/5, 15);
    h = w;
    velocity = 6;
    launchDegrees = 300;
  }


  void standByBall() {
    x = racket.x + racket.w/2 - w/2;
    y = racket.y - h;
  }


  void bounceByWalls() {
    if (x<=gameManager.wall_left || gameManager.wall_right<=x+w) {
      dx = -dx;
    }
    if (y<=gameManager.wall_top) {
      dy = abs(dy);
    }
  }


  void setVelocity() {
    dx = velocity * cos(radians(launchDegrees));
    dy = velocity * sin(radians(launchDegrees));
  }


  void randomSetVelocity() {
    launchDegrees = random(5, 355);
    while (launchDegrees%90 < 5 || 85 < launchDegrees%90) {
      launchDegrees = random(5, 355);
    }
    setVelocity();
  }


  void bounceByRacket() {
    isAboveRacket = x+w>racket.x && x<racket.x+racket.w;
    isHigherThanRacket = y+h>racket.y && centerY<=racket.y+racket.h;
    isOnTopOfRacket = isAboveRacket && isHigherThanRacket;
    if (isOnTopOfRacket) {
      launchDegrees = -90 + (centerX-racket.centerX)/racket.w*120;
      setVelocity();
    }
  }


  void randomlyScatter() {
    launchDegrees = random(-180, 180);
    setVelocity();
  }


  void observeBlocks() {
    for (int i=0; i<blocks.numberOfRow; i++) {
      for (int j=0; j<blocks.numberOfCol; j++) {
        if (blocks.lifesMatrix[i][j]!=0) {
          float blocks_x = gameManager.wall_left + blocks.w * j; // ブロックのx座標は左の壁からj個目
          float blocks_y = gameManager.wall_top + blocks.h * (i+1); // ブロックのy座標は上の壁からi+1個目(上の壁からブロックの高さ1個分離す)
          float blocks_w = blocks.w;
          float blocks_h = blocks.h;
          int hitBlockState = blockHitCheck(blocks_x, blocks_y, blocks_w, blocks_h, x, y, w, h, dx, dy);
          if (hitBlockState == 1) {
            // x軸方向の衝突
            dx = -dx;
          } else if (hitBlockState == 2) {
            // y軸方向の衝突
            dy = -dy;
          } else if (hitBlockState == 3) {
            // x軸,y軸方向ともに衝突
            dx = -dx;
            dy = -dy;
          }
          // ボールがブロックに衝突&ブロックのライフが0より大きい時
          if (hitBlockState > 0 && blocks.lifesMatrix[i][j] > 0) {
            blocks.lifesMatrix[i][j]--;
            blocks.sumOfLifes--;
            gameManager.currentScore+=balls.size();
            // 任意の確率でブロックのライフが減ったらアイテムを落とす
            randomNum = random(1);
            if (randomNum < gameManager.probablityOfDropItem) {
              tmp_item = new Item();
              tmp_item.x = blocks_x + blocks_w/2;
              tmp_item.y = blocks_y + blocks_h/2;
              items.add(tmp_item);
            }
          }
        }
      }
    }
  }


  void move() {
    x += dx;
    y += dy;
    x = constrain(x, gameManager.wall_left, gameManager.wall_right - h); // ボールのx座標を左右の壁の間に制限
    y = constrain(y, gameManager.wall_top, height + h); // ボールのy座標を上の壁から画面下までに制限
    centerX = x + w/2;
    centerY = y + h/2;
    bounceByWalls();
    bounceByRacket();
  }


  void show() {
    observeBlocks(); // ブロックの衝突判定を見る
    if (!gameManager.isBeforeGame && !gameManager.isPausing) {
      move();
    } else if (gameManager.isBeforeGame) {
      standByBall();
    }
    noStroke();
    fill(255, 64, 64);
    rect(x, y, w, h);
  }
}

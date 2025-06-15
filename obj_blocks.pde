class Blocks {
  float posX, posY, w, h;
  int numberOfRow, numberOfCol;
  int lifesMatrix[][];
  int sumOfLifes;


  void initBlocksLife() {
    String stageFname = stageDataFname(gameManager.currentStage);
    String stageData[] = loadStrings(stageFname);
    String stageSizeData[] = split(stageData[0], " ");
    numberOfRow = int(stageSizeData[0]);
    numberOfCol = int(stageSizeData[1]);
    lifesMatrix = new int[numberOfRow][numberOfCol];
    for (int i=0; i<numberOfRow; i++) {
      // ステージデータの2行目から表示
      String stageDataOfRow[] = split(stageData[i+1], " ");
      for (int j=0; j<numberOfCol; j++) {
        lifesMatrix[i][j] = int(stageDataOfRow[j]);
        if (lifesMatrix[i][j]>0) {
          sumOfLifes += lifesMatrix[i][j];
        }
      }
    }
    // ブロックの横幅=ボールが動ける横幅/ブロックの横の数
    w = gameManager.gameAreaWidth/numberOfCol;
    h = w*4/5;
  }


  void selectBlockColor(int life) {
    stroke(1);
    // ブロックの色を指定
    if (life < 0) {
      // 壊れないブロックの色
      fill(32);
    } else if (life == 0) {
      // 消えたブロックの色
      fill(0, 0, 0, 0);
    } else if (life == 1) {
      fill(128, 128, 255);
    } else if (life == 2) {
      fill(128, 255, 128);
    } else if (life == 3) {
      fill(255, 255, 128);
    } else if (life == 4) {
      fill(255, 128, 64);
    } else if (life >= 5) {
      fill(255, 64, 64);
    }
  }


  void show() {
    for (int i=0; i<numberOfRow; i++) {
      for (int j = 0; j < numberOfCol; j++) {
        int life = lifesMatrix[i][j];
        posX = gameManager.wall_left + j*w;
        posY = gameManager.wall_top + (i+1)*h;

        // ライフが0でない(ライフが1以上orブロックが壊せない)時
        if (life != 0){
          selectBlockColor(life);
          rect(posX, posY, w, h);
        }

        // ブロックが壊せる時(ライフが0より大きい時)
        if (life > 0) {
          // ライフ数を表示
          fill(0);
          textAlign(CENTER, CENTER);
          textSize(h/2);
          text(lifesMatrix[i][j], posX+w/2, posY+h/2);
        }
        
      }
    }
  }
}

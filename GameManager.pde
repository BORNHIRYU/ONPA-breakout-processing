class GameManager {
  final String titleScreen = "title";
  final String gameScreen = "game";
  final String ruleDescriptionScreen = "rule";
  final float wall_top = 50; // ボールが動く領域の上部の限界を表すy座標
  final float gameAreaWidth = constrain(width*3/5, width*3/5, 600); // ボールが動く領域の横幅
  final float sideWidth = (width-gameAreaWidth)/2;
  final float wall_left = sideWidth; // ボールが動く領域を左右方向で中央におくときの、左の壁のx座標
  final float wall_right = width - wall_left; // ボールが動く領域を左右方向で中央におくときの、右の壁のx座標
  final float probablityOfDropItem = .5;
  String displayState;
  boolean isGameScreen;
  boolean isPlayingNow, isBeforeGame, isStageClear, isPausing, isGameover, isTesting;
  int currentStage, currentScore;
  int amountOfBalls;
  Ball tmp_ball, new_ball;
  Item tmp_item, exampleItem;


  GameManager() {
    // ゲーム起動時の設定
    displayState = titleScreen;
    isGameScreen = displayState==gameScreen;
    isBeforeGame = false;
    isPlayingNow = false;
    isStageClear = false;
    isPausing = false;
    isGameover = false;
    isTesting = false;
    currentStage = 1;
    currentScore = 0;
    genshinGothicFont = createFont("NotoSansJP-Black.ttf", 72);
    textFont(genshinGothicFont);
    textAlign(CENTER, CENTER);
    // ルール説明用のアイテム
    exampleItem = new Item();
    exampleItem.isExampleObj = true;
    exampleItem.x = width/2+200;
    exampleItem.y = height/3;
  }


  // ステージ開始時の設定
  void initStageState() {
    isBeforeGame = true;
    isPlayingNow = false;
    isStageClear = false;
    isGameover = false;
    blocks = new Blocks();
    blocks.initBlocksLife();
    ball = new Ball();
    balls.clear();
    balls.add(ball);
    items.clear();
  }


  // 最初からゲームスタートする時の設定
  void initGamesState() {
    currentStage = 1;
    currentScore = 0;
    initStageState();
  }


  void updateStateByKey(int pressKeysCode) {
    // ゲーム中でない&ゲームオーバーしてない&ステージクリアしてない→ゲーム直前
    isBeforeGame = !isPlayingNow && !isGameover && !isStageClear;
    if (displayState==titleScreen && pressKeysCode==spaceKeyCode) {
      // タイトル画面でSPACEキーが押されたらゲーム画面表示
      initGamesState();
      displayState = gameScreen;
      displayGameScreen();
    } else if (displayState==titleScreen && pressKeysCode==RKeyCode) {
      // タイトル画面でRキーが押されたらルール画面表示
      displayState = ruleDescriptionScreen;
    } else if (displayState==ruleDescriptionScreen && pressKeysCode==RKeyCode) {
      // ルール画面でRキーが押されたらタイトル画面表示
      displayState = titleScreen;
    } else if (isBeforeGame && pressKeysCode==spaceKeyCode) {
      // ゲーム開始の瞬間
      ball.setVelocity();
      isPlayingNow = true;
      isBeforeGame = false;
    } else if (isPlayingNow && !isPausing && pressKeysCode==PKeyCode) {
      // ポーズに入る
      isPausing = true;
    } else if (isPlayingNow && isPausing && (pressKeysCode==PKeyCode || pressKeysCode==spaceKeyCode)) {
      // ポーズを解除
      isPausing = false;
    } else if (isGameover && pressKeysCode==spaceKeyCode) {
      // ゲームオーバー後にゲームの初期設定を行う
      initGamesState();
    } else if (displayState==gameScreen && !isPlayingNow && pressKeysCode==QKeyCode) {
      // タイトル画面に移動し、ゲームの初期設定を行う
      initGamesState();
      displayState = titleScreen;
    } else if (isStageClear && pressKeysCode==spaceKeyCode) {
      // ステージクリアのとき次ステージへ進む
      currentStage++;
      initStageState();
    }
    // テスト用キーマップ
    if (pressKeysCode==TKeyCode && !isTesting) {
      isTesting = true;
    } else if (pressKeysCode==TKeyCode && isTesting) {
      isTesting = false;
    }
  }


  void displayTitleScreen() {
    background(0, 96, 0);
    fill(255);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("音で操作する新感覚ブロック崩し", width/2, height/2 - 200);
    text("SPACEキー で開始\nRキー でルール説明", width/2, height/2 + 200);
    textSize(32);
    text("ON", width/2-80, height/2 - 80);
    text("PA", width/2+80, height/2 - 80);
    textSize(128);
    text("音", width/2-80, height/2);
    fill(255, 64, 64);
    text("破", width/2+80, height/2);
  }


  void displayRuleDescriptionScreen() {
    background(0, 96, 0);
    fill(255);
    textSize(32);
    textAlign(LEFT, CENTER);
    text("音でラケットを操作せよ！\n音が大きいほど右に移動するぞ！", 100, height*2/5);
    text("このアイテムをラケットで\n取ればボールが3倍に増殖！", width/2+50, height*2/5);
    text("ブロックにボールを当てて破壊せよ！\n全て破壊できたらステージクリアだ！", 100, height*3/5);
    text("ブロックを全て壊せていないまま\nボールを全て落としたらゲームオーバー", width/2+50, height*3/5);
    textAlign(CENTER, CENTER);
    textSize(64);
    text("ルール説明", width/2, height/5);
    textSize(48);
    text("Rキー でタイトルへ戻る", width/2, height*4/5);
    textSize(24);
    text("アイテム", width*6/7+50 - exampleItem.w, height*2/5 - exampleItem.h - 9);
    // アイテム表示の例を見せる
    exampleItem.x = width*6/7+50 - exampleItem.w;
    exampleItem.y = height*2/5 - exampleItem.h + 18;
    exampleItem.show();
  }


  // 直近で取得した音量の平均を計算する
  void updateVoicePowers(float a) {
    a_sum = 0;
    for (int i=0; i<voicePowers.length-1; i++) {
      a_sum += voicePowers[i+1];
      voicePowers[i] = voicePowers[i+1];
    }
    voicePowers[voicePowers.length-1] = a;
    a_avg = a_sum/voicePowers.length;
  }


  void displayPausePopup() {
    fill(255, 255, 128, 208);
    rect(100, 100, width-200, height-200);
    fill(0);
    textSize(64);
    text("PAUSE", width/2, height/2 - 50);
    textSize(32);
    text("SPACEキー or Pキー で再開", width/2, height/2 + 50);
  }


  void displayStageClearPopup() {
    fill(0, 255, 0, 208);
    rect(100, 100, width-200, height-200);
    stroke(2);
    fill(0);
    textSize(64);
    text("STAGE CLEAR!!!", width/2, height/2 - 50);
    textSize(32);
    text("SPACEキーで次のステージへ進め", width/2, height/2 + 50);
  }


  void displayGameoverPopup() {
    fill(255, 0, 0, 208);
    rect(100, 100, width-200, height-200);
    stroke(2);
    fill(255);
    textSize(32);
    text("記録: " + currentScore + "点", width/2, height/2 - 100);
    textSize(64);
    text("GAME OVER...", width/2, height/2);
    textSize(32);
    text("SPACEキーでリトライ\nQキーでタイトルへ戻る", width/2, height/2 + 100);
  }


  // アイテムを取ったときにボールを増やす処理
  void multiplyBall() {
    amountOfBalls = balls.size(); // 画面上のボールの個数
    for (int i=0; i<amountOfBalls; i++) {
      if (amountOfBalls<4096) {
        tmp_ball = balls.get(i);
        for (int j=0; j<2; j++) {
          new_ball = new Ball();
          new_ball.x = tmp_ball.x;
          new_ball.y = tmp_ball.y;
          new_ball.randomSetVelocity();
          balls.add(new_ball);
        }
      }
    }
  }


  void displayGameScreen() {
    // background
    noStroke();
    background(64, 0, 128);
    fill(255, 255, 224);
    rect(wall_left, wall_top, gameAreaWidth, height);

    // 画面左端と右端のサウンドバー
    fill(0, 255, 255, 192);
    rect(0, height*(1-2*a), 50, height);
    rect(width-50, height*(1-2*a), width, height);

    // ゲーム画面横の情報
    fill(255);
    textSize(16);
    text("アイテム", wall_right + sideWidth/2, height/3-25);
    text("ボール×3", wall_right + sideWidth/2, height/3+25);
    text("ポーズは\nPキー", wall_right + sideWidth/2, height*2/3);
    exampleItem.x = wall_right + sideWidth/2 - exampleItem.w/2;
    exampleItem.y = height/3 - exampleItem.h/2 +5;
    exampleItem.show();

    a = amp.analyze(); // 音量を数値として代入
    updateVoicePowers(a); // 直近で取得した音量の平均を計算

    racket.show();
    blocks.show();
    // 配列に格納したボールを1つずつ取得して処理
    for (int i=balls.size()-1; i>=0; i--) {
      tmp_ball = balls.get(i);
      tmp_ball.show();
      // 画面下へ消えたら削除
      if (tmp_ball.y >= height) {
        balls.remove(i);
      }
    }
    // アイテムを表示し、画面下へ消えたら削除
    for (int i=items.size()-1; i>=0; i--) {
      tmp_item = items.get(i);
      tmp_item.show();
      // 画面下へ消えたら削除
      if (tmp_item.y - tmp_item.r > height) {
        items.remove(i);
      }
    }
    amountOfBalls = balls.size();

    // ステージ数とスコアを表示
    fill(255);
    textSize(24);
    text("STAGE " + currentStage, wall_left/2, wall_top/2);
    text("score: " + currentScore, width/2, wall_top/2);

    // ステージ開始直前のみ表示
    if (isBeforeGame) {
      textSize(16);
      fill(0);
      text("マウスでスタート位置を調節\nSPACEキーでスタート\nゲーム中でない時はQキーで強制終了", width/2, height*3/5);
    }

    // テストプレイ中のみボールの個数を表示
    if (isTesting) {
      text(amountOfBalls, wall_right+sideWidth/2, wall_top/2);
    }

    // ステージクリアの条件
    if (blocks.sumOfLifes<=0) {
      isStageClear = true;
      isPlayingNow = false;
      isPausing = false;
      items.clear();
    }

    // ゲームオーバーの条件
    if (balls.size()==0 && !isStageClear) {
      isGameover = true;
      isPlayingNow = false;
      isPausing = false;
    }

    // ポップアップ
    if (isPausing) {
      displayPausePopup();
    } else if (isGameover) {
      displayGameoverPopup();
    } else if (isStageClear) {
      displayStageClearPopup();
    }
  }

  void show() {
    // タイトル・ゲーム・ルールのいずれかを表示
    if (displayState==titleScreen) {
      displayTitleScreen();
    } else if (displayState==gameScreen) {
      displayGameScreen();
    } else if (displayState==ruleDescriptionScreen) {
      displayRuleDescriptionScreen();
    }
  }
}

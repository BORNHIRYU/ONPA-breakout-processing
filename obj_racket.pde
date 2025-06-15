class Racket {
  float x, y, w, h, centerX;
  Item tmp_item;


  Racket() {
    x = constrain(mouseX - w/2, gameManager.wall_left, gameManager.wall_right - w);
    y = height - 50;
    w = 100;
    h = 15;
    centerX = x + w/2;
  }


  void catchItem() {
    for (int i=items.size()-1; i>=0; i--) {
      tmp_item = items.get(i);
      int ret = blockHitCheck(x, y, w, h, tmp_item.x, tmp_item.y, tmp_item.w, tmp_item.h, 0, tmp_item.v);
      if (ret>0) {
        items.remove(i);
        gameManager.multiplyBall();
      }
    }
  }


  void show() {
    // ゲーム直前でない&テストプレイしていない時
    if (!gameManager.isBeforeGame && !gameManager.isTesting) {
      // 声が大きいほど右に移動させる
      x = constrain(round(gameManager.wall_left - w + gameManager.gameAreaWidth*a_avg*3), gameManager.wall_left - w, gameManager.wall_right-w);
    } else {
      // ラケットの位置を左の壁から右の壁までに制限
      x = constrain(mouseX - w/2, gameManager.wall_left, gameManager.wall_right-w);
    }
    centerX = x + w/2;
    catchItem();
    fill(64, 192, 64);
    rect(x, y, w, h);
  };
}

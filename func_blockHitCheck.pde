int blockHitCheck(float block_x, float block_y, float block_w, float block_h,
  float ball_x, float ball_y, float ball_w, float ball_h, float dx, float dy) {
  int xflag = 0, yflag = 0;
  if (!isOverlap(ball_x, ball_y, ball_w, ball_h, ball_x+dx, ball_y+dy, ball_w, ball_h)) {
    return 0; // ぶつからなかったら 0を返す
  }

  // X軸方向にぶつかることを判定
  if (isOverlap(block_x, block_y, block_w, block_h,
    ball_x+dx, ball_y, ball_w, ball_h)) xflag = 1;

  // Y軸方向にぶつかることを判定
  if (isOverlap(block_x, block_y, block_w, block_h,
    ball_x, ball_y+dy, ball_w, ball_h)) yflag = 2;
  return xflag + yflag;
}

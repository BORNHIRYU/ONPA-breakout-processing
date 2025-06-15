class Item {
  int r = 10;
  float x, y, w, h, v;
  float brightness, brightness_velocity;
  boolean isExampleObj;


  Item() {
    w = 8;
    h = 8;
    v = 3;
    brightness = 0;
    brightness_velocity = 16;
    isExampleObj = false;
  }


  void move() {
    y += v;
  }


  void bright() {
    if ((brightness==0 && brightness_velocity<0) || (brightness==255 && brightness_velocity>0)) {
      brightness_velocity = -brightness_velocity;
    }
    brightness += brightness_velocity;
    brightness = constrain(brightness, 0, 255);
  }


  void show() {
    if (!gameManager.isPausing) {
      if (!isExampleObj) {
        move();
      }
      bright();
    }
    noStroke();
    fill(brightness, brightness, 255);
    rect(x, y, w, h);
  }
}

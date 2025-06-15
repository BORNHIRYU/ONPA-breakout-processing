import processing.sound.*; //<>//

GameManager gameManager;
Racket racket;
Ball ball;
Blocks blocks;
AudioIn in;
Amplitude amp;
PFont genshinGothicFont;
ArrayList<Ball> balls;
ArrayList<Item> items;

final int spaceKeyCode = 32;
final int leftKeyCode = 37;
final int rightKeyCode = 39;
final int PKeyCode = 80;
final int QKeyCode = 81;
final int RKeyCode = 82;
final int TKeyCode = 84;
float a, sz, a_sum, a_avg;
float voicePowers[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
float randomNum;


// ステージ数をもとにステージのファイル名を作成
String stageDataFname(int currentStage) {
  int stageDataMax = 10;
  int tmp_current_stage = currentStage;
  while (stageDataMax < tmp_current_stage) {
    tmp_current_stage -= stageDataMax;
  }
  String s = str(tmp_current_stage);
  while (s.length()<2) {
    // sを2文字にする
    s = "0" + s;
  }
  String stageDataFname = "stages/stage" + s + ".txt";
  return stageDataFname;
}


void keyPressed() {
  gameManager.updateStateByKey(keyCode);
}


void setup() {
  fullScreen();
  gameManager = new GameManager();
  racket = new Racket();
  blocks = new Blocks();
  balls = new ArrayList<Ball>();
  items = new ArrayList<Item>();

  // マイクを初期化
  in = new AudioIn(this);
  in.start();

  // 音量の取得を始める
  amp = new Amplitude(this);
  amp.input(in);
}


void draw() {
  gameManager.show();
}

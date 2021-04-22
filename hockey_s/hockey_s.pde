//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Server server;
//ボールの座標
float x, y;
//ボールの方向
int dirX, dirY;
//サーバ側バーの位置
float bar1X, bar1Y;
//クライアント側バーの位置
float bar2X, bar2Y;
//クライアント側のバー状態
int my_keycode;
int dirBar;
boolean keyPress;
//ポート番号を指定（今回は20000）
int port = 20000;


//KeyStateクラス
class KeyState {
  HashMap<Integer, Boolean> states = new HashMap<Integer, Boolean>();
  KeyState() {}
  
  void initialize() {
    states.put(LEFT, false);
    states.put(RIGHT, false);
    states.put(UP, false);
    states.put(DOWN, false);
  }
  
  boolean get(int code) {
    return states.get(code);
  }
  
  void put(int code, boolean state) {
    states.put(code, state);
  }
}//KeyState class



KeyState my_keyState;

//初期化
void setup(){
  //サーバを生成prot番ポートで立ち上げ
  server = new Server(this, port);
  x = 0;
  y = 0;
  dirX = 1;
  dirY = 1;
  bar1X = 50;
  bar1Y = height/2;
  bar2X = 550;
  bar2Y = height/2;
  
  my_keycode = 0;
  dirBar = 0;
  keyPress = false;
  size(600, 400);
  colorMode(HSB, 100);
  noStroke();
  ellipseMode(RADIUS);
  my_keyState = new KeyState();
  my_keyState.initialize();
}

void draw(){

  
  //クライアントからのデータ取得
  Client c = server.available();
  if(c != null) {
    //改行コード('\n')まで読み込む
    String msg = c.readStringUntil('\n');
    if (msg != null){
      //メッセージを空白で分割して配列に格納
      String[] data = splitTokens(msg);
      //クライアント側のバー状態
      my_keycode = int(data[0]);
      dirBar = int(data[1]);
      keyPress = boolean(data[2]);
      //全てのデータの送信
      //sendAllData();
    }
  }
  
  //キー操作
  if(my_keyState.get(LEFT)) {
    bar2Y += 4;
  }
  if(my_keyState.get(RIGHT)) {
    bar2Y -= 4;
  }
  if(my_keyState.get(UP)) {
    bar1Y -= 4;
  }
  if(my_keyState.get(DOWN)) {
    bar1Y += 4;
  }
  
  //描画処理
  //右側の壁の当たり判定
  if(x + 5 > 600) {
     dirX = -1;
     x = 600 - 5;//場所のリセット
  }
  //左側の壁の当たり判定
  if(x - 5 < 0) {
     dirX = 1;
     x = 5;//場所のリセット
  }
  
  //下の壁当たり判定
  if(y + 5 > 400) {
     dirY = -1;
     y = 400 - 5;//場所のリセット
  }
  
  //上の壁当たり判定
  if(y - 5 < 0) {
      dirY = 1;
      y = 5;//場所のリセット
  }
  //barの当たり判定
  if(x - 5 < bar1X + 10 && x - 5 > bar1X && y - 5 > bar1Y && y + 5 < bar1Y + 50) {
    dirX = 1;
  }
  
  
  //サーバbarの描画
  rect(bar1X, bar1Y, 10, 50);
  //クライアントbarの描画
  rect(bar2X, bar2Y, 10, 50);
  
  //相手（クライアント）の描画
  fill(100,10);
  rect(0, 0, 600, 400);
  noStroke();
  fill(60,60,80);
  ellipse(x,y,5,5);

  x += dirX*1;
  y += dirY*1;

  
  sendAllData();
}

  
void keyPressed() {
  my_keyState.put(keyCode, true);
}

void keyReleased() {
  my_keyState.put(keyCode, false);
}



//現在の状況をすべてのクライアントに送信
void sendAllData(){
  //サーバに送信するメッセージを作成
  //空白で区切り末尾は改行
  String msg = x + " " + y + " " + dirX + " " + dirY + " " + bar1X + " " + bar1Y + " " + bar2X + " " + bar2Y + '\n';
  print("server: " + msg);
  //サーバが接続しているすべてのクライアントに送信
  //(複数のクライアントが接続している場合は全てのクライアントに送信)
  server.write(msg);
}

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
//速さ
float vX;
float vY;
//クライアント側のバー状態
int my_keycode;
boolean barBool;
//ポート番号を指定（今回は20000）
int port = 20000;

//ゲームの状態遷移(0=タイトル, 1=ゲーム, 2=クリア)
int scene;


//スコア
int score_s, score_c;


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
  x = width/2;
  y = height/2;
  dirX = 1;
  dirY = 1;
  bar1X = 50;
  bar1Y = height/2;
  bar2X = 550;
  bar2Y = height/2;
  vX = 1;
  vY = 1;
  
  my_keycode = 0;
  barBool = false;
  
  scene = 0;
  
  score_s = 0;
  score_c = 0;
  
  textSize(32);
  textAlign(CENTER);
  
  size(600, 400);
  colorMode(HSB, 100);
  noStroke();
  ellipseMode(RADIUS);
  my_keyState = new KeyState();
  my_keyState.initialize();
}

void draw(){

  if(scene == 0) {
    title();
  } else if (scene == 1) {
    game();
  } else if (scene == 2) {
    clear();
  }
  
  
  
  
  
  
  
}//draw()

  
void keyPressed() {
  my_keyState.put(keyCode, true);
}

void keyReleased() {
  my_keyState.put(keyCode, false);
}

void title() {
   x = width/2;
   y = height/2;
   background(100);
   fill(60,60,80);
   textSize(32);
   text("press z to start", width * 0.5, height * 0.7);
   if(keyPressed && key == 'z'){ // if 'z' key is pressed
     scene = 1;
   }
}//title()

void game() {
  background(100);
  textSize(20);
  fill(30, 60, 80);
  text("server: " + score_s, width*0.1, height*0.1);
  fill(90, 60, 80);
  text("client: " + score_c, width*0.9, height*0.1);
  textSize(32);
  
  
  //キー操作で，それぞれのstateのbooleanをとってくる
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
  
  //クライアントのキー状況を反映(これが大事)
  my_keyState.put(my_keycode, barBool);
  
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
      barBool = boolean(data[1]);
      //全てのデータの送信
      //sendAllData();
    }
  }
  

  

  
  //描画処理
  //右側の壁の当たり判定
  if(x + 5 > 600) {
    if(y > 150 && y < 250) {
      score_s++;
      if(score_s == 3) {
        scene = 2;
      } else {
        scene = 0;
      }
    } else {
      dirX = -1;
      x = 600 - 5;
    }
    
  }
  //左側の壁の当たり判定
  if(x - 5 < 0) {
    if(y > 150 && y < 250) {
      score_c++;
      if(score_c == 3) {
        scene = 2;
      } else {
        scene = 0;
      }
    } else {
      dirX = 1;
      x = 5;
    }
    
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
  //bar1の当たり判定
  if(x - 5 < bar1X + 10 && x - 5 > bar1X && y - 5 > bar1Y && y + 5 < bar1Y + 50) {
    vX=random(2,4);
    dirX = 1;
  }
  
  //bar1の裏側判定
  if(x + 5 > bar1X && x + 5 < bar1X + 5 && y - 5 > bar1Y && y + 5 < bar1Y + 50) {
    dirX = -1;
  }
  
  //bar2の当たり判定
  if(x + 5 > bar2X && x + 5 < bar2X + 10 && y - 5 > bar2Y && y + 5 < bar2Y + 50) {
    vY=random(2,4);
    dirX = -1;
  }
  
  //bar2の裏側判定
  if(x - 5 < bar2X + 10 && x - 5 > bar2X + 5 && y - 5 > bar2Y && y + 5 < bar2Y + 50) {
    dirX = 1;
  }
  
  println("game()");
  //サーバゴールの表示
  fill(30, 60, 80);
  rect(0, 150, 3, 100);
  
  //サーバbarの描画
  rect(bar1X, bar1Y, 10, 50);
  
  
  //クライアントゴール
  fill(90,60, 80);
  rect(597, 150, 3, 100);
  //クライアントbarの描画
  rect(bar2X, bar2Y, 10, 50);
  
  //相手（クライアント）の描画
  fill(100,10);
  rect(0, 0, 600, 400);
  noStroke();
  fill(60,60,80);
  ellipse(x,y,5,5);

  x += dirX*vX;
  y += dirY*vY;

  
  sendAllData();
}//game()

void clear() {
  if(score_s > score_c) {
    text("sever win", width * 0.5, height * 0.5);
    noLoop();
  } else {
    text("client win", width * 0.5, height * 0.5);
    noLoop();
  }
    
    

}


//現在の状況をすべてのクライアントに送信
void sendAllData(){
  //サーバに送信するメッセージを作成
  //空白で区切り末尾は改行
  String msg = x + " " + y + " " + dirX + " " + dirY + " " + bar1X + " " + bar1Y + " " + bar2X + " " + bar2Y + " " + scene + " " + score_s + " " + score_c + '\n';
  print("server: " + msg);
  //サーバが接続しているすべてのクライアントに送信
  //(複数のクライアントが接続している場合は全てのクライアントに送信)
  server.write(msg);
}

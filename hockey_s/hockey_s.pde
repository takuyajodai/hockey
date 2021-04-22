//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Server server;
//ボールの座標
float x, y;
//ボールの方向
int dirX, dirY;
//サーバ側バーの位置
float bar1X, bar1Y;
//ポート番号を指定（今回は20000）
int port = 20000;

//初期化
void setup(){
  //サーバを生成prot番ポートで立ち上げ
  server = new Server(this, port);
  x = 0;
  y = 0;
  dirX = 1;
  dirY = 1;
  bar1X = 
  size(400,400);
  colorMode(HSB, 100);
  noStroke();
  ellipseMode(RADIUS);
}

void draw(){
  /*
  //クライアントからのデータ取得
  Client c = server.available();
  if(c != null) {
    //改行コード('\n')まで読み込む
    String msg = c.readStringUntil('\n');
    if (msg != null){
      //メッセージを空白で分割して配列に格納
      String[] data = splitTokens(msg);
      //クライアント側のx座標
      cx = int(data[0]);
      //クライアント側のy座標
      cy = int(data[1]);
      //全てのデータの送信
      sendAllData();
    }
  }
  */
  //描画処理
  //右側の壁の当たり判定
      if(x + 5 > 400) {
         dirX = -1;
         x = 400 - 5;//場所のリセット
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

//マウスクリックがクリックされたら
/*
void mouseClicked(){
  sx = mouseX;
  sy = mouseY;
  //全てのデータの送信
  sendAllData();
}
*/

void keyPressed() {
  if (key == CODED) {
    if(keyCode == UP) {
      bar1Y -= 4; 
    } else if (keyCode == DOWN) {
      bar1Y += 4;
    }
  }
}

//現在の状況をすべてのクライアントに送信
void sendAllData(){
  //サーバに送信するメッセージを作成
  //空白で区切り末尾は改行
  String msg = x + " " + y + " " + dirX + " " + dirY + '\n';
  print("server: " + msg);
  //サーバが接続しているすべてのクライアントに送信
  //(複数のクライアントが接続している場合は全てのクライアントに送信)
  server.write(msg);
}

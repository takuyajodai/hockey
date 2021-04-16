//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Server server;
//サーバ側でクリックした座標
int sx, sy;
//クライアント側でクリックした座標
int cx, cy;
//ポート番号を指定（今回は20000）
int port = 20000;

//初期化
void setup(){
  //サーバを生成prot番ポートで立ち上げ
  server = new Server(this, port);
  sx = 0;
  sy = 0;
  cx = 0;
  cy = 0;
  size(100,100);
  colorMode(RGB, 100);
  noStroke();
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
      //クライアント側のx座標
      cx = int(data[0]);
      //クライアント側のy座標
      cy = int(data[1]);
      //全てのデータの送信
      sendAllData();
    }
  }
  //描画処理
  //相手（クライアント）の描画
  fill(100,0,0);
  rect(cx,cy,5,5);
  //自分（サーバ）の描画
  fill(0,0,100);
  rect(sx,sy,5,5);
}

//マウスクリックがクリックされたら
void mouseClicked(){
  sx = mouseX;
  sy = mouseY;
  //全てのデータの送信
  sendAllData();
}

//現在の状況をすべてのクライアントに送信
void sendAllData(){
  //サーバに送信するメッセージを作成
  //空白で区切り末尾は改行
  String msg = sx + " " + sy + " " + cx + " " + cy + '\n';
  print("server: " + msg);
  //サーバが接続しているすべてのクライアントに送信
  //(複数のクライアントが接続している場合は全てのクライアントに送信)
  server.write(msg);
}

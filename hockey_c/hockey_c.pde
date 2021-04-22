//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Client client;
//ボールの座標
int x, y;
//ボールの方向
int dirX, dirY;
//サーバのアドレス
//127.0.0.1はローカルマシン
//他のマシンに接続するときは適切に変更
String serverAdder = "127.0.0.1";
//ポート番号を指定（今回は20000）
int port = 20000;

//初期化
void setup() {
  //指定されたアドレスとポートでサーバに接続
  client = new Client(this, serverAdder, port);
  x = 0;
  y = 0;
  dirX = 1;
  dirY = 1;
  size(400, 400);
  colorMode(HSB, 100);
  noStroke();
  ellipseMode(RADIUS);
}

void draw() {
  //自分（クライアント）の描画
  fill(100,10);
  rect(0, 0, 400, 400);
  noStroke();
  fill(60,60,80);
  ellipse(x,y,10,10);
}

//サーバーからデータを受け取るたびに呼び出される関数
void clientEvent(Client c) {
  //サーバからのデータ取得
  String msg = c.readStringUntil('\n');
  //メッセージが存在する場合
  if (msg != null) {
    //改行を取り除き，空白で分割して配列に格納
    String[] data = splitTokens(msg);
    //サーバ側のx座標
    x = int(data[0]); //int()で文字列から整数に変換
    //サーバ側のy座標
    y = int(data[1]);
    //クライアント側のx座標
    dirX = int(data[2]);
    //クライアント側のy座標
    dirY = int(data[3]);
  }
}

/*
//マウスがクリックされたら
void mouseClicked() {
  //クライアント側の座標として登録
  int x = mouseX;
  int y = mouseY;
  //サーバに送るメッセージを作成
  //空白で区切り，末尾に改行を付与
  String msg = x + " " + y + "\n";
  print("clicked: " + msg);
  //クライアントが接続しているメッセージをサーバに送信
  client.write(msg);
  //ここで，直接cx, cyに代入せずに，サーバにデータを送ることが重要
}
*/

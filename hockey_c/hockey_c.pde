//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Client client;
//ボールの座標
float x, y;
//ボールの方向
int dirX, dirY;
//サーバ側バーの位置
float bar1X, bar1Y;
//クライアント側バーの位置
float bar2X, bar2Y;
//キー入力検出
int my_keycode;
int dirBar;
boolean keyPress;

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
}

void draw() {
  //サーバbarの描画
  rect(bar1X, bar1Y, 10, 50);
  //クライアントbarの描画
  rect(bar2X, bar2Y, 10, 50);
  
  //自分（クライアント）の描画
  fill(100,10);
  rect(0, 0, 600, 400);
  noStroke();
  fill(60,60,80);
  ellipse(x,y,5,5);
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
    x = float(data[0]); //int()で文字列から整数に変換
    //サーバ側のy座標
    y = float(data[1]);
    //クライアント側のx座標
    dirX = int(data[2]);
    //クライアント側のy座標
    dirY = int(data[3]);
    //サーバ側のバーX座標
    bar1X = float(data[4]);
    //サーバ側のバーY座標
    bar1Y = float(data[5]);
    //クライアント側のバーX座標
    bar2X = float(data[6]);
    //サーバ側のバーY座標
    bar2Y = float(data[7]);
    
  }
}

//キーが入力されたら
void keyPressed() {
  keyPress = true;
  if (key == CODED) {
    //上入力
    if(keyCode == RIGHT) {
      my_keycode = RIGHT; 
      dirBar = -1;
    }
    //下入力
    if (keyCode == LEFT) {
      my_keycode = LEFT;
      dirBar = 1;
    }
    String msg = my_keycode + " " + dirBar + " " + keyPress + "\n";
    client.write(msg);
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

// Accountクラス(アカウントの設計図)を生成

class Shop {
  // フィールド（変数）を定義　＝＞　属性どんなもの？
  String id;
  String name;
  String logoImage;
  List<String>? shopImage;
  List<String> staff;

//メソッドの定
//コンストラクタの生成
//クラスの時点で、詳細な情報を初期化しておくのはよくない、ので、初期化なしで定義したい！
//けれど何も定義してない状態では使えない、
//コンストラクタ＝何もわかっていないあやふやな状態を定義しつつ、インスタンス化したい！（インスタンス化しつつ値を入れる！）

  Shop({
    this.id = '',
    this.name = '',
    this.logoImage = '',
    this.shopImage,
    required this.staff,
  });
}

// Accountクラス(アカウントの設計図)を生成
import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  // フィールド（変数）を定義　＝＞　属性どんなもの？
  String id;
  String name;
  String imagepath;
  String selfIntroduction;
  String userId;
  String follow;
  String follower;
  bool is_stylist;
  Timestamp? createdTime;
  Timestamp? updatedTime;
//メソッドの定
//コンストラクタの生成
//クラスの時点で、詳細な情報を初期化しておくのはよくない、ので、初期化なしで定義したい！
//けれど何も定義してない状態では使えない、
//コンストラクタ＝何もわかっていないあやふやな状態を定義しつつ、インスタンス化したい！（インスタンス化しつつ値を入れる！）

  Account(
      {this.id = '',
      this.name = '',
      this.imagepath = '',
      this.selfIntroduction = '',
      this.userId = '',
      this.follow = '',
      this.follower = '',
      this.is_stylist = false,
      this.createdTime,
      this.updatedTime});
}

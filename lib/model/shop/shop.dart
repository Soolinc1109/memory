class Shop {
  String id;
  String name;
  String shopIntroduction;
  String logoImage;
  int shopPhone;
  List<String>? shopImage;
  List<String>? snsUrl;
  List<String> staff;

  Shop({
    this.id = '',
    this.name = '',
    this.shopPhone = 1,
    this.shopIntroduction = '',
    this.logoImage = '',
    this.shopImage,
    this.snsUrl,
    required this.staff,
  });
}

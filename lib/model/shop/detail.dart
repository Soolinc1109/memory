class CarteDetail {
  String id;
  String before_after_post_id;
  String memo;
  String menu_id;
  String post_stylist_id;
  DateTime created_at;

  CarteDetail({
    this.id = '',
    required this.before_after_post_id,
    required this.memo,
    required this.menu_id,
    required this.post_stylist_id,
    required this.created_at,
  });
}

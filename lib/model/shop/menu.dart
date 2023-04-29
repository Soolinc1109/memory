import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String id;
  String description;
  int duration;
  int price;
  String menu_image;
  String name;
  List<String>? stylist_ids;

  Menu({
    this.id = '',
    required this.description,
    required this.duration,
    required this.price,
    required this.menu_image,
    required this.name,
    this.stylist_ids,
  });

  factory Menu.fromDocument(DocumentSnapshot doc) {
    return Menu(
      id: doc.id,
      description: doc['description'],
      duration: doc['duration'],
      price: doc['price'],
      menu_image: doc['menu_image'],
      name: doc['name'],
      stylist_ids: List<String>.from(doc['stylist_ids'] ?? []),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance.collection("Shop");

class Shop {
  String name;
  String detail;
  int price;
  String image;
  
  Shop({
    required this.name,
    required this.detail,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'detail': detail,
      'price': price,
      'image': image,
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      name: map['name'] as String,
      detail: map['detail'] as String,
      price: map['price'] as int,
      image: map['image'] as String,
    );
  }

  static Future<List<Shop>> getShop() async {
    try {
      List<Shop> shopList = [];
      final shopMap = await firestore.get();
      for (var doc in shopMap.docs) {
        shopList.add(Shop.fromMap(doc.data()));
      }
      return shopList;
    } catch (e) {
      print("ERROR getShop: ${e.toString()}");
      return [];
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final String email;
  final String name;
  bool typeuser;

  UserData({
    required this.userId,
    required this.email,
    required this.name,
    required this.typeuser,
  });

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      userId: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      typeuser: data['typeuser'] ?? false,
    );
  }
}

class ItemData {
  final String docId;
  final String itemCode;
  final String location;
  final String item_category;

  ItemData({
    required this.docId,
    required this.itemCode,
    required this.location,
    required this.item_category,
  });

  factory ItemData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemData(
      docId: doc.id,
      itemCode: data['Code'] ?? '',
      location: data['Location'] ?? '',
      item_category: data['item_category'] ?? '',
    );
  }
}

class ComplaintData {
  final String docId;
  final String title;
  final String productId;
  final String description;
  final String date;
  final String status;

  ComplaintData({
    required this.docId,
    required this.title,
    required this.productId,
    required this.description,
    required this.date,
    required this.status,
  });

  factory ComplaintData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ComplaintData(
      docId: doc.id,
      title: data['Damaged product']?? '',
      productId: data['789012']?? '',
      description: data['The product arrived damaged.']?? '',
      date: data['2022-03-10']?? '',
      status: data['Closed']?? '',
    );
  }
}
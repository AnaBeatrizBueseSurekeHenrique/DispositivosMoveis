import 'package:apk_trabalho3/model/flower_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FlowerService {
  final CollectionReference flores = FirebaseFirestore.instance.collection(
    'flores',
  );
  Future<void> create(Flower flower) {
    return flores.add({
      'color': flower.color,
      'meaning': flower.meaning,
      'name': flower.name,
      'picture': flower.picture,
      'price': flower.price,
      'scientificName': flower.scientificName,
      'type': flower.type,
      'userId': flower.userId,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> read() {
    final florStream = flores
        .orderBy('timestamp', descending: true)
        .snapshots();
    return florStream;
  }

  Stream<QuerySnapshot> readByAlphabeticalOrderAZ() {
    final florStream = flores.orderBy('name', descending: false).snapshots();
    return florStream;
  }

  Stream<QuerySnapshot> readByAlphabeticalOrderZA() {
    final florStream = flores.orderBy('name', descending: true).snapshots();
    return florStream;
  }

  Stream<QuerySnapshot> readByDescendingPrice() {
    final florStream = flores.orderBy('price', descending: true).snapshots();
    return florStream;
  }

  Stream<QuerySnapshot> readByAscendingPrice() {
    final florStream = flores.orderBy('price', descending: false).snapshots();
    return florStream;
  }

  Future<void> update(Flower flower) {
    return flores.doc(flower.id).update({
      'color': flower.color,
      'meaning': flower.meaning,
      'name': flower.name,
      'picture': flower.picture,
      'price': flower.price,
      'scientificName': flower.scientificName,
      'type': flower.type,
      'userId': flower.userId,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> delete(String docId) {
    return flores.doc(docId).delete();
  }

  Stream<QuerySnapshot> filterByMyUser(String userId) {
    return flores.where('userId', isEqualTo: userId).snapshots();
  }
}

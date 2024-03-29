import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/objects/PollCategory.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance
  ..useFirestoreEmulator('localhost', 8080);

final categoryStream = StreamProvider.autoDispose<List<PollCategory>>(
  (ref) {
    return _firebaseFirestore.collection('categories').snapshots().map(
        (querySnap) =>
            querySnap.docs.map((doc) => PollCategory.fromDb(doc)).toList());
  },
);

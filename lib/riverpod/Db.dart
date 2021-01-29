import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/objects/PollCategory.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance
  ..settings = Settings(
    host: kIsWeb ? 'localhost:8081' : '10.0.2.2:8081',
    sslEnabled: false,
    persistenceEnabled: false,
  ));

final categoryStream = StreamProvider.autoDispose<List<PollCategory>>(
  (ref) {
    return ref
        .watch(firebaseFirestoreProvider)
        .collection('categories')
        .snapshots()
        .map((querySnap) =>
            querySnap.docs.map((doc) => PollCategory.fromDb(doc)).toList());
  },
);

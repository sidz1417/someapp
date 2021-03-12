import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/objects/PollCategory.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance
  ..settings = Settings(
    host: (defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2:8080'
        : 'localhost:8080'),
    sslEnabled: false,
    persistenceEnabled: false,
  );

final categoryStream = StreamProvider.autoDispose<List<PollCategory>>(
  (ref) {
    return _firebaseFirestore.collection('categories').snapshots().map(
        (querySnap) =>
            querySnap.docs.map((doc) => PollCategory.fromDb(doc)).toList());
  },
);

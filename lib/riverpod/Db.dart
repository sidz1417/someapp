import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:someapp/objects/PollCategory.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance
  ..settings = Settings(
    host: kIsWeb ? 'localhost:8081' : '10.0.2.2:8081',
    sslEnabled: false,
    persistenceEnabled: false,
  );

FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance
  ..useFunctionsEmulator(origin: 'http://localhost:5001');

final categoryStream = StreamProvider.autoDispose<List<PollCategory>>(
  (ref) {
    return _firebaseFirestore.collection('categories').snapshots().map(
        (querySnap) =>
            querySnap.docs.map((doc) => PollCategory.fromDb(doc)).toList());
  },
);

void upVote({@required String pollName, @required BuildContext context}) async {
  try {
    await _firebaseFunctions
        .httpsCallable('upVote')
        .call(<String, dynamic>{'categoryName': pollName}).timeout(
            Duration(seconds: 10));
  } on FirebaseFunctionsException catch (e) {
    print('cloud function error : ${e.message}');
  } on TimeoutException catch (e) {
    print('Timed out , function exceeded ${e.duration.inSeconds} seconds');
  }
}

void createCategory(
    {@required String pollName, @required BuildContext context}) async {
  try {
    await _firebaseFunctions
        .httpsCallable('createCategory')
        .call(<String, dynamic>{'categoryName': pollName}).timeout(
            Duration(seconds: 10));
  } on FirebaseFunctionsException catch (e) {
    print('cloud function error : ${e.message}');
  } on TimeoutException catch (e) {
    print('Timed out , function exceeded ${e.duration.inSeconds} seconds');
  }
}

void removeCategory(
    {@required String pollName, @required BuildContext context}) async {
  try {
    await _firebaseFunctions
        .httpsCallable('removeCategory')
        .call(<String, dynamic>{'categoryName': pollName}).timeout(
            Duration(seconds: 10));
  } on FirebaseFunctionsException catch (e) {
    print('cloud function error : ${e.message}');
  } on TimeoutException catch (e) {
    print('Timed out , function exceeded ${e.duration.inSeconds} seconds');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:someapp/objects/PollCategory.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance
  ..settings = Settings(
    host: kIsWeb ? 'localhost:8080' : '10.0.2.2:8080',
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

void upVote({@required String pollName, @required BuildContext context}) async {
  final categoryDocRef = _firebaseFirestore.doc('categories/$pollName');
  await _firebaseFirestore.runTransaction(
    (transaction) async {
      try {
        final categoryDoc = await transaction.get(categoryDocRef);
        transaction
            .update(categoryDocRef, {'count': categoryDoc.data()['count'] + 1});
      } catch (e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
          ),
        );
      }
    },
  );
}

void addCategory(
    {@required String pollName, @required BuildContext context}) async {
  final categoryDocRef = _firebaseFirestore.doc('categories/$pollName');
  await _firebaseFirestore.runTransaction(
    (transaction) async {
      try {
        transaction.set(categoryDocRef, {'count': 0});
      } catch (e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
          ),
        );
      }
    },
  );
}

void removeCategory(
    {@required String pollName, @required BuildContext context}) async {
  final categoryDocRef = _firebaseFirestore.doc('categories/$pollName');
  await _firebaseFirestore.runTransaction(
    (transaction) async {
      try {
        transaction.delete(categoryDocRef);
      } catch (e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
          ),
        );
      }
    },
  );
}

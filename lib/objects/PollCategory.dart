import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PollCategory {
  final String pollName;
  final int voteCount;

  PollCategory({@required this.pollName, @required this.voteCount});

  factory PollCategory.fromDb(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();
    return PollCategory(
        pollName: documentSnapshot.id, voteCount: data['count']);
  }
}

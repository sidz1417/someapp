import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        .httpsCallable('upVote',
            options: HttpsCallableOptions(timeout: Duration(seconds: 5)))
        .call(<String, dynamic>{'categoryName': pollName});
  } on FirebaseFunctionsException catch (e) {
    print('cloud function error : ${e.message}');
  } on TimeoutException catch (e) {
    print('Timed out , function exceeded ${e.duration.inSeconds} seconds');
  }
}

enum ModMode { CREATE, REMOVE, NONE }

final modModeProvider = StateProvider((ref) => ModMode.NONE);
final modTrigger = StateProvider((ref) => false);
final pollNameProvider = StateProvider((ref) => '');
final modFutureProvider = FutureProvider.family<void, BuildContext>(
  (ref, context) async {
    final modMode = ref.watch(modModeProvider).state;
    final pollName = ref.watch(pollNameProvider).state;
    try {
      switch (modMode) {
        case ModMode.CREATE:
          return await _firebaseFunctions
              .httpsCallable('createCategory',
                  options: HttpsCallableOptions(timeout: Duration(seconds: 5)))
              .call(<String, dynamic>{'categoryName': pollName});
        case ModMode.REMOVE:
          return await _firebaseFunctions
              .httpsCallable(
            'removeCategory',
            options: HttpsCallableOptions(timeout: Duration(seconds: 5)),
          )
              .call(<String, dynamic>{'categoryName': pollName});
        case ModMode.NONE:
          // TODO: Handle this case.
          break;
      }
    } on FirebaseFunctionsException catch (e) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('${e.message}')));
    } catch (e) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Exception $e occurred')));
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.watch(modModeProvider).state = ModMode.NONE;
        ref.watch(pollNameProvider).state = '';
        ref.watch(modTrigger).state = false;
      });
    }
  },
);

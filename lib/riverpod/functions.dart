import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance
  ..useFunctionsEmulator('localhost', 5001);

upVote({required String pollName}) async {
  try {
    await _firebaseFunctions
        .httpsCallable(
      'upVote',
    )
        .call(<String, dynamic>{'categoryName': pollName});
  } on FirebaseFunctionsException catch (e) {
    return e;
  }
}

enum ModMode { CREATE, REMOVE }

final modModeProvider = StateProvider<ModMode>((ref) => ModMode.CREATE);
final modTrigger = StateProvider<bool>((ref) => false);
final pollNameProvider = StateProvider<String>((ref) => '');

final modFutureProvider =
    FutureProvider.autoDispose.family<dynamic, BuildContext>(
  (ref, context) async {
    final modMode = ref.watch(modModeProvider.notifier).state;
    final pollName = ref.watch(pollNameProvider.notifier).state;
    try {
      switch (modMode) {
        case ModMode.CREATE:
          return await _firebaseFunctions
              .httpsCallable(
            'createCategory',
          )
              .call(<String, dynamic>{'categoryName': pollName});
        case ModMode.REMOVE:
          return await _firebaseFunctions
              .httpsCallable(
            'removeCategory',
          )
              .call(<String, dynamic>{'categoryName': pollName});
      }
    } on FirebaseFunctionsException catch (e) {
      if (ref.watch(modTrigger.notifier).state)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.message}')));
    } finally {
      ref.watch(modTrigger.notifier).state = false;
    }
  },
);

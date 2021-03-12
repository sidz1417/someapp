import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance
  ..useFunctionsEmulator(origin: 'http://localhost:5001');

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

final modModeProvider = StateProvider((ref) => ModMode.CREATE);
final modTrigger = StateProvider((ref) => false);
final pollNameProvider = StateProvider((ref) => '');

final modFutureProvider = FutureProvider.autoDispose<dynamic>(
  (ref) async {
    final modMode = ref.read(modModeProvider).state;
    final pollName = ref.read(pollNameProvider).state;
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
      return e;
    } finally {
      ref.read(modTrigger).state = false;
    }
  },
);

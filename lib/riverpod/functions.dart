import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFunctionsProvider = Provider(
  (ref) => FirebaseFunctions.instance
    ..useFunctionsEmulator(origin: 'http://localhost:5001'),
);

void upVote({@required String pollName}) async {
  final container = ProviderContainer();
  final _firebaseFunctions = container.read(firebaseFunctionsProvider);
  try {
    await _firebaseFunctions
        .httpsCallable('upVote')
        .call(<String, dynamic>{'categoryName': pollName});
  } catch (e) {
    return e;
  }
}

enum ModMode { CREATE, REMOVE }

final modModeProvider = StateProvider((ref) => ModMode.CREATE);
final modTrigger = StateProvider((ref) => false);
final pollNameProvider = StateProvider((ref) => '');
final modFutureProvider = FutureProvider.autoDispose<void>(
  (ref) async {
    final modMode = ref.read(modModeProvider).state;
    final pollName = ref.read(pollNameProvider).state;
    try {
      switch (modMode) {
        case ModMode.CREATE:
          return await ref
              .watch(firebaseFunctionsProvider)
              .httpsCallable('createCategory')
              .call(<String, dynamic>{'categoryName': pollName});
        case ModMode.REMOVE:
          return await ref
              .watch(firebaseFunctionsProvider)
              .httpsCallable('removeCategory')
              .call(<String, dynamic>{'categoryName': pollName});
      }
    } catch (e) {
      return e;
    }
  },
);

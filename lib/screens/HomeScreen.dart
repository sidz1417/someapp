import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/riverpod/Auth.dart';
import 'package:someapp/riverpod/Db.dart';
import 'package:someapp/riverpod/functions.dart';
import 'package:someapp/utils/AboutDialogButton.dart';
import 'package:someapp/utils/SignOutButton.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        centerTitle: true,
        leading: AboutDialogButton(),
        actions: [
          SignOutButton(),
        ],
      ),
      body: Stack(children: [
        Positioned.fill(
          child: CategoryList(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Consumer(
                builder: (context, ref, _) {
                  // final triggered = ref.watch(modTrigger.state).state;
                  // if (triggered)
                  //   ref.listen(modFutureProvider.future,
                  //       (previous, Future<dynamic> modFuture) async {
                  //     final returnVal = await modFuture;
                  //     if (returnVal is FirebaseFunctionsException) {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(content: Text('${returnVal.message}')));
                  //     }
                  //   });
                  // return ModeratorButtons();
                  if (ref.watch(modTrigger.state).state)
                    ref.watch(modFutureProvider(context));
                  return ModeratorButtons();
                },
              )),
        )
      ]),
    );
  }
}

class ModeratorButtons extends StatelessWidget {
  const ModeratorButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((_, ref, __) => ref.watch(isModeratorProvider).when(
            data: (isModerator) => isModerator
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [AddCategoryButton(), RemoveCategoryButton()],
                  )
                : Container(),
            loading: () => Container(),
            error: (_, __) => Container(),
          )),
    );
  }
}

class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text('Add category'),
      // icon: Icon(Icons.add),
      onPressed: () => showDialog(
        context: context,
        builder: (context) {
          final _textEditingController = TextEditingController();
          return AlertDialog(
            title: Text('Add category'),
            content: TextField(
              key: Key('AddCategoryText'),
              controller: _textEditingController,
              decoration: InputDecoration(hintText: 'Enter new category name'),
            ),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Consumer(
                  builder: (_, ref, __) => ElevatedButton(
                        child: Text('Add'),
                        onPressed: () {
                          ref.watch(pollNameProvider.notifier).state =
                              _textEditingController.text;
                          ref.watch(modModeProvider.notifier).state =
                              ModMode.CREATE;
                          ref.watch(modTrigger.notifier).state = true;
                          Navigator.of(context).pop();
                        },
                      )),
            ],
          );
        },
      ),
    );
  }
}

class RemoveCategoryButton extends StatelessWidget {
  const RemoveCategoryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text('Remove category'),
      // tooltip: 'Remove category',
      onPressed: () => showDialog(
        context: context,
        builder: (context) {
          final _textEditingController = TextEditingController();
          return AlertDialog(
            title: Text('Remove category'),
            content: TextField(
              key: Key('RemoveCategoryText'),
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter the category name to remove'),
            ),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Consumer(
                  builder: (_, ref, __) => ElevatedButton(
                        child: Text('Remove'),
                        onPressed: () {
                          ref.watch(pollNameProvider.notifier).state =
                              _textEditingController.text;
                          ref.watch(modModeProvider.notifier).state =
                              ModMode.REMOVE;
                          ref.watch(modTrigger.notifier).state = true;
                          Navigator.of(context).pop();
                        },
                      )),
            ],
          );
        },
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((_, ref, __) => ref.watch(categoryStream).when(
            data: (categoryList) => ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (_, index) => CategoryItem(
                pollName: categoryList[index].pollName,
                voteCount: categoryList[index].voteCount,
              ),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error getting data : $e'),
          )),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final pollName;
  final voteCount;

  const CategoryItem({
    Key? key,
    required this.pollName,
    required this.voteCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          upVote(pollName: pollName);
        },
        title: Center(child: Text(pollName)),
        trailing: Text('$voteCount'),
      ),
    );
  }
}

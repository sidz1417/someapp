import 'package:cloud_functions/cloud_functions.dart';
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
      body: Stack(
        children: [
          Positioned.fill(
            child: CategoryList(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Consumer(
                  builder: (context, watch, _) {
                    return watch(modTrigger).state
                        ? ProviderListener(
                            provider: modFutureProvider.future,
                            onChange: (BuildContext context,
                                Future<dynamic> modFuture) async {
                              final returnVal = await modFuture;
                              if (returnVal is FirebaseFunctionsException) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('${returnVal.message}')));
                              }
                            },
                            child: watch(modFutureProvider).maybeWhen(
                              orElse: () => ModeratorButtons(),
                            ),
                          )
                        : ModeratorButtons();
                  },
                )),
          )
        ],
      ),
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
      builder: ((_, watch, __) => watch(isModeratorProvider).when(
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
              controller: _textEditingController,
              decoration: InputDecoration(hintText: 'Enter new category name'),
            ),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  context.read(pollNameProvider).state =
                      _textEditingController.text;
                  context.read(modModeProvider).state = ModMode.CREATE;
                  context.read(modTrigger).state = true;
                  Navigator.of(context).pop();
                },
              ),
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
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter the category name to remove'),
            ),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text('Remove'),
                onPressed: () {
                  context.read(pollNameProvider).state =
                      _textEditingController.text;
                  context.read(modModeProvider).state = ModMode.REMOVE;
                  context.read(modTrigger).state = true;
                  Navigator.of(context).pop();
                },
              ),
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
      builder: ((_, watch, __) => watch(categoryStream).when(
            data: (categoryList) => ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (_, index) => Card(
                child: ListTile(
                  onTap: () {
                    upVote(pollName: categoryList[index].pollName);
                  },
                  title: Center(child: Text(categoryList[index].pollName)),
                  trailing: Text('${categoryList[index].voteCount}'),
                ),
              ),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error getting data : $e'),
          )),
    );
  }
}

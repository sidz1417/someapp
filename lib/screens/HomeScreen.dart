import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/riverpod/Auth.dart';
import 'package:someapp/riverpod/db.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CategoryList(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ModeratorButtons(),
        )
      ],
    );
  }
}

class ModeratorButtons extends StatelessWidget {
  const ModeratorButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) => watch(isModeratorProvider).when(
        data: (isModerator) => isModerator
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [AddCategoryButton(), RemoveCategoryButton()],
              )
            : Container(),
        loading: () => Container(),
        error: (_, __) => Container(),
      ),
    );
  }
}

class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Add a category',
      child: Icon(Icons.add),
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
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              RaisedButton(
                child: Text('Add'),
                onPressed: () {
                  createCategory(
                      pollName: _textEditingController.text, context: context);
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
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Remove category',
      child: Icon(Icons.remove),
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
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              RaisedButton(
                child: Text('Remove'),
                onPressed: () {
                  removeCategory(
                      pollName: _textEditingController.text, context: context);
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
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) => watch(categoryStream).when(
        data: (categoryList) => ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (_, index) => Card(
            child: ListTile(
              onTap: () => {
                upVote(pollName: categoryList[index].pollName, context: context)
              },
              title: Center(child: Text(categoryList[index].pollName)),
              trailing: Text('${categoryList[index].voteCount}'),
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error getting data : $e'),
      ),
    );
  }
}

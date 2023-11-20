import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/content_screen.dart';
import '../Models/to_do_item.dart';
import '../Providers/item_provider.dart';
import '../l10n/app_localizations.dart';

class ToDoItemWidget extends StatefulWidget {
  final ToDoItem item;
  final bool editMode;
  final int index;
  final Function checkItem;
  final Function deleteItem;
  final Function updateSingleListScreen;

  ToDoItemWidget(this.item, this.editMode, this.index, this.checkItem,
      this.deleteItem, this.updateSingleListScreen,
      {Key? key})
      : super(key: key);

  @override
  _ToDoItemWidgetState createState() => _ToDoItemWidgetState();
}

class _ToDoItemWidgetState extends State<ToDoItemWidget> {
  Future<bool?> confirmDismiss(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            "Confirm Deletion",
            // Replace with your localization logic
          ),
          content: Text(
            "Are you sure you want to delete this item?",
            // Replace with your localization logic
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                // Replace with your localization logic
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 55,
      duration: const Duration(milliseconds: 100),
      // decoration: BoxDecoration(),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          widget.deleteItem(widget.item.id, widget.item.done, context);
        },
        confirmDismiss: (DismissDirection direction) async {
          return await confirmDismiss(context);
        },
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              ContentScreen.routeName,
              arguments: {
                'id': widget.item.id,
                'updateSingleListScreen': widget.updateSingleListScreen,
              },
            );
          },
          leading: widget.editMode
              ? Icon(
                  Icons.drag_handle,
                  color: Theme.of(context).hintColor,
                )
              : SizedBox(
                  width: 10,
                ),
          title: Text(
            widget.item.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: Checkbox(
            // activeColor: Color(0xFF945985),
            value: widget.item.done,
            onChanged: widget.editMode
                ? null
                : (value) {
                    setState(() {
                      widget.checkItem(
                          widget.item.id, widget.item.listId, widget.item.done);
                    });
                  },
          ),
        ),
      ),
    );
  }
}

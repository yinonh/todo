import 'dart:async';
import 'package:flutter/material.dart';

import '../Providers/lists_provider.dart';
import '../Models/to_do_list.dart';
import '../Widgets/to_do_item_tile.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ToDoList>> existingItems;
  ListsProvider provider = ListsProvider();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _onItemTapped(0);
  }

  void deleteItem(ToDoList item) {
    setState(() {
      print("remove ${item}");
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0)
        existingItems = provider.getActiveItems();
      else
        existingItems = provider.getAchievedItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        unselectedIconTheme: IconThemeData(
          size: 20,
          color: Color(0xFF636995),
        ),
        backgroundColor: Color(0xFF18122B),
        //Color(0xFF635985),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.fact_check,
              ),
              label: 'Active'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive,
              ),
              label: 'Archived'),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF635985), Color(0xFF18122B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        TextEditingController? new_title;
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter list title'),
                              content: TextFormField(
                                  controller: new_title,
                                  maxLength: 30,
                                  decoration:
                                      InputDecoration(hintText: "Title")),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Color(0xFF636995)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const Text(
                      'To-Do',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _selectedIndex == 0 ? 'Active Items' : 'Archived Items',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: FutureBuilder<List<ToDoList>>(
                  future: existingItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    } else if (snapshot.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                      return Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ToDoItemTile(
                              item: snapshot.data![index],
                              onDelete: deleteItem,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

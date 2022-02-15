import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/config/colors.dart';
import 'package:todo/screens/complete.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _userTask;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        // appBar: AppBar(
        //     shadowColor: const Color.fromARGB(255, 255, 255, 255),
        //     backgroundColor: backgroundColor,
        //     centerTitle: true,
        //     title: const Text(
        //       'To do list',
        //       style: TextStyle(color: textColor, fontSize: 24),
        //     )),
        body: Column(children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: (() {
                  Navigator.of(context).pushNamed('/complete');
                }),
                child: const Complete()),
          ),
          Expanded(
            flex: 3,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('items').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('No tasks');
                  }
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 10, left: 7, right: 7),
                          child: Dismissible(
                            key: Key(snapshot.data!.docs[index].id),
                            child: Container(
                              height: 120,
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(159, 130, 130, 130),
                                  blurRadius: 10.0,
                                  spreadRadius: 3,
                                  offset: Offset(1.0, 3.5),
                                )
                              ]),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: secondaryColor,
                                child: ListTile(
                                  title: Text(
                                    snapshot.data!.docs[index].get('task'),
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 22,
                                    ),
                                  ),
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Update your task'),
                                            content: TextField(
                                              onChanged: (String value) {
                                                _userTask = value;
                                              },
                                            ),
                                            actions: [
                                              MaterialButton(
                                                  color: primaryColor,
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('items')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .update({
                                                      'task': _userTask
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Update',
                                                    style: TextStyle(
                                                        color: secondaryColor),
                                                  ))
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(snapshot.data!.docs[index].id)
                                    .delete();
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(snapshot.data!.docs[index].id)
                                    .delete();
                                FirebaseFirestore.instance
                                    .collection('completeTask')
                                    .add({
                                  'ct': snapshot.data!.docs[index].get('task')
                                });
                              }
                            },
                            background: Container(
                              margin: const EdgeInsets.all(8),
                              height: 80,
                              color: const Color.fromARGB(255, 98, 240, 105),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 25, left: 8),
                                child: Text('Complete',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            secondaryBackground: Container(
                              margin: const EdgeInsets.all(8),
                              height: 80,
                              color: const Color.fromARGB(255, 255, 0, 0),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 25, right: 8),
                                child: Text('Delete',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 56, 136, 255),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add your task'),
                    content: TextField(
                      onChanged: (String value) {
                        _userTask = value;
                      },
                    ),
                    actions: [
                      MaterialButton(
                          color: const Color.fromARGB(255, 56, 136, 255),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('items')
                                .add({'task': _userTask});
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(color: secondaryColor),
                          ))
                    ],
                  );
                });
          },
          child: const Icon(Icons.add, color: secondaryColor),
        ),
      ),
    );
  }
}

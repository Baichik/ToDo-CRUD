import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/config/colors.dart';

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
        appBar: AppBar(
            shadowColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: backgroundColor,
            centerTitle: true,
            title: const Text(
              'To do list',
              style: TextStyle(color: textColor, fontSize: 24),
            )),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('items').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('No tasks');
              } else {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 7, right: 7),
                        child: Dismissible(
                          key: Key(snapshot.data!.docs[index].id),
                          child: SizedBox(
                            height: 90,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: secondaryColor,
                              child: ListTile(
                                title: Text(
                                  snapshot.data!.docs[index].get('task'),
                                  style: const TextStyle(color: textColor),
                                ),
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Update your task'),
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
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .update(
                                                          {'task': _userTask});
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
                            }
                          },
                          background: Container(
                              margin: const EdgeInsets.all(8),
                              height: 80,
                              color: const Color.fromARGB(255, 98, 240, 105)),
                          secondaryBackground: Container(
                              margin: const EdgeInsets.all(8),
                              height: 80,
                              color: const Color.fromARGB(255, 255, 0, 0)),
                        ),
                      );
                    });
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
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
                          color: primaryColor,
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

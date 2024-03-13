import 'package:crud/demo.dart';
import 'package:crud/insert_form.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return InsertForm(null);
                  },
                )).then((value) {
                  setState(() {});
                });
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Demo().copyPasteAssetFileToRoot(),
        builder: (context, snapshotCopy) {
          if (snapshotCopy.hasData) {
            return FutureBuilder(
              future: Demo().getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                          color: Colors.yellow,
                          padding: EdgeInsets.only(left: 10),
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Text(snapshot.data![index]['userName'])),
                              IconButton(
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return InsertForm(
                                            snapshot.data![index]);
                                      },
                                    )).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.grey.shade400,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    bool deleteConfirmation = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Deletion Confirmation'),
                                          content: Text(
                                              'Are you sure you want to delete user?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: Text('Delete'))
                                          ],
                                        );
                                      },
                                    );
                                    if(deleteConfirmation != null && deleteConfirmation) {
                                      await Demo()
                                          .deleteUser(
                                          snapshot.data![index]['userId'])
                                          .then((value) {
                                        setState(() {});
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ));
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return Center(
              child: Text('Copying...'),
            );
          }
        },
      ),
    );
  }
}

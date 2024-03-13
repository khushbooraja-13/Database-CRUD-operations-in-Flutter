import 'package:crud/demo.dart';
import 'package:flutter/material.dart';

class InsertForm extends StatefulWidget {
  Map<String, dynamic>? map;
  InsertForm(Map<String, dynamic>? map) {
    this.map = map;
  }

  @override
  State<InsertForm> createState() => _InsertFormState();
}

class _InsertFormState extends State<InsertForm> {
  TextEditingController myController = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if(widget.map!=null) {
      myController.text = widget.map!['userName'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert User'),
      ),
      body: Form(
        key: _key,
        child: Column(
          children: [
            Text('Enter username'),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: myController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter username';
                }
              },
              decoration: InputDecoration(
                  hintText: 'abc',
                  labelText: 'Enter username: ',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: () async {
              if(_key.currentState!.validate()) {
                if(widget.map==null) {
                  insertRecord().then((value) {
                    Navigator.of(context).pop(true);
                  });
                }else{
                  await updateRecord().then((value){
                    Navigator.of(context).pop(true);
                  });
                }
              }
            }, child: Text('Submit'))
          ],
        ),
      ),
    );
  }

  Future<void> insertRecord() async {
    Map<String, dynamic> map = {};
    map['userName'] = myController.text.toString();
    await Demo().insertUser(map);
  }

  Future<void> updateRecord() async {
    Map<String, dynamic> map = {};
    map['userId'] = widget.map!['userId'];
    map['userName'] = myController.text.toString();
    await Demo().updateUser(map);
  }
}

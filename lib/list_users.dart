import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sqlite/utils/connection.dart';
import 'package:flutter_sqlite/form_edit_user.dart';

class ListUsers extends StatefulWidget {
  List users;
  var onChange;
  ListUsers({Key key, this.users, this.onChange}): super(key:key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {

  @override
  Widget build(BuildContext context) {
    List _users = widget.users;

    return Expanded(
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return Slidable(
            delegate: SlidableBehindDelegate(),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(_users[index]['name']),
                subtitle: Text(_users[index]['email']),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Editar',
                color: Colors.blue,
                icon: Icons.edit,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Editando usuário'),
                        content: FormEditUser(initialData: _users[index], onChange: () {
                          widget.onChange();
                        }),
                      );
                    }
                  );
                },
              ),
              IconSlideAction(
                caption: 'Remove',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  SqliteDB.connect()
                    .then((database) {
                      return database.rawDelete(
                        'DELETE FROM users WHERE id=?',
                        [_users[index]['id']]
                      );
                    })
                    .then((data) {
                      widget.onChange();
                    });
                },
              )
            ],
          );
        },
      ),
    );
  }
}
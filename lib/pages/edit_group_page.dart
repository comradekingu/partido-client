import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:partido_client/model/group.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';

import '../api/api.dart';
import '../api/api_service.dart';
import '../app_state.dart';

class EditGroupPage extends StatefulWidget {

  final Group group;

  EditGroupPage({Key key, @required this.group}) : super(key: key);

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  var logger = Logger(printer: PrettyPrinter());

  Api api = ApiService.getApi();

  final _formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  String _currency;
  bool _joinModeActive;
  String _joinKey;

  TextEditingController groupNameController = new TextEditingController();
  TextEditingController groupDescriptionController = new TextEditingController();
  TextEditingController groupCurrencyController = new TextEditingController();

  @override
  void initState() {
    groupNameController.text = widget.group.name;
    groupDescriptionController.text = widget.group.status;
    groupCurrencyController.text = widget.group.currency;
    _joinModeActive = widget.group.joinModeActive;
    _joinKey = widget.group.joinKey;
    return super.initState();
  }

  void _updateGroup() async {
    Group updatedGroup = new Group(name: _name, status: _description, currency: _currency, joinModeActive: _joinModeActive, joinKey: _joinKey);
    try {
      HttpResponse<Group> response = await api.updateGroup(widget.group.id, updatedGroup);
      if (response.response.statusCode == 200) {
        Provider.of<AppState>(context, listen: false).refreshAppState();
        navService.goBack();
        Fluttertoast.showToast(msg: "Group settings saved");
      }
    } catch (e) {
      logger.e('Saving group settings failed', e);
      Fluttertoast.showToast(msg: "Saving group settings failed");
    }
  }

  void _onJoinModeActiveChanged(bool newValue) => setState(() {
    _joinModeActive = newValue;
    if (_joinModeActive) {
      // Do not add @. This character is used as separator in the combined joinKey (key@groupId)
      const chars = "ABCD?EFGH!JKLMNP_/QRSTUVWX+*YZabcdefghkmn'§pqrstuv%wxyz12345()6789";
      Random rnd = new Random.secure();
      String result = "";
      for (var i = 0; i < 15; i++) {
        result += chars[rnd.nextInt(chars.length)];
      }
      print(result);
      _joinKey = result;
    }
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Group settings'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: groupNameController,
                    onSaved: (value) => _name = value,
                    decoration: InputDecoration(labelText: "Group name"),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      if (value.length > 255) {
                        return 'Max. 255 characters allowed';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: groupDescriptionController,
                    onSaved: (value) => _description = value,
                    decoration: InputDecoration(labelText: "Description (optional)"),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value.length > 255) {
                        return 'Max. 255 characters allowed';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: groupCurrencyController,
                    onSaved: (value) => _currency = value,
                    decoration: InputDecoration(labelText: "Currency"),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a currency';
                      }
                      if (value.length > 255) {
                        return 'Max. 255 characters allowed';
                      }
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Let other users join the group with a key"),
                    value: _joinModeActive,
                    onChanged: _onJoinModeActiveChanged,
                    //controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 15.0),
                  MaterialButton(
                      minWidth: double.infinity,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("Save changes"),
                      onPressed: () {
                        final form = _formKey.currentState;
                        form.save();
                        if (form.validate()) {
                          _updateGroup();
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

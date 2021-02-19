import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const InputText({this.inputControl, this.hint, this.label});

  final TextEditingController inputControl;
  final String hint, label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        controller: inputControl,
        decoration: InputDecoration(hintText: hint, labelText: label),
      ),
    );
  }
}

class MyLoginTypeButton extends StatelessWidget {
  const MyLoginTypeButton({this.onPressed, @required this.label});
  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(15),
        child: Text(label),
        color: Colors.orange,
      ),
    );
  }
}

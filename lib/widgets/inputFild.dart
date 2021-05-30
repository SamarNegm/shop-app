import 'package:flutter/material.dart';

class MyInputFild extends StatelessWidget {
  final text;
  final initialValue;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final int maxLines;
  final void Function(String) onFieldSubmitted;
  final Function(String) validator;
  final Function(String) onSaved;
  const MyInputFild(
      {Key key,
      this.text,
      this.initialValue,
      this.textInputAction,
      this.keyboardType,
      this.focusNode,
      this.onFieldSubmitted,
      this.validator,
      this.onSaved,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      elevation: 4,
      shadowColor: Colors.black,
      color: Color(0xffF4F4F4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          maxLines: maxLines,
          initialValue: initialValue,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          onSaved: onSaved,
          decoration: InputDecoration(
            counterStyle: TextStyle(fontSize: 20, color: Color(0xff707070)),
            labelText: text,
            fillColor: Color(0xffF4F4F4),
            // border: OutlineInputBorder(
            //     borderRadius:
            //         BorderRadius.all(Radius.circular(30)
            //         )
            // )
          ),
        ),
      ),
    );
  }
}

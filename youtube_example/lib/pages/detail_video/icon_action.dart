import 'package:flutter/material.dart';
class IconAction extends StatelessWidget {
  IconAction({this.icon,this.message});
  final IconData icon;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 25,
        ),
        SizedBox(height: 5,),
        Text(
          message,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

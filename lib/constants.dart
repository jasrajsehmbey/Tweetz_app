import 'package:flutter/material.dart';

const kTextFieldDecorations = InputDecoration(
  hintText: 'Whats up?...',
  hintStyle: TextStyle(
    color: Colors.black54,
    fontSize: 20.00,
  ),
  border: InputBorder.none,
);

BoxDecoration kBoxDecorations = BoxDecoration(
  border: Border.all(color: Colors.black12),
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(20.00),
    topLeft: Radius.circular(20.00),
  ),
);

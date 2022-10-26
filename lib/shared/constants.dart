import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  // fillColor: Colors.white,
  filled: false,
  hintStyle: TextStyle(color: Color(0xff8D99AE)),
  labelStyle: TextStyle(color: Color(0xff8D99AE)),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffD90429), width: 2.0),
    borderRadius: BorderRadius.circular(7.0),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff8D99AE), width: 2.0),
    borderRadius: BorderRadius.circular(7.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xfff94144), width: 2.0),
    borderRadius: BorderRadius.circular(7.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xfffb5607), width: 2.0),
    borderRadius: BorderRadius.circular(7.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xfff94144), width: 2.0),
    borderRadius: BorderRadius.circular(7.0),
  ),
);

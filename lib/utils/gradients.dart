import 'package:flutter/material.dart';

class AppGradients{
  static Gradient MessengerStyle = const LinearGradient(
    colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ); //xanh bien

  static Gradient InstagramStyle = const LinearGradient(
    colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ); //Tim hong

  static Gradient WhatAppStyle = const LinearGradient(
    colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ); //Xanh la nhe

  static Gradient TechnoStyle = const LinearGradient(
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static Gradient DarkPurpleStyle = const LinearGradient(
    colors: [Color(0xFF434343), Color(0xFF000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
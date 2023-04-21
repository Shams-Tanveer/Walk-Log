import 'package:flutter/material.dart';

class SetLimitModel{
  double maxValue;
  bool errorInSetLimit;
  String errorInSetLimitText;
  TextEditingController maxController = TextEditingController();

  SetLimitModel({
    required this.maxValue,
    required this.errorInSetLimit,
    required this.errorInSetLimitText
  });
}
import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/styles.dart';

class CustTextfield extends StatelessWidget {
  CustTextfield(
      {Key? key, required this.controller, required this.hint, this.validator})
      : super(key: key);
  TextEditingController controller;
  String hint;
  String? Function(String?)? validator;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: kWhite,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                spreadRadius: -2,
                offset: Offset(0, 2),
                color: kBlack),
          ],
          borderRadius: BorderRadius.circular(7)),
      child: TextFormField(
        key: _formKey,
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            hintText: hint,
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kRed,
                  width: 2,
                )),
            focusedBorder: InputBorder.none,
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kRed,
                  width: 2,
                )),
            errorStyle: TextStyle(color: kRed)),
        validator: validator,
        style: TextStyle(color: kBlack),
      ),
    );
  }
}

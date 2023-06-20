import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/widget/cust_textfield.dart';

class CustForm extends StatelessWidget {
  CustForm({Key? key, required this.formKey, required this.controller})
      : super(key: key);
  GlobalKey<FormState> formKey;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: formKey,
          child: CustTextfield(
            controller: controller,
            hint: "latitud,  longitud",
            validator: (string) {
              if (string?.isEmpty ?? true) {
                return 'Please enter a location';
              }

              final pattern = r'^\s*-?\d+(?:\.\d+)?,\s*-?\d+(?:\.\d+)?\s*$';
              final regex = RegExp(pattern);

              if (!regex.hasMatch(string!)) {
                return 'El formato de lat logn es incorrecto.\nex:14.523, -15.681';
              }

              return null;
            },
          ),
        )
      ],
    );
  }
}

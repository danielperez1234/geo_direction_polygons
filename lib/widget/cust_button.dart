import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/styles.dart';

class CustButton extends StatelessWidget {
  CustButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  Function() onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 40,
      decoration: BoxDecoration(
        color: kPrincipal,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 2,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: Colors.transparent,
        elevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w700, color: kWhite),
          ),
        ),
      ),
    );
  }
}

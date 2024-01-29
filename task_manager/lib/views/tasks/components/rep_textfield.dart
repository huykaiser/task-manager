import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_str.dart';

class RepTextField extends StatelessWidget {
  const RepTextField({
    super.key,
    required this.controller,
    this.isForDescription = false,
    required this.onFieldSubmitted,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final bool isForDescription;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListTile(
          title: TextFormField(
            controller: controller,
            maxLines: isForDescription ? null : 6,
            cursorHeight: isForDescription ? null : 60,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: isForDescription ? InputBorder.none : null,
              counter: Container(),
              hintText: isForDescription ? AppStr.addNote : null,
              prefixIcon: isForDescription
                  ? const Icon(Icons.bookmark_border, color: Colors.grey)
                  : null,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
            ),
            onFieldSubmitted: onFieldSubmitted,
            onChanged: onChanged,
          ),
        ));
  }
}

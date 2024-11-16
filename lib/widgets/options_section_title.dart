import 'package:flutter/widgets.dart';

Container optionsSectionTitle(String title) {
  return Container(
    color: const Color.fromARGB(255, 187, 222, 251),
    child: Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
    ),
  );
}

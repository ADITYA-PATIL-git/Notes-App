import 'package:flutter/material.dart';

class NoteSettings extends StatelessWidget {
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;

  const NoteSettings(
      {super.key, required this.onEditTap, required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //edit
        GestureDetector(
          onTap: onEditTap,
          child: Container(
            height: 50,
            color: Colors.white,
            child: const Center(
                child: Text(
              'Edit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),

        //delete
        GestureDetector(
          onTap: onDeleteTap,
          child: Container(
            height: 50,
            color: Colors.white,
            child: const Center(
                child: Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ],
    );
  }
}

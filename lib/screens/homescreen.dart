import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/note_settings.dart';

import 'package:notes_app/services/firestore.dart';
import 'package:popover/popover.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();
  //text controller
  final TextEditingController textController = TextEditingController();

  // Open a dialog box to add a note
  void openNoteBox({String? docID, String? currentText}) {
    if (currentText != null) {
      textController.text = currentText;
    } else {
      textController.clear();
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //button to save
          ElevatedButton(
            onPressed: () {
              // add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              // update existing note
              else {
                firestoreService.updateNote(docID, textController.text);
              }

              // clear the text controller
              textController.clear();

              // close the box
              Navigator.pop(context);
            },
            child: const Text('add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: openNoteBox,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // if the snapshot have data, get all the docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // display as a list tile
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: const Color.fromARGB(159, 0, 0, 0)),
                  ),
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 25,
                    right: 25,
                  ),
                  child: ListTile(
                      title: Text(noteText),
                      trailing: Builder(builder: (context) {
                        return IconButton(
                          onPressed: () => showPopover(
                            width: 100,
                            height: 100,
                            context: context,
                            bodyBuilder: (context) => NoteSettings(
                              onEditTap: () {
                                Navigator.pop(context);
                                openNoteBox(
                                  docID: docID,
                                  currentText: noteText,
                                );
                              },
                              onDeleteTap: () {
                                Navigator.pop(context);
                                firestoreService.deleteNote(docID);
                              },
                            ),
                          ),
                          icon: const Icon(Icons.more_vert),
                        );
                      })),
                );
              },
            );
          }

          // if there is no data return nothing
          else {
            return const Text('No notes');
          }
        },
      ),
    );
  }
}

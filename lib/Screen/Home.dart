import 'package:flutter/material.dart';
import '../Model/Note.dart';
import '../Database/Db.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Db _db;
  List<Note>? _notes = <Note>[];

  AppBar appbar = AppBar(
      title: const Text(
    "Notes",
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  ));

  @override
  initState() {
    //database
    _db = Db.db;
    //get all notes
    Future.delayed(Duration.zero, () async {
      setState(() {
        asyncMethod();
      });
    });
    super.initState();
  }

  asyncMethod() async {
    _notes = await _db.gettAll();
  }

  _showDialog(int id) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Remove',
          contentText: 'Do you want to remove ?',
          negativeText: "Cancel",
          positiveText: "Remove",
          positiveTextStyle: TextStyle(color: Colors.red),
          onPositiveClick: () async {
            await _db.deleteById(id);
            Future.delayed(Duration.zero, () async {
              setState(() {
                asyncMethod();
              });
              Navigator.of(context).pop();
            });
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      setState(() {
        asyncMethod();
      });
    });
    return Scaffold(
      appBar: appbar,
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.black87),
        width: double.infinity,
        height: MediaQuery.of(context).size.height -
            appbar.preferredSize.height -
            MediaQuery.of(context).viewPadding.top,
        child: GridView.builder(
            itemCount: _notes!.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                // childAspectRatio: 5 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (ctx, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed("/add", arguments: _notes![index]);
                },
                onLongPress: () async {
                  if (await Vibration.hasVibrator()) {
                    Vibration.vibrate();
                  }
                  _showDialog(_notes![index].id);
                },
                child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 5),
                          child: Text(
                            _notes![index].title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: .3),
                          ),
                        ),
                        Flexible(
                            child: Text(
                          _notes![index].note,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        )),
                      ],
                    )),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(3)),
          onPressed: () {
            Navigator.of(context).pushNamed("/add").then((value) {
              Future.delayed(Duration.zero, () async {
                setState(() {
                  asyncMethod();
                });
              });
            });
          },
          child: const Icon(
            Icons.add_box_rounded,
            size: 40,
          )),
    );
  }
}

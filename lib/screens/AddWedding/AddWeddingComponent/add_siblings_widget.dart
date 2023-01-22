import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';

addSiblingDialog(BuildContext context, List<String> sibling) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    context: context,
    builder: (ctx) {
      return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: AddSiblingDialogue(sibling: sibling));
    },
  );
}

class AddSiblingDialogue extends StatefulWidget {
  AddSiblingDialogue({required this.sibling, Key? key}) : super(key: key);
  List<String> sibling;
  @override
  State<AddSiblingDialogue> createState() => _AddSiblingDialogueState();
}

class _AddSiblingDialogueState extends State<AddSiblingDialogue> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  addSibling() {
    if (nameController.text.trim() != '') {
      widget.sibling.add(nameController.text);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Enter Name ');
    }
  }
  // _updateUser() {
  //   Provider.of<UserProvider>(context, listen: false)
  //       .updateUser(
  //           formData:
  //               FormData.fromMap({"guest_name": textEditingController.text}))
  //       .then((value) {
  //     if (value.success) {
  //       Provider.of<UserProvider>(context, listen: false)
  //           .getUserData(mobileNo: sharedPrefs.mobileNo);
  //       Fluttertoast.showToast(msg: "User Update Success");
  //       if (Navigator.canPop(context)) {
  //         Navigator.pop(context);
  //       }
  //     } else {
  //       Fluttertoast.showToast(msg: "Fail to Update Details");
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 25, left: 25, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 4),
            child: AutoSizeText("Add Sibling",
                style: gilroyBold.copyWith(fontSize: 22)),
          ),
          AutoSizeText(
            " Name",
            style: gilroyLight,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 25),
            child: TextFormField(
              cursorColor: grey,
              controller: nameController,
              // initialValue: Provider.of<UserProvider>(context).user?.guestName,
              textInputAction: TextInputAction.next,
              style: gilroyNormal.copyWith(fontSize: 14),

              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                //hintStyle: gilroyBold.copyWith(fontSize: 15),
                hintText: "Enter Sibling's Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 0,
                    color: white,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              addSibling();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xfff3686d),
                      Color(0xffed2831),
                    ]),
              ),
              height: 45,
              child: AutoSizeText(
                "Add",
                style: gilroyBold.copyWith(fontSize: 18, color: white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

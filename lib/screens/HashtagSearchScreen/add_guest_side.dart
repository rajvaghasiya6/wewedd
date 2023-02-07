import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/hashtag_search_provider.dart';
import '../HomeScreen/home_screen.dart';

class AddGuestSideDialog extends StatefulWidget {
  const AddGuestSideDialog({required this.marriageId, Key? key})
      : super(key: key);
  final marriageId;

  @override
  State<AddGuestSideDialog> createState() => _AddGuestSideDialogState();
}

class _AddGuestSideDialogState extends State<AddGuestSideDialog> {
  String guestside = "groom_side";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Are you from ?",
              style: gilroyNormal.copyWith(fontSize: 18, letterSpacing: 0.5)),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              RadioListTile(
                activeColor: Colors.red,
                title: const Text("Bride Side"),
                value: "bride_side",
                groupValue: guestside,
                onChanged: (value) {
                  setState(() {
                    guestside = value.toString();
                  });
                },
              ),
              RadioListTile(
                activeColor: Colors.red,
                title: const Text("Groom Side"),
                value: "groom_side",
                groupValue: guestside,
                onChanged: (value) {
                  setState(() {
                    guestside = value.toString();
                  });
                },
              ),
            ],
          )
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Provider.of<HashtagSearchProvider>(context, listen: false)
                .addGuestSide(
                    marriage_id: widget.marriageId,
                    guest_side: guestside,
                    mobile_no: sharedPrefs.mobileNo)
                .then((value) {
              print(value);
              if (value.success == true) {
                nextScreenReplace(context, HomeScreen());
              } else {
                Fluttertoast.showToast(msg: "Something Went Wrong");
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xfff3686d),
                    Color(0xffed2831),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Ok',
                      textAlign: TextAlign.center,
                      style: poppinsBold.copyWith(
                        color: white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

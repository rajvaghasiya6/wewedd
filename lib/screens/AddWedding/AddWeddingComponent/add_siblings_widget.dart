import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';
import '../add_wedding_screen.dart';

addSiblingDialog(BuildContext context, List<SidePerson> sibling) {
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
  List<SidePerson> sibling;
  @override
  State<AddSiblingDialogue> createState() => _AddSiblingDialogueState();
}

class _AddSiblingDialogueState extends State<AddSiblingDialogue> {
  TextEditingController nameController = TextEditingController();
  File? personImage;
  @override
  void initState() {
    super.initState();
  }

  addSibling() {
    if (nameController.text.trim() != '' && personImage != null) {
      widget.sibling.add(
          SidePerson(name: nameController.text.trim(), image: personImage));
      Navigator.pop(context);
    } else if (personImage == null) {
      Fluttertoast.showToast(msg: 'Upload image');
    } else {
      Fluttertoast.showToast(msg: 'Enter Name ');
    }
  }

  Future<File?> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: personImage!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.white,
          backgroundColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          hideBottomControls: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        iosUiSettings: const IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      personImage = croppedFile;
    }
    return croppedFile;
  }

  Future<File?> getFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

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
          InkWell(
            onTap: () async {
              personImage = await getFromGallery();
              if (personImage != null) {
                personImage = await _cropImage();
              }

              if (personImage == null) {
                Fluttertoast.showToast(msg: "failed to pick image");
              } else {
                setState(() {
                  personImage;
                });
              }
            },
            child: personImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(personImage!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: timeGrey,
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: poppinsNormal.copyWith(
                            color: eventGrey,
                            fontSize: 35,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            height: 10,
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

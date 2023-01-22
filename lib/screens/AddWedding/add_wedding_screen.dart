import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../general/color_constants.dart';
import '../../general/text_styles.dart';
import '../../widgets/mytextformfield.dart';
import 'AddWeddingComponent/add_siblings_widget.dart';

class AddWeddingScreen extends StatefulWidget {
  const AddWeddingScreen({Key? key}) : super(key: key);

  @override
  State<AddWeddingScreen> createState() => _AddWeddingScreenState();
}

class _AddWeddingScreenState extends State<AddWeddingScreen> {
  TextEditingController hashtagController = TextEditingController();

  TextEditingController brideNameController = TextEditingController();

  TextEditingController brideFatherNameController = TextEditingController();

  TextEditingController brideMotherNameController = TextEditingController();

  TextEditingController groomNameController = TextEditingController();

  TextEditingController groomFatherNameController = TextEditingController();

  TextEditingController groomMotherNameController = TextEditingController();

  List<String> brideSibling = [];

  List<String> groomSibling = [];

  File? pickedImage;
  Future<File?> _cropImage(bool isFirst) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedImage!.path,
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
      pickedImage = croppedFile;
    }
    return croppedFile;
  }

  Future<File?> getFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> getFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  void imagePick() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: carouselBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            pickedImage = await getFromGallery();
                            if (pickedImage != null) {
                              pickedImage = await _cropImage(true);
                            }

                            if (pickedImage == null) {
                              Fluttertoast.showToast(
                                  msg: "failed to pick image");
                            } else {
                              setState(() {
                                pickedImage;
                              });
                            }

                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: timeGrey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.image),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Choose from",
                                        softWrap: true,
                                        style: poppinsNormal.copyWith(
                                            color: white, fontSize: 14),
                                      ),
                                      Text(
                                        "gallery",
                                        softWrap: true,
                                        style: poppinsNormal.copyWith(
                                            color: white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            pickedImage = await getFromCamera();
                            if (pickedImage != null) {
                              pickedImage = await _cropImage(true);
                            }
                            if (pickedImage == null) {
                              Fluttertoast.showToast(
                                  msg: "failed to pick image");
                            } else {
                              setState(() {
                                pickedImage;
                              });
                            }

                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: timeGrey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.camera_alt_outlined),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Take  a",
                                        style: poppinsNormal.copyWith(
                                            color: white, fontSize: 14),
                                      ),
                                      Text(
                                        "Photo ",
                                        style: poppinsNormal.copyWith(
                                            color: white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: lightBlack)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Text(
                                "Cancel",
                                style: poppinsNormal.copyWith(
                                    color: lightBlack, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      imagePick();
                    },
                    child: pickedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(pickedImage!.path),
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
                                    color: white, fontSize: 50),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "upload logo",
                    style: poppinsNormal.copyWith(color: white, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: scaffoldBlack,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 74, 69, 75),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(-2, -2)),
                    BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(3, 3)),
                  ],
                ),
                child: TextFormField(
                  controller: hashtagController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (val) {
                    if (val == '') {
                      return 'Please Enter HashTag';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "#Enter your HASH tag",
                    hintStyle:
                        poppinsNormal.copyWith(color: grey, fontSize: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextFormField(
                hintText: "Enter Bride's Name",
                lable: "Bride's Name",
                controller: brideNameController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (phone) {
                  if (phone!.isEmpty) {
                    return "Please Enter Bride's Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextFormField(
                hintText: "Enter Bride's Father Name",
                lable: "Bride's Father Name",
                controller: brideFatherNameController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (phone) {
                  if (phone!.isEmpty) {
                    return "Please Enter Bride's Father Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextFormField(
                hintText: "Enter Bride's Mother Name",
                lable: "Bride's Name",
                controller: brideMotherNameController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (phone) {
                  if (phone!.isEmpty) {
                    return "Please Enter Bride's Mother Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  addSiblingDialog(context, brideSibling);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: grey)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            "  + Add Bride's Sibling",
                            style: poppinsNormal.copyWith(
                                color: grey, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              brideSibling.isNotEmpty
                  ? const SizedBox(
                      height: 15,
                    )
                  : const SizedBox(),
              brideSibling.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: brideSibling.length,
                      itemBuilder: ((context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: timeGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        brideSibling[index],
                                        style: poppinsNormal.copyWith(
                                            color: white, fontSize: 15),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          brideSibling.removeAt(index);
                                          setState(() {
                                            brideSibling;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      separatorBuilder: ((context, index) {
                        return const SizedBox(
                          height: 15,
                        );
                      }),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 30,
              ),
              MyTextFormField(
                hintText: "Enter Groom's Name",
                lable: "Groom's Name",
                controller: brideNameController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (phone) {
                  if (phone!.isEmpty) {
                    return "Please Enter Groom's Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextFormField(
                hintText: "Enter Groom's Father Name",
                lable: "Groom's Father Name",
                controller: groomFatherNameController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (phone) {
                  if (phone!.isEmpty) {
                    return "Please Enter Groom's Father Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextFormField(
                hintText: "Enter Groom's Mother Name",
                lable: "Groom's Mother Name",
                controller: groomMotherNameController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (phone) {
                  if (phone!.isEmpty) {
                    return "Please Enter Groom's Mother Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  addSiblingDialog(context, groomSibling);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: grey)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            "  + Add Groom's Sibling",
                            style: poppinsNormal.copyWith(
                                color: grey, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              brideSibling.isNotEmpty
                  ? const SizedBox(
                      height: 15,
                    )
                  : const SizedBox(),
              brideSibling.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: groomSibling.length,
                      itemBuilder: ((context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: timeGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        groomSibling[index],
                                        style: poppinsNormal.copyWith(
                                            color: white, fontSize: 15),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          groomSibling.removeAt(index);
                                          setState(() {
                                            groomSibling;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      separatorBuilder: ((context, index) {
                        return const SizedBox(
                          height: 15,
                        );
                      }),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      )),
    ));
  }
}
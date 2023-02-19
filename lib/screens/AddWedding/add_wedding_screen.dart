import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/add_wedding_provider.dart';
import '../../widgets/mytextformfield.dart';
import 'AddWeddingComponent/add_new_event_widget.dart';
import 'AddWeddingComponent/add_siblings_widget.dart';
import 'AddWeddingComponent/upload_image_list.dart';

class AddWeddingScreen extends StatefulWidget {
  const AddWeddingScreen({Key? key}) : super(key: key);

  @override
  State<AddWeddingScreen> createState() => _AddWeddingScreenState();
}

class _AddWeddingScreenState extends State<AddWeddingScreen> {
  TextEditingController hashtagController = TextEditingController();

  TextEditingController weddingNameController = TextEditingController();

  TextEditingController brideNameController = TextEditingController();

  TextEditingController brideFatherNameController = TextEditingController();

  TextEditingController brideMotherNameController = TextEditingController();

  TextEditingController groomNameController = TextEditingController();

  TextEditingController groomFatherNameController = TextEditingController();

  TextEditingController groomMotherNameController = TextEditingController();

  TextEditingController weddingDateController = TextEditingController();

  TextEditingController weddingVenueController = TextEditingController();

  TextEditingController liveLinkController = TextEditingController();

  TextEditingController weddingTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<SidePerson> brideSibling = [];
  List<SidePerson> brideRelative = [];

  List<SidePerson> groomSibling = [];
  List<SidePerson> groomRelative = [];

  List<AddEventModel> events = [];

  File? pickedImage;
  File? brideImage;
  File? brideFatherImage;
  File? brideMotherImage;

  File? groomImage;
  File? groomFatherImage;
  File? groomMotherImage;

  List<File> inviteImage = [];
  List<File> coupleImage = [];

  bool isAccess = true;
  bool isIdProof = true;
  bool isUploadFeed = true;

  void addWeddingPress() async {
    final isValid = _formKey.currentState!.validate();
    if (pickedImage == null) {
      Fluttertoast.showToast(msg: 'Upload wedding logo ');
    } else if (brideImage == null) {
      Fluttertoast.showToast(msg: "Upload Bride photo");
    } else if (brideFatherImage == null) {
      Fluttertoast.showToast(msg: "Upload Bride father photo");
    } else if (brideMotherImage == null) {
      Fluttertoast.showToast(msg: "Upload Bride mother photo");
    } else if (groomImage == null) {
      Fluttertoast.showToast(msg: "Upload Groom photo");
    } else if (groomFatherImage == null) {
      Fluttertoast.showToast(msg: "Upload Groom father photo");
    } else if (groomMotherImage == null) {
      Fluttertoast.showToast(msg: "Upload Groom mother photo");
    } else if (inviteImage.isEmpty) {
      Fluttertoast.showToast(msg: "Upload Invitation Card photo");
    } else if (coupleImage.length < 5) {
      Fluttertoast.showToast(msg: "Upload Minimum 5 couple photo");
    } else {
     if (isValid) {
     if (_formKey.currentState!.validate()) {
    FormData data = FormData.fromMap({
      'mobile_number': sharedPrefs.mobileNo,
      'marriage_name': weddingNameController.text.trim(),
      'wedding_date': DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd-MM-yyyy').parse(weddingDateController.text))
          .toString(),
      'wedding_hashtag': hashtagController.text.trim(),
      'wedding_time': weddingTimeController.text.trim(),
      'wedding_venue': weddingVenueController.text.trim(),
      'is_guests_id_proof': isIdProof.toString(),
      'is_approve_post': isUploadFeed.toString(),
      'is_private': isAccess.toString(),
      'bride_name': brideNameController.text.trim(),
      'groom_name': groomNameController.text.trim(),
      'live_link': liveLinkController.text.trim(),
      'groom_side_length':
          (groomRelative.length + groomSibling.length + 2).toString(),
      'bride_side_length':
          (brideRelative.length + brideSibling.length + 2).toString(),
      'groom_side0.name': groomFatherNameController.text,
      'groom_side0.relation': 'father',
      'groom_side1.name': groomMotherNameController.text,
      'groom_side1.relation': 'mother',
      'bride_side0.name': brideFatherNameController.text,
      'bride_side0.relation': 'father',
      'bride_side1.name': brideMotherNameController.text,
      'bride_side1.relation': 'mother',
      'events_length': events.length.toString(),
    });
    for (var i = 0; i < brideSibling.length; i++) {
      data.fields.addAll([
        MapEntry("bride_side${i + 2}.name", brideSibling[i].name),
        MapEntry("bride_side${i + 2}.relation", "sibling"),
      ]);
    }
    for (var i = 0; i < brideRelative.length; i++) {
      data.fields.addAll([
        MapEntry("bride_side${i + brideSibling.length + 2}.name",
            brideRelative[i].name),
        MapEntry(
            "bride_side${i + brideSibling.length + 2}.relation", "relative"),
      ]);
    }
    for (var i = 0; i < groomSibling.length; i++) {
      data.fields.addAll([
        MapEntry("groom_side${i + 2}.name", groomSibling[i].name),
        MapEntry("groom_side${i + 2}.relation", "sibling"),
      ]);
    }
    for (var i = 0; i < groomRelative.length; i++) {
      data.fields.addAll([
        MapEntry("groom_side${i + groomSibling.length + 2}.name",
            groomRelative[i].name),
        MapEntry(
            "groom_side${i + groomSibling.length + 2}.relation", "relative"),
      ]);
    }
    for (var i = 0; i < brideSibling.length; i++) {
      if (pickedImage != null) {
        data.files.add(MapEntry(
          "bride_side${i + 2}.image",
          await MultipartFile.fromFile(brideSibling[i].image!.path),
        ));
      }
    }
    for (var i = 0; i < brideRelative.length; i++) {
      if (pickedImage != null) {
        data.files.add(MapEntry(
          "bride_side${i + brideSibling.length + 2}.image",
          await MultipartFile.fromFile(brideRelative[i].image!.path),
        ));
      }
    }
    for (var i = 0; i < groomSibling.length; i++) {
      if (pickedImage != null) {
        data.files.add(MapEntry(
          "groom_side${i + 2}.image",
          await MultipartFile.fromFile(groomSibling[i].image!.path),
        ));
      }
    }
    for (var i = 0; i < groomRelative.length; i++) {
      if (pickedImage != null) {
        data.files.add(MapEntry(
          "groom_side${i + groomSibling.length + 2}.image",
          await MultipartFile.fromFile(groomRelative[i].image!.path),
        ));
      }
    }
    if (pickedImage != null) {
      data.files.add(
        MapEntry(
          "marriage_logo",
          await MultipartFile.fromFile(pickedImage!.path),
        ),
      );
    }
    if (groomImage != null) {
      data.files.add(
        MapEntry(
          "groom_image",
          await MultipartFile.fromFile(groomImage!.path),
        ),
      );
    }
    if (brideImage != null) {
      data.files.add(
        MapEntry(
          "bride_image",
          await MultipartFile.fromFile(brideImage!.path),
        ),
      );
    }
    if (groomFatherImage != null) {
      data.files.add(
        MapEntry(
          "groom_side0.image",
          await MultipartFile.fromFile(groomFatherImage!.path),
        ),
      );
    }
    if (groomMotherImage != null) {
      data.files.add(
        MapEntry(
          "groom_side1.image",
          await MultipartFile.fromFile(groomMotherImage!.path),
        ),
      );
    }
    if (brideFatherImage != null) {
      data.files.add(
        MapEntry(
          "bride_side0.image",
          await MultipartFile.fromFile(brideFatherImage!.path),
        ),
      );
    }
    if (brideMotherImage != null) {
      data.files.add(
        MapEntry(
          "bride_side1.image",
          await MultipartFile.fromFile(brideMotherImage!.path),
        ),
      );
    }

    for (var file in inviteImage) {
      data.files.addAll([
        MapEntry("invitation_card", await MultipartFile.fromFile(file.path)),
      ]);
    }
    for (var file in coupleImage) {
      data.files.addAll([
        MapEntry("banner", await MultipartFile.fromFile(file.path)),
      ]);
    }

    for (var i = 0; i < events.length; i++) {
      data.fields.addAll([
        MapEntry("event$i.event_name", events[i].eventName),
        MapEntry("event$i.event_tagline", events[i].eventTagline),
        MapEntry("event$i.event_date", events[i].eventDate),
        MapEntry("event$i.event_time", events[i].eventTime),
        MapEntry("event$i.is_dress_code", events[i].isDresscode.toString()),
        MapEntry("event$i.event_venue", events[i].eventVenue),
        MapEntry("event$i.dress_code_men", events[i].menDresscode),
        MapEntry("event$i.dress_code_women", events[i].womenDresscode),
      ]);
    }
    for (var i = 0; i < events.length; i++) {
      if (events[i].eventLogo != null) {
        data.files.add(
          MapEntry("event$i.logo",
              await MultipartFile.fromFile(events[i].eventLogo!.path)),
        );
      }
    }

    log(data.fields.toString());
    log(data.files.toString());
    Provider.of<AddWeddingProvider>(context, listen: false)
        .addNewWedding(formData: data)
        .then((value) {
      print(value.message);
      if (value.success) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Wedding added successfully");
      }
    });
      }
    }
      }
  }

  Future<File?> _cropImage(File? image) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: image!.path,
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
      image = croppedFile;
    }
    return image;
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
  Widget build(BuildContext context) {
    var isloading = Provider.of<AddWeddingProvider>(context).isLoading;

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
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var image = await getFromGallery();
                        if (image != null) {
                          pickedImage = await _cropImage(image);
                        }

                        if (pickedImage == null) {
                          Fluttertoast.showToast(msg: "failed to pick image");
                        } else {
                          setState(() {
                            pickedImage;
                          });
                        }
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
                    Text(
                      "upload logo",
                      style: poppinsNormal.copyWith(color: white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Your #Hashtag",
                  lable: "Hashtag",
                  controller: hashtagController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Hashtag";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Your Wedding name",
                  lable: "Wedding Name",
                  controller: weddingNameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Your Wedding name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Bride name",
                  lable: "bride Name",
                  controller: brideNameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Bride name";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      var image = await getFromGallery();
                      if (image != null) {
                        brideImage = await _cropImage(image);
                      }

                      if (brideImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        setState(() {
                          brideImage;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 3, bottom: 3, right: 15.0),
                      child: Container(
                        height: 40,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightBlack,
                        ),
                        child: Center(
                          child: brideImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(brideImage!.path),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  "+",
                                  style: poppinsBold.copyWith(
                                      color: white, fontSize: 22),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Bride's Father Name",
                  lable: "Bride's Father Name",
                  controller: brideFatherNameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Bride's Father Namee";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      var image = await getFromGallery();
                      if (image != null) {
                        brideFatherImage = await _cropImage(image);
                      }

                      if (brideFatherImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        setState(() {
                          brideFatherImage;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 3, bottom: 3, right: 15.0),
                      child: Container(
                        height: 40,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightBlack,
                        ),
                        child: Center(
                          child: brideFatherImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(brideFatherImage!.path),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  "+",
                                  style: poppinsBold.copyWith(
                                      color: white, fontSize: 22),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Bride's Mother Name",
                  lable: "Bride's Mother Name",
                  controller: brideMotherNameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Bride's Mother Namee";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      var image = await getFromGallery();
                      if (image != null) {
                        brideMotherImage = await _cropImage(image);
                      }

                      if (brideMotherImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        setState(() {
                          brideMotherImage;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 3, bottom: 3, right: 15.0),
                      child: Container(
                        height: 40,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightBlack,
                        ),
                        child: Center(
                          child: brideMotherImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(brideMotherImage!.path),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  "+",
                                  style: poppinsBold.copyWith(
                                      color: white, fontSize: 22),
                                ),
                        ),
                      ),
                    ),
                  ),
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
                              border: Border.all(color: grey, width: 0.5)),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          brideSibling[index].name,
                                          style: poppinsNormal.copyWith(
                                              color: white, fontSize: 15),
                                        ),
                                        const Spacer(),
                                        const SizedBox(
                                          width: 10,
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
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: lightBlack,
                                          ),
                                          child: Center(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(brideSibling[index]
                                                  .image!
                                                  .path),
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                        ),
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
                GestureDetector(
                  onTap: () {
                    addSiblingDialog(context, brideRelative);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: grey, width: 0.5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Text(
                              "  + Add Bride's Relative",
                              style: poppinsNormal.copyWith(
                                  color: grey, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                brideRelative.isNotEmpty
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(),
                brideRelative.isNotEmpty
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: brideRelative.length,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          brideRelative[index].name,
                                          style: poppinsNormal.copyWith(
                                              color: white, fontSize: 15),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            brideRelative.removeAt(index);
                                            setState(() {
                                              brideRelative;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: lightBlack,
                                          ),
                                          child: Center(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(brideRelative[index]
                                                  .image!
                                                  .path),
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                        ),
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
                  hintText: "Enter Groom name",
                  lable: "Groom Name",
                  controller: groomNameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Groom name";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      var image = await getFromGallery();
                      if (image != null) {
                        groomImage = await _cropImage(image);
                      }

                      if (groomImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        setState(() {
                          groomImage;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 3, bottom: 3, right: 15.0),
                      child: Container(
                        height: 40,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightBlack,
                        ),
                        child: Center(
                          child: groomImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(groomImage!.path),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  "+",
                                  style: poppinsBold.copyWith(
                                      color: white, fontSize: 22),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Groom's Father Name",
                  lable: "Groom's Father Name",
                  controller: groomFatherNameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Groom's Father Namee";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      var image = await getFromGallery();
                      if (image != null) {
                        groomFatherImage = await _cropImage(image);
                      }

                      if (groomFatherImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        setState(() {
                          groomFatherImage;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 3, bottom: 3, right: 15.0),
                      child: Container(
                        height: 40,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightBlack,
                        ),
                        child: Center(
                          child: groomFatherImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(groomFatherImage!.path),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  "+",
                                  style: poppinsBold.copyWith(
                                      color: white, fontSize: 22),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Groom's Mother Name",
                  lable: "Groom's Mother Name",
                  controller: groomMotherNameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Groom's Mother Namee";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      var image = await getFromGallery();
                      if (image != null) {
                        groomMotherImage = await _cropImage(image);
                      }

                      if (groomMotherImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        setState(() {
                          groomMotherImage;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 3, bottom: 3, right: 15.0),
                      child: Container(
                        height: 40,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightBlack,
                        ),
                        child: Center(
                          child: groomMotherImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(groomMotherImage!.path),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  "+",
                                  style: poppinsBold.copyWith(
                                      color: white, fontSize: 22),
                                ),
                        ),
                      ),
                    ),
                  ),
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
                              border: Border.all(color: grey, width: 0.5)),
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
                groomSibling.isNotEmpty
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(),
                groomSibling.isNotEmpty
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          groomSibling[index].name,
                                          style: poppinsNormal.copyWith(
                                              color: white, fontSize: 15),
                                        ),
                                        const Spacer(),
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
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: lightBlack,
                                          ),
                                          child: Center(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(groomSibling[index]
                                                  .image!
                                                  .path),
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                        ),
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
                GestureDetector(
                  onTap: () {
                    addSiblingDialog(context, groomRelative);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: grey, width: 0.5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Text(
                              "  + Add Groom's Relative",
                              style: poppinsNormal.copyWith(
                                  color: grey, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                groomRelative.isNotEmpty
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(),
                groomRelative.isNotEmpty
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groomRelative.length,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          groomRelative[index].name,
                                          style: poppinsNormal.copyWith(
                                              color: white, fontSize: 15),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            groomRelative.removeAt(index);
                                            setState(() {
                                              groomRelative;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: lightBlack,
                                          ),
                                          child: Center(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(groomRelative[index]
                                                  .image!
                                                  .path),
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                        ),
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
                  hintText: "Enter Wedding Date (dd-MM-yyyy)",
                  lable: "Wedding Date",
                  controller: weddingDateController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please EnterWedding Date";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Wedding Time",
                  lable: "Wedding Time",
                  controller: weddingTimeController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Wedding Time";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "Enter Wedding Venue",
                  lable: "Wedding Venue",
                  controller: weddingVenueController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Wedding Venue";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    addNewEventDialog(context, events);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: grey, width: 0.5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Text(
                              "  + Add New Event",
                              style: poppinsNormal.copyWith(
                                  color: grey, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                events.isNotEmpty
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(),
                events.isNotEmpty
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: events.length,
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
                                          events[index].eventName,
                                          style: poppinsNormal.copyWith(
                                              color: white, fontSize: 15),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            events.removeAt(index);
                                            setState(() {
                                              events;
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text("Upload\nInvite"),
                      const SizedBox(
                        width: 40,
                      ),
                      UploadImageList(imageList: inviteImage),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("upload minimum 5 couple images"),
                const SizedBox(
                  height: 15,
                ),
                UploadImageList(imageList: coupleImage),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  hintText: "www.youtubelive.com",
                  lable: "Live Streaming link",
                  controller: liveLinkController,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: timeGrey,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Guests request access to view wedding',
                            style: poppinsNormal.copyWith(
                                color: white,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Switch(
                            value: isAccess,
                            onChanged: (value) {
                              setState(() {
                                isAccess = !isAccess;
                              });
                            })
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: timeGrey,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Upload ID proofs from guests',
                            style: poppinsNormal.copyWith(
                                color: white,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Switch(
                            value: isIdProof,
                            onChanged: (value) {
                              setState(() {
                                isIdProof = !isIdProof;
                              });
                            })
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: timeGrey,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Auto upload feed from guests',
                            style: poppinsNormal.copyWith(
                                color: white,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Switch(
                            value: isUploadFeed,
                            onChanged: (value) {
                              setState(() {
                                isUploadFeed = !isUploadFeed;
                              });
                            })
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    addWeddingPress();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
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
                            child: isloading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Text(
                                    'Add Wedding',
                                    textAlign: TextAlign.center,
                                    style: poppinsBold.copyWith(
                                        color: white,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    ));
  }
}

class AddEventModel {
  AddEventModel({
    required this.eventDate,
    this.eventLogo,
    required this.eventName,
    required this.eventTagline,
    required this.eventTime,
    required this.isDresscode,
    required this.eventVenue,
    this.eventId,
    required this.menDresscode,
    required this.womenDresscode,
  });

  final File? eventLogo;
  final String eventName;
  final String eventTagline;
  final String eventDate;
  final String eventTime;
  final String eventVenue;
  final bool isDresscode;
  final String? eventId;
  final String menDresscode;
  final String womenDresscode;

  // factory AddEventModel.fromJson(Map<String, dynamic> json) => AddEventModel(
  //       forMen: json["for_men"],
  //       forWomen: json["for_women"],
  //       outFit: json["outFit"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "for_men": forMen,
  //       "for_women": forWomen,
  //       "outFit": outFit,
  //     };
}

class SidePerson {
  SidePerson({
    required this.name,
    required this.image,
  });

  final File? image;
  final String name;

  factory SidePerson.fromJson(Map<String, dynamic> json) => SidePerson(
        name: json["name"],
        image: json["image"],
      );

  // Map<String, dynamic> toJson() => {
  //       "name": name,
  //       "image": image,
  //     };
}

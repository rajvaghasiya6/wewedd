import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../general/color_constants.dart';
import '../../general/custom_icons.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/popup.dart';
import '../../widgets/user_button.dart';
import 'edit_profile.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile>
    with AutomaticKeepAliveClientMixin<AdminProfile> {
  @override
  bool get wantKeepAlive => true;

  bool isViewId = true;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    // if (context.read<DashboardProvider>().dashboardModel != null) {
    //   isViewId =
    //       context.read<DashboardProvider>().dashboardModel!.isGuestsIdProof;
    // }
    // Future.delayed(const Duration(milliseconds: 0)).then((value) {
    //   context.read<UserProvider>().getUserData(mobileNo: sharedPrefs.mobileNo);
    // });
    // Future.delayed(const Duration(milliseconds: 0)).then((value) {
    //   context.read<UserFeedProvider>().getGuestFeed(type: "All");
    // });
  }

  Future<void> _cropImage(bool isFirst) async {
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
      //_updateUser();
    }
  }

  // _updateUser() async {
  //   Provider.of<UserProvider>(context, listen: false)
  //       .updateUser(
  //           formData: FormData.fromMap({
  //     "guest_profile_image": await MultipartFile.fromFile(pickedImage!.path)
  //   }))
  //       .then((value) {
  //     if (value.success) {
  //       Provider.of<UserProvider>(context, listen: false)
  //           .getUserData(mobileNo: sharedPrefs.mobileNo);
  //       Fluttertoast.showToast(msg: "User image Updated");
  //     } else {
  //       Fluttertoast.showToast(msg: "Fail to Update Details");
  //     }
  //   });
  // }

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

  void _imagePick() {
    showModalBottomSheet(
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
                            _cropImage(true);

                            if (pickedImage == null) {
                              Fluttertoast.showToast(
                                  msg: "failed to pick image");
                            }
                            setState(() {});
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
                            _cropImage(true);

                            if (pickedImage == null) {
                              Fluttertoast.showToast(
                                  msg: "failed to pick image");
                            }
                            setState(() {});
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
                                "  Cancel",
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
    super.build(context);
    var theme = context.watch<ThemeProvider>().darkTheme;
    //  var user = context.watch<UserProvider>().user;
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: NestedScrollView(
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      expandedHeight: 65,
                      flexibleSpace: !theme
                          ? Container(
                              decoration: BoxDecoration(gradient: greyToWhite),
                            )
                          : const SizedBox(),
                      floating: true,
                      snap: true,
                      centerTitle: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(
                            CupertinoIcons.back,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          "Profile",
                          style: gilroyBold.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 7),
                          child: IconButton(
                            icon: const Icon(
                              CustomIcons.logout,
                              size: 17,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => const Popup(
                                        message:
                                            "Are you sure you want to Logout?",
                                      ));
                            },
                          ),
                        ),
                      ],
                    ),
                    SliverAppBar(
                      elevation: 0,
                      toolbarHeight: isViewId ? 240 : 175,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      flexibleSpace: Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: theme
                            ? const BoxDecoration()
                            : BoxDecoration(
                                gradient: greyToWhite,
                              ),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 35, right: 20, left: 20, bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              decoration: theme
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: mediumBlack,
                                    )
                                  : BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: greyToWhite,
                                      boxShadow: [
                                          BoxShadow(
                                              color: white.withOpacity(0.3),
                                              blurRadius: 2,
                                              spreadRadius: 2,
                                              offset: const Offset(-2, -2)),
                                          BoxShadow(
                                              color: grey.withOpacity(0.15),
                                              blurRadius: 2,
                                              spreadRadius: 2,
                                              offset: const Offset(2, 2)),
                                        ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      editProfileDialog(context);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        //change icon with ui one
                                        Icon(
                                          Icons.border_color,
                                          size: 12,
                                          color: theme
                                              ? grey.withOpacity(0.7)
                                              : Colors.black38,
                                        ),
                                        AutoSizeText(" Edit Profile",
                                            style: gilroyNormal.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: theme
                                                  ? grey.withOpacity(0.8)
                                                  : Colors.black54,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: AutoSizeText(
                                      sharedPrefs.guestName,
                                      style: theme
                                          ? gilroyBold.copyWith(fontSize: 16)
                                          : gilroyBold.copyWith(
                                              fontSize: 16, color: eventGrey),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: AutoSizeText(
                                      sharedPrefs.mobileNo,
                                      style: gilroyLight.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: theme
                                              ? grey.withOpacity(0.8)
                                              : eventGrey),
                                    ),
                                  ),
                                  if (isViewId) const SizedBox(height: 20),
                                  if (isViewId)
                                    InkWell(
                                      onTap: () {
                                        // if (user != null) {
                                        //   if (user.guestIdProof.first
                                        //           .split(".")
                                        //           .last ==
                                        //       "pdf") {
                                        //     nextScreen(
                                        //         context,
                                        //         ViewIdPdf(
                                        //             url:
                                        //                 StringConstants.apiUrl +
                                        //                     user.guestIdProof
                                        //                         .first));
                                        //   } else {
                                        //     nextScreen(
                                        //         context,
                                        //         ViewIdImages(
                                        //           urlFirst: StringConstants
                                        //                   .apiUrl +
                                        //               user.guestIdProof.first,
                                        //           urlSecond: user.guestIdProof
                                        //                       .length >
                                        //                   1
                                        //               ? StringConstants.apiUrl +
                                        //                   user.guestIdProof.last
                                        //               : null,
                                        //         ));
                                        //   }
                                        // }
                                      },
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: theme
                                              ? grey.withOpacity(0.1)
                                              : timeGrey.withOpacity(0.07),
                                        ),
                                        child: AutoSizeText(
                                          "View ID Proof",
                                          style: gilroyBold.copyWith(
                                            fontSize: 10,
                                            color: theme ? white : eventGrey,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            Positioned(
                                left: 40,
                                child: UserButton(
                                  size: 70,
                                  url: sharedPrefs.guestProfileImage,
                                  pushScreen: () {
                                    _imagePick();
                                  },
                                ))
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wedding Hosted",
                        style: poppinsBold.copyWith(color: white, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: lightBlack,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "data!.hashtag",
                                        style: poppinsBold.copyWith(
                                            color: white, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        "data.weddingName",
                                        style: poppinsNormal.copyWith(
                                            color: grey, fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        "data.weddingDate",
                                        style: poppinsNormal.copyWith(
                                            color: grey, fontSize: 10),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              const Divider(thickness: 1),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "200 guest registered",
                                    style: poppinsBold.copyWith(
                                        color: white.withOpacity(0.5),
                                        fontSize: 14),
                                  ),
                                  GradientText(
                                    "3 new guest request",
                                    colors: const [
                                      Color(0xfff3686d),
                                      Color(0xffed2831),
                                    ],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: black),
                                child: AutoSizeText(
                                  "Share invite details with guest",
                                  style: gilroyBold.copyWith(
                                    fontSize: 10,
                                    color: theme ? white : eventGrey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

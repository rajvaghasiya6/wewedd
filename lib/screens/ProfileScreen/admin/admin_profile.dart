import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../general/color_constants.dart';
import '../../../general/custom_icons.dart';
import '../../../general/navigation.dart';
import '../../../general/shared_preferences.dart';
import '../../../general/string_constants.dart';
import '../../../general/text_styles.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/popup.dart';
import '../../../widgets/user_button.dart';
import '../../ViewId/viewid_image.dart';
import '../../ViewId/viewid_pdf.dart';
import '../edit_profile.dart';
import 'hosted_wedding_card.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  bool isViewId = true;
  File? pickedImage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ThemeProvider>().setDark();
      Future.delayed(const Duration(milliseconds: 0)).then((value) {
        context
            .read<UserProvider>()
            .userHostedMarriages(mobileNo: sharedPrefs.mobileNo);
      });
    });
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
    var theme = context.watch<ThemeProvider>().darkTheme;
    var isLoading = context.watch<UserProvider>().ishostedLoading;
    var hostedMarriages = context.watch<UserProvider>().hostedMarriages;
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
                      flexibleSpace: const SizedBox(),
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
                        decoration: const BoxDecoration(),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 35, right: 20, left: 20, bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: mediumBlack,
                              ),
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
                                          color: grey.withOpacity(0.7),
                                        ),
                                        AutoSizeText(" Edit Profile",
                                            style: gilroyNormal.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: grey.withOpacity(0.8),
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: AutoSizeText(
                                      sharedPrefs.userName,
                                      style: gilroyBold.copyWith(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: AutoSizeText(
                                      sharedPrefs.mobileNo,
                                      style: gilroyLight.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: grey.withOpacity(0.8)),
                                    ),
                                  ),
                                  if (isViewId) const SizedBox(height: 20),
                                  if (isViewId)
                                    InkWell(
                                      onTap: () {
                                        if (sharedPrefs.userIdProof.first
                                                .split(".")
                                                .last ==
                                            "pdf") {
                                          nextScreen(
                                              context,
                                              ViewIdPdf(
                                                url: StringConstants.apiUrl +
                                                    sharedPrefs
                                                        .userIdProof.first,
                                              ));
                                        } else {
                                          nextScreen(
                                              context,
                                              ViewIdImages(
                                                urlFirst:
                                                    StringConstants.apiUrl +
                                                        sharedPrefs
                                                            .userIdProof.first,
                                                urlSecond: sharedPrefs
                                                            .userIdProof
                                                            .length >
                                                        1
                                                    ? StringConstants.apiUrl +
                                                        sharedPrefs
                                                            .userIdProof.last
                                                    : null,
                                              ));
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: grey.withOpacity(0.1),
                                        ),
                                        child: AutoSizeText(
                                          "View ID Proof",
                                          style: gilroyBold.copyWith(
                                            fontSize: 10,
                                            color: white,
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
                                    //  _imagePick();
                                  },
                                ))
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: isLoading
                    ? const CupertinoActivityIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: hostedMarriages.isEmpty
                            ? Center(
                                child: Text(
                                  "No Wedding Hosted",
                                  style: poppinsNormal.copyWith(
                                      color: grey, fontSize: 14),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  context
                                      .read<UserProvider>()
                                      .userHostedMarriages(
                                          mobileNo: sharedPrefs.mobileNo);
                                },
                                child: ListView(
                                  children: [
                                    Text(
                                      "Wedding Hosted",
                                      style: poppinsBold.copyWith(
                                          color: white, fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.separated(
                                      separatorBuilder: (_, index) =>
                                          const SizedBox(
                                        height: 16,
                                      ),
                                      itemCount: hostedMarriages.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (_, index) {
                                        return HostedWeddingCard(
                                          hostedMarriage:
                                              hostedMarriages[index],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      )),
          ),
        ),
      ),
    );
  }
}

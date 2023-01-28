import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/string_constants.dart';
import '../../general/text_styles.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_feed_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/GradientTabIndicator.dart';
import '../../widgets/user_button.dart';
import '../ViewId/viewid_image.dart';
import '../ViewId/viewid_pdf.dart';
import 'bookmark_screen.dart';
import 'edit_profile.dart';
import 'profile_tabs/profile_all_tab.dart';
import 'profile_tabs/profile_approved_tab.dart';
import 'profile_tabs/profile_pending_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;

  final List<String> tabs = ["All", "Approved", "Pending"];

  bool isViewId = true;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    if (context.read<DashboardProvider>().dashboardModel != null) {
      isViewId =
          context.read<DashboardProvider>().dashboardModel!.isGuestsIdProof;
    }
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<UserProvider>().getUserData(mobileNo: sharedPrefs.mobileNo);
    });
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<UserFeedProvider>().getGuestFeed(type: "All");
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
      _updateUser();
    }
  }

  _updateUser() async {
    Provider.of<UserProvider>(context, listen: false)
        .updateUser(
            formData: FormData.fromMap({
      "guest_profile_image": await MultipartFile.fromFile(pickedImage!.path)
    }))
        .then((value) {
      if (value.success) {
        Provider.of<UserProvider>(context, listen: false)
            .getUserData(mobileNo: sharedPrefs.mobileNo);
        Fluttertoast.showToast(msg: "User image Updated");
      } else {
        Fluttertoast.showToast(msg: "Fail to Update Details");
      }
    });
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
    var user = context.watch<UserProvider>().user;
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
                                        if (user != null) {
                                          if (user.guestIdProof.first
                                                  .split(".")
                                                  .last ==
                                              "pdf") {
                                            nextScreen(
                                                context,
                                                ViewIdPdf(
                                                    url:
                                                        StringConstants.apiUrl +
                                                            user.guestIdProof
                                                                .first));
                                          } else {
                                            nextScreen(
                                                context,
                                                ViewIdImages(
                                                  urlFirst: StringConstants
                                                          .apiUrl +
                                                      user.guestIdProof.first,
                                                  urlSecond: user.guestIdProof
                                                              .length >
                                                          1
                                                      ? StringConstants.apiUrl +
                                                          user.guestIdProof.last
                                                      : null,
                                                ));
                                          }
                                        }
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
                    SliverPersistentHeader(
                      floating: true,
                      pinned: true,
                      delegate: SliverPersistentHeaderDelegateImpl(
                        color: scaffoldBlack,
                        tabBar: TabBar(
                          isScrollable: true,
                          indicator: MyCustomIndicator(
                            color: theme ? Colors.white : Colors.black,
                            height: 1,
                          ),
                          indicatorSize: TabBarIndicatorSize.label,
                          // indicatorPadding: const EdgeInsets.only(bottom: 5),
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle: gilroyBold.copyWith(fontSize: 13),
                          tabs: tabs.map((e) {
                            return Tab(text: e);
                          }).toList(),
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  decoration: theme
                      ? const BoxDecoration()
                      : BoxDecoration(gradient: greyToWhite),
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: const TabBarView(
                    children: [
                      ProfileAllTab(),
                      ProfileApprovedTab(),
                      ProfilePendingTab(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class SliverPersistentHeaderDelegateImpl
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const SliverPersistentHeaderDelegateImpl({
    Color color = Colors.white,
    required this.tabBar,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    overlapsContent = false;
    var theme = context.watch<ThemeProvider>().darkTheme;

    return Container(
      decoration: theme
          ? BoxDecoration(color: scaffoldBlack)
          : BoxDecoration(color: white, gradient: greyToWhite),
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tabBar,
          GestureDetector(
            onTap: () {
              nextScreen(context, const BookMarkScreen());
            },
            child: SvgPicture.asset(
              "icons/bookmark.svg",
              color: Theme.of(context).brightness == Brightness.dark
                  ? white
                  : black,
              height: 20,
              width: 20,
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height - 8;

  @override
  double get minExtent => tabBar.preferredSize.height - 8;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

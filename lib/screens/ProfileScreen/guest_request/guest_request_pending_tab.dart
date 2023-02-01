import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';

class GuestRequestPendingTab extends StatefulWidget {
  const GuestRequestPendingTab({Key? key}) : super(key: key);

  @override
  State<GuestRequestPendingTab> createState() => _GuestRequestPendingTabState();
}

class _GuestRequestPendingTabState extends State<GuestRequestPendingTab>
    with AutomaticKeepAliveClientMixin<GuestRequestPendingTab> {
  @override
  bool get wantKeepAlive => true;

  bool isLoaded = false, isLoading = false;
  //List<GuestFeedModel> allRequest = [];

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(milliseconds: 0)).then((value) {
    //   if (!isLoaded) {
    //     setState(() {
    //       isLoading = true;
    //     });
    //     Provider.of<UserFeedProvider>(context, listen: false)
    //         .getGuestFeed(type: "All")
    //         .then((value) {
    //       images = value.data!;
    //       setState(() {
    //         isLoaded = true;
    //         isLoading = false;
    //       });
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        children: [
          badges.Badge(
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.white,
              padding: EdgeInsets.all(5),
              elevation: 1,
            ),
            badgeContent: const Text(
              '20',
              style: TextStyle(color: Colors.black),
            ),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: grey,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientText(
                        "Reject all",
                        colors: const [
                          Color(0xfff3686d),
                          Color(0xffed2831),
                        ],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const Text(
                        "Accept all",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.green),
                      )
                    ],
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: grey.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: lightBlack,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guest Name',
                            style: poppinsBold.copyWith(
                                color: white, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            '+91 8140655863',
                            style: poppinsNormal.copyWith(
                                color: grey, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: GradientBoxBorder(
                                  gradient: LinearGradient(colors: [
                                    const Color(0xfff3686d),
                                    const Color(0xffed2831),
                                    carouselBlack,
                                    carouselBlack
                                  ]),
                                  width: 0.9,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: GradientText(
                                "Reject",
                                colors: const [
                                  Color(0xfff3686d),
                                  Color(0xffed2831),
                                ],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green, width: 0.9),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Accept request',
                                textAlign: TextAlign.center,
                                style: poppinsNormal.copyWith(
                                    color: Colors.green, fontSize: 14),
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

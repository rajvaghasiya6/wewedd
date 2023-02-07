import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';
import '../../../providers/guest_request_provider.dart';

class GuestRequestPendingTab extends StatefulWidget {
  const GuestRequestPendingTab({required this.marriageId, Key? key})
      : super(key: key);
  final marriageId;
  @override
  State<GuestRequestPendingTab> createState() => _GuestRequestPendingTabState();
}

class _GuestRequestPendingTabState extends State<GuestRequestPendingTab> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<GuestRequestProvider>().guestRequestsApi(
          marriage_id: widget.marriageId, guest_status: "Pending");
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.watch<GuestRequestProvider>().isLoading;
    var guestRequest = context.watch<GuestRequestProvider>().guestRequest;
    return isLoading
        ? const CupertinoActivityIndicator()
        : guestRequest.isEmpty
            ? const Center(child: Text("No request found..."))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  children: [
                    badges.Badge(
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.white,
                        //padding: EdgeInsets.all(5),
                        elevation: 1,
                      ),
                      badgeContent: Text(
                        guestRequest.length.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: grey,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<GuestRequestProvider>(context,
                                            listen: false)
                                        .rejectAllGuest(
                                      marriage_id: widget.marriageId,
                                    )
                                        .then((value) {
                                      if (value.success == true) {
                                        guestRequest.clear();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Something Went Wrong");
                                      }
                                    });
                                  },
                                  child: GradientText(
                                    "Reject all",
                                    colors: const [
                                      Color(0xfff3686d),
                                      Color(0xffed2831),
                                    ],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<GuestRequestProvider>(context,
                                            listen: false)
                                        .approveAllGuest(
                                      marriage_id: widget.marriageId,
                                    )
                                        .then((value) {
                                      if (value.success == true) {
                                        guestRequest.clear();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Something Went Wrong");
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "Accept all",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: guestRequest.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                      itemBuilder: (context, index) {
                        return Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          guestRequest[index].guestName,
                                          style: poppinsBold.copyWith(
                                              color: white, fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          guestRequest[index].guestMobileNumber,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: GradientBoxBorder(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xfff3686d),
                                                      const Color(0xffed2831),
                                                      carouselBlack,
                                                      carouselBlack
                                                    ]),
                                                width: 0.9,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: GradientText(
                                              "Reject",
                                              colors: const [
                                                Color(0xfff3686d),
                                                Color(0xffed2831),
                                              ],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Provider.of<GuestRequestProvider>(
                                                  context,
                                                  listen: false)
                                              .updateGuestStatus(
                                                  marriage_id:
                                                      widget.marriageId,
                                                  guest_status: "Approved",
                                                  guest_id: guestRequest[index]
                                                      .guestId)
                                              .then((value) {
                                            if (value.success == true) {
                                              guestRequest.removeAt(index);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Something Went Wrong");
                                            }
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green,
                                                    width: 0.9),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(6))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: Text(
                                                'Accept request',
                                                textAlign: TextAlign.center,
                                                style: poppinsNormal.copyWith(
                                                    color: Colors.green,
                                                    fontSize: 14),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
  }
}

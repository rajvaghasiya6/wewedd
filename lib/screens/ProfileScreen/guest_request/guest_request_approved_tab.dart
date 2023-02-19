import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';
import '../../../providers/guest_request_provider.dart';

class GuestRequestApprovedTab extends StatefulWidget {
  const GuestRequestApprovedTab({required this.marriageId, Key? key})
      : super(key: key);
  final marriageId;
  @override
  State<GuestRequestApprovedTab> createState() =>
      _GuestRequestApprovedTabState();
}

class _GuestRequestApprovedTabState extends State<GuestRequestApprovedTab> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<GuestRequestProvider>().guestRequestsApi(
          marriage_id: widget.marriageId, guest_status: "Approved");
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.watch<GuestRequestProvider>().isLoading;
    var guestRequest = context.watch<GuestRequestProvider>().guestRequest;
    return isLoading
        ? const CupertinoActivityIndicator()
        : guestRequest.isEmpty
            ? const Center(child: Text("No Approved Guest found..."))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Approved Guest : ",
                          style: poppinsBold.copyWith(fontSize: 20),
                        ),
                        GradientText(
                          guestRequest.length.toString(),
                          colors: const [
                            Color(0xfff3686d),
                            Color(0xffed2831),
                          ],
                          style: poppinsBold.copyWith(fontSize: 20),
                        ),
                      ],
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
                                          height: 8,
                                        ),
                                        Text(
                                          guestRequest[index].guestMobileNumber,
                                          style: poppinsNormal.copyWith(
                                              color: grey, fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        GradientText(
                                          guestRequest[index].guestStatus,
                                          colors: const [
                                            Color(0xfff3686d),
                                            Color(0xffed2831),
                                          ],
                                          style: poppinsNormal.copyWith(
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    guestRequest[index].guestSide != ''
                                        ? guestRequest[index].guestSide ==
                                                'groom_side'
                                            ? Text("G",
                                                style: poppinsBold.copyWith(
                                                    color: Colors.blue,
                                                    fontSize: 18))
                                            : Text("B",
                                                style: poppinsBold.copyWith(
                                                    color: Colors.red,
                                                    fontSize: 18))
                                        : const SizedBox()
                                  ],
                                ),
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

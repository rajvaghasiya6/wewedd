import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../general/color_constants.dart';
import '../../../general/helper_functions.dart';
import '../../../general/navigation.dart';
import '../../../general/text_styles.dart';
import '../../../models/hosted_marriages.dart';
import '../feed_request/feed_request_screen.dart';
import '../guest_request/guest_request_screen.dart';

class HostedWeddingCard extends StatelessWidget {
  HostedWeddingCard({required this.hostedMarriage, Key? key}) : super(key: key);
  HostedMarriages hostedMarriage;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hostedMarriage.hashtag,
                      style: poppinsBold.copyWith(color: white, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      hostedMarriage.weddingName,
                      style: poppinsNormal.copyWith(color: grey, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      format(DateTime.parse(hostedMarriage.weddingDate)),
                      style: poppinsNormal.copyWith(color: grey, fontSize: 12),
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
            Text(
              "${hostedMarriage.totalRegisterGuestNumber} guest registered",
              style: poppinsBold.copyWith(
                  color: white.withOpacity(0.5), fontSize: 14),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (() => nextScreen(
                      context,
                      FeedRequestScreen(
                        marriageId: hostedMarriage.marriageId,
                      ))),
                  child: GradientText(
                    "New feed request",
                    colors: const [
                      Color(0xfff3686d),
                      Color(0xffed2831),
                    ],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: (() => nextScreen(
                      context,
                      GuestRequestScreen(
                          marriageId: hostedMarriage.marriageId))),
                  child: GradientText(
                    "${hostedMarriage.pendingRequestNumber} new guest request",
                    colors: const [
                      Color(0xfff3686d),
                      Color(0xffed2831),
                    ],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
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
                  borderRadius: BorderRadius.circular(2), color: black),
              child: AutoSizeText(
                "Share invite details with guest",
                style: gilroyBold.copyWith(
                  fontSize: 10,
                  color: eventGrey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

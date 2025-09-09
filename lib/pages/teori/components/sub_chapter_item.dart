import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

class SubChapterItem extends StatelessWidget {
  final String subChapter;
  final String route;

  const SubChapterItem({super.key, required this.subChapter, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Selected: $subChapter'),
        //     duration: const Duration(milliseconds: 800),
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 0,0),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: kWhiteColor.withValues(alpha:0.3)),
                color: kBoxGreyColor,
              ),
              child: Image.asset(
                "assets/Scroll.png",
                height: 18,
                width: 18,
                color: kWhiteColor,
              ),
            ),
            // const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 60,
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: kBoxGreyColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kWhiteColor.withValues(alpha:0.1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        subChapter,
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
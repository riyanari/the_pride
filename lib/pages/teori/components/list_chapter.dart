import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/components/sub_chapter_item.dart';
import 'package:the_pride/theme/theme.dart';

class ListChapter extends StatefulWidget {
  final List<Map<String, dynamic>> materi;
  final List<Map<String, dynamic>> dataLevel;

  const ListChapter({super.key, required this.materi, required this.dataLevel});

  @override
  State<ListChapter> createState() => _ListChapterState();
}

class _ListChapterState extends State<ListChapter> {
  int? expandedChapterIndex;
  Widget header() {
    var levelData = widget.dataLevel[0];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBoxGreyColor,
                    ),
                    child: Image.asset('assets/ic_back.png'),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  levelData['level'],
                  style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset('assets/ic_code.png', height: 18),
                SizedBox(width: 4,),
                Text(
                  levelData['kd_level'],
                  style: primaryTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
                ),
                SizedBox(width: 10,),
                Image.asset('assets/ic_coins_black.png', height: 18),
                SizedBox(width: 4,),
                Text(
                  levelData['poin'],
                  style: primaryTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20,),
        Text(
          levelData['name'],
          style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
        ),
        Text(
          levelData['jargon'],
          style: primaryTextStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget chapter(Map<String, dynamic> chapterData, int index, BuildContext context) {
    bool isExpanded = expandedChapterIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kBoxGreyColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter header (always visible)
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedChapterIndex = null;
                } else {
                  expandedChapterIndex = index;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     color: kGreyColor,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: Icon(
                  //     Icons.menu_book,
                  //     size: 20,
                  //     color: kWhiteColor,
                  //   ),
                  // ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapterData['chapter'],
                          style: whiteTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          chapterData['judul_chapter'],
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: kWhiteColor,
                  ),
                ],
              ),
            ),
          ),

          // Sub-chapters (visible when expanded)
          if (isExpanded) ...[
            const Divider(height: 1),
            ...chapterData['sub_chapters'].map<Widget>((subChapter) {
              return InkWell(
                onTap: () {
                  // Action when subchapter is tapped
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected: $subChapter'),
                      duration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Container 1: Untuk ikon scroll
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // color: kBoxGreyColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: kWhiteColor.withValues(alpha:0.3)),
                        ),
                        child: Image.asset(
                          "assets/Scroll.png",
                          height: 18,
                          width: 18,
                          color: kWhiteColor,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Container 2: Untuk teks sub-chapter
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: kGreyColor.withValues(alpha:0.2),
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
            }).toList(),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget chapterCard(Map<String, dynamic> chapterData, int index, BuildContext context) {
    bool isExpanded = expandedChapterIndex == index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container utama
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: kBoxGreyColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chapter header
              InkWell(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      expandedChapterIndex = null;
                    } else {
                      expandedChapterIndex = index;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kBoxGreyColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      // const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapterData['chapter'],
                              style: whiteTextStyle.copyWith(fontSize: 12),
                            ),
                            Text(
                              chapterData['judul_chapter'],
                              style: whiteTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: kWhiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Sub-chapters di luar container (muncul di bawah)
        if (isExpanded) ...[
          ...chapterData['sub_chapters'].map<Widget>((subChapter) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SubChapterItem(subChapter: subChapter['title'],
                route: subChapter['route'],),
            );
          }).toList(),
        ],
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
          children: [
            header(),
            SizedBox(height: 30,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.materi.length,
                itemBuilder: (context, index) {
                  return chapterCard(widget.materi[index], index, context); // Create a dropdown for each chapter
                  // return chapter(widget.materi[index], index, context);
                },
              ),
            ),
          ]),
    );
  }
}

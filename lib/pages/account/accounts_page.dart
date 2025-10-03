import 'package:flutter/material.dart';
import 'package:sliding_action_button/sliding_action_button.dart';
import 'package:the_pride/theme/theme.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              _buildHalfCircleTop(context),
              Column(
                children: [
                  // Header dengan informasi profil
                  _buildProfileHeader(),

                  // Bagian poin dan lokasi kursus
                  _buildPointsSection(),

                  SizedBox(height: 10),

                  // Menu tracking order
                  _buildOrderTracking(),

                  // Daftar kursus yang diikuti
                  // _buildCoursesSection(),
                  SizedBox(height: 10),

                  // Menu pengaturan
                  _buildSettingsMenu(),

                  SizedBox(height: 30),

                  // Tombol logout
                  _buildLogoutButton(context),

                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHalfCircleTop(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: tPrimaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Image.asset(
            "assets/img_background_book.png",
            fit: BoxFit.cover,
            color: kGreyColor.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(18, 45, 18, 10),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: kWhiteColor,
                child: Image.asset("assets/lion_profile.png", height: 50),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RIYAN ARIYAWAN",
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "@riyanari",
                      style: whiteTextStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.navigate_next, size: 30, color: kWhiteColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sep 2025",
                  style: primaryTextStyle.copyWith(
                    fontSize: 10,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: 10),
                Text("Bergabung", style: blackTextStyle.copyWith(fontSize: 10)),
              ],
            ),
          ),
          SizedBox(
            height: 55, // atur sesuai kebutuhan
            width: 50,
            child: VerticalDivider(
              color: kBoxGreyColor,
              width: 1,
              thickness: 1,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "4000",
                  style: secondaryTextStyle.copyWith(
                    fontSize: 10,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: 10),
                Text("Poin", style: blackTextStyle.copyWith(fontSize: 10)),
              ],
            ),
          ),
          SizedBox(
            height: 55, // atur sesuai kebutuhan
            width: 50,
            child: VerticalDivider(
              color: kBoxGreyColor,
              width: 1,
              thickness: 1,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gayamsari, Semarang",
                  style: primaryTextStyle.copyWith(
                    fontSize: 10,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Lokasi Kursus",
                  style: blackTextStyle.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTracking() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withValues(alpha:0.2),
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Penukaran reward",
            style: primaryTextStyle.copyWith(fontSize: 10, fontWeight: regular),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStep(
                "Dikemas",
                "assets/img_dikemas.png",
                kPrimaryColor,
              ),
              SizedBox(
                height: 55, // atur sesuai kebutuhan
                width: 50,
                child: VerticalDivider(
                  color: kBoxGreyColor,
                  width: 1,
                  thickness: 1,
                ),
              ),
              _buildOrderStep(
                "Dikirim",
                "assets/img_dikirim.png",
                kPrimaryColor,
              ),
              SizedBox(
                height: 55, // atur sesuai kebutuhan
                width: 50,
                child: VerticalDivider(
                  color: kBoxGreyColor,
                  width: 1,
                  thickness: 1,
                ),
              ),
              _buildOrderStep(
                "Diterima",
                "assets/img_diterima.png",
                kPrimaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStep(String title, String image, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon(icon, color: color, size: 24),
        Image.asset(image, height: 30, color: color),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  // Widget _buildCoursesSection() {
  //   return Container(
  //     margin: const EdgeInsets.fromLTRB(18, 10, 18, 0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //          Text(
  //           "Kursus Diikuti",
  //           style: primaryTextStyle.copyWith(
  //             fontSize: 14,
  //             fontWeight: bold
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         _buildCourseItem("Bahasa Inggris", "Level 1 Page (The Beginner)"),
  //         const SizedBox(height: 8),
  //         _buildCourseItem("Bahasa Inggris", "Level 2 Squire (The Apprentic)"),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCourseItem(String course, String level) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  level,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: kWhiteColor),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha:0.3),
              blurRadius: 20, // semakin besar makin lembut
              spreadRadius: 10, // biar keluar ke semua arah
              offset: Offset(0, 0), // bayangan ke semua sisi
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMenuItem("Ubah Password", "assets/ic_pass.png", Icons.arrow_forward_ios),
            _buildDivider(),
            _buildMenuItem("Pusat Bantuan", "assets/ic_help.png", Icons.arrow_forward_ios),
            _buildDivider(),
            _buildMenuItem("Saran", "assets/ic_saran.png", Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String leading, IconData trailingIcon) {
    return ListTile(
      leading: SizedBox(
        width: 24,
        child: Image.asset(leading)
      ),
      title: Text(
        title.substring(title.indexOf(' ') + 1),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(trailingIcon, size: 16, color: Colors.grey),
      onTap: () {
        // Handle menu item tap
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[300],
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return CircleSlideToActionButton(
      // slideToActionController: ,
      width: MediaQuery.of(context).size.width * 0.9,
      parentBoxRadiusValue: 27,
      circleSlidingButtonSize: 47,
      leftEdgeSpacing: 3,
      initialSlidingActionLabel: 'Slide to logout',
      initialSlidingActionLabelTextStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600),
      finalSlidingActionLabel: 'Logout',
      circleSlidingButtonIcon: const Icon(
        Icons.power_settings_new_rounded,
        color: kSecondaryColor,
      ),
      parentBoxBackgroundColor: kBoxGreyColor,
      parentBoxDisableBackgroundColor: kBoxMenuRedColor,
      circleSlidingButtonBackgroundColor: Colors.white,
      isEnable: true,
      slideActionButtonType:
      SlideActionButtonType.slideActionWithLoaderButton,
      onSlideActionCompleted: () async {
        print("Sliding action completed");
      },
      onSlideActionCanceled: () {
        print("Sliding action cancelled");
      },
    );
  }
}

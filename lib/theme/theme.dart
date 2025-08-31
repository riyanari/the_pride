import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 18.0;
double defaultRadius = 10.0;

// const Color kPrimaryColor = Color(0xff2B7C79);
const Color kPrimaryColor = Color(0xFF088440);
const Color kTabelColor = Color(0xffeae9e9);
const Color kSecondaryColor = Color(0xFFE5A54D);
const Color kGreyColor = Color(0xFFC7C7C7);
const Color kBackgroundColor = Color(0xffFAFAFA);
const Color kBoxColor = Color(0xffFFFFFF);
const Color kWhiteColor = Color(0xffFFFFFF);
const Color kUnselectColor = Color(0xffF0F0F0);

const Color kBoxMenuGreenColor = Color(0xff088440);
const Color kBoxMenuOrangeColor = Color(0xffE5A54D);
const Color kBoxMenuRedColor = Color(0xffD1495B);
const Color kBoxMenuBlackColor = Color(0xff3E3E3E);
const Color kBoxMenuCoklatColor = Color(0xffFF8A00);
const Color kBoxMenuLightBlueColor = Color(0xff2B7C79);
const Color kBoxMenuDarkBlueColor = Color(0xff2E6274);

const Color tPrimaryColor = Color(0xff088440);
const Color tDarkGreenColor = Color(0xff074623);
const Color tSecondaryColor = Color(0xff96B3A4);
const Color tErrorColor = Color(0xffD1495B);

TextStyle primaryTextStyle = GoogleFonts.poppins(
    color:tPrimaryColor
);

TextStyle errorTextStyle = GoogleFonts.poppins(
    color:tErrorColor
);

TextStyle secondaryTextStyle = GoogleFonts.poppins(
    color:tSecondaryColor
);

TextStyle titleTextStyle = GoogleFonts.sairaStencilOne(
  color: tPrimaryColor
);

TextStyle titleWhiteTextStyle = GoogleFonts.sairaStencilOne(
    color: kWhiteColor
);
TextStyle whiteTextStyle = GoogleFonts.poppins(
    color: kWhiteColor
);

TextStyle darkGreenTextStyle = GoogleFonts.poppins(
    color: tDarkGreenColor
);

TextStyle orangeTextStyle = GoogleFonts.poppins(
    color: kBoxMenuOrangeColor
);

TextStyle blackTextStyle = GoogleFonts.poppins(
    color: kBoxMenuBlackColor
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
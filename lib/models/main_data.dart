import 'package:flutter/material.dart';
// title
String mainTitle = "أكتشف سر لغتي";
// url
// String mainUrl = "http://localhost:90/mew-edu-app/public/api/v1/";
// String siteUrl = "http://localhost:90/mew-edu-app/public/";
const mainUrl = "https://dev.digithup.net/api/v1/";
const siteUrl = "https://dev.digithup.net/";
// const zoomApi ='FnoAY6Y7QNWQ1Q9hS8cZQw';
// const zoomSec = '6RsjVbPtEkIqSKzKZED4DxMSE3FlmKZ6SpbX';
// width and height of screens
extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
/// ***********************************************************************
///
const kBackgroundColor = Color(0xFFF5F9FA);
const kDarkButtonBg = Color(0xFF273546);
const kSecondaryColor = Color(0xFF808080);
const kSelectItemColor = Color(0xFF000000);
const kRedColor = Color(0xFFEC5252);
const kOrangeColor = Color(0xFFDE8E33);
const kBlueColor = Color(0xFF68B0FF);
const kGreenColor = Color(0xFF43CB65);
const kGreenPurchaseColor = Color(0xFF2BD0A8);
const kToastTextColor = Color(0xFFEEEEEE);
const kTextColor = Color(0xFF273242);
const kTextLightColor = Color(0xFF000000);
const kTextLowBlackColor = Colors.black38;
const kStarColor = Color(0xFFEFD358);
const kDeepBlueColor = Color(0xFF594CF5);
const kTabBarBg = Color(0xFFEEEEEE);
const kDarkGreyColor = Color(0xFF757575);
const kTextBlueColor = Color(0xFF5594bf);
const kTimeColor = Color(0xFF366cc6);
const kTimeBackColor = Color(0xFFe3ebf5);
const kLessonBackColor = Color(0xFFf8e5d2);
// const kLightBlueColor = Color(0xFFE7EEFE);
const kLightBlueColor = Color(0xFF4AA8D4);
const kFormInputColor = Color(0xFFc7c8ca);
const kNoteColor = Color(0xFFbfdde4);
const kLiveClassColor = Color(0xFFfff3cd);
const kSectionTileColor = Color(0xFFdddcdd);
// Color of Categories card, long arrow
const iCardColor = Color(0xFFF4F8F9);


const kDefaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
  borderSide: BorderSide(color: Colors.white, width: 2),
);

const kDefaultFocusInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
  borderSide: BorderSide(color: kBlueColor, width: 2),
);
const kDefaultFocusErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kRedColor),
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
);

// our default Shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(20, 10),
  blurRadius: 20,
  color: Colors.black12, // Black color with 12% opacity
);


// lightTheme
final lightTheme = ThemeData(
  fontFamily: 'Cairo', // uses
  canvasColor: const Color.fromRGBO(255, 255, 255, 1), // background color of pages
  primaryColor: const Color.fromRGBO(85, 167, 151, 1),
  dividerColor: const Color.fromRGBO(220, 223, 227, 1),
  indicatorColor: const Color.fromRGBO(173, 212, 97,1), // uses
  shadowColor: const Color.fromRGBO(130, 210, 231, 1), // uses
  // app bar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    shadowColor: Colors.grey,
    foregroundColor: Colors.black,
  ),
  // text
  textTheme: const TextTheme(
    // used
    displayLarge: TextStyle(
      fontFamily: 'Cairo',
      color: Color.fromRGBO(52, 52, 52, 1),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    // used
    displayMedium: TextStyle(
      color: Color.fromRGBO(83, 82, 88, 1.0),
      fontSize: 27,
      fontWeight: FontWeight.w500,
      fontFamily: 'Cairo',
    ),
    // used
    displaySmall: TextStyle(
      fontFamily: 'Cairo',
      color: Color.fromRGBO(83, 82, 88, 1.0),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    // used
    headlineMedium: TextStyle(
      fontFamily: 'Cairo',
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
    // used
    headlineSmall: TextStyle(
      fontFamily: 'Cairo',
      color: Color.fromRGBO(83, 82, 88, 1),
      fontSize: 10,
    ),
    //used
    titleLarge: TextStyle(
      fontFamily: 'Cairo',
      color: Color.fromRGBO(134, 136, 141, 1),
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    // uses
    bodyLarge: TextStyle(
      color: Colors.black87,
      fontFamily: 'Cairo',
      fontSize: 16,
    ),
    // default of all  texts
    bodyMedium: TextStyle(
      color: Color.fromRGBO(134, 136, 141, 1),
      fontFamily: 'Cairo',
    ),
  ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: const Color.fromRGBO(130, 210, 231, 1)), bottomAppBarTheme: const BottomAppBarTheme(color: Color.fromRGBO(107, 108, 107, 1)),
);
/// *********************************************************************** ///
// loadingStyle
Widget loadingStyle(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(height: 10),
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text('جارٍ التحميل...'),
      ],
    ),
  );
}
// no Items
Widget noItems(BuildContext context) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const[
        Text('لا يوجد عناصر مضافة حتي الآن'),
        SizedBox(width: 5),
        //Icon(FontAwesomeIcons.heartCrack,color: Theme.of(context).appBarTheme.foregroundColor,),
      ],
    ),
  );
}
// screenStartWidget
Widget screenStartWidget(BuildContext context,bool isLoading, {var items, required Widget buildWidget}) {
  return isLoading ? loadingStyle(context): items.isEmpty ? noItems(context) : buildWidget;
}


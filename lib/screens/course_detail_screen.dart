// ignore_for_file: deprecated_member_use

import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/providers/shared_pref_helper.dart';
import 'package:academy_app/widgets/custom_text.dart';
import 'package:academy_app/widgets/lesson_list_item.dart';
import 'package:academy_app/widgets/star_display_widget.dart';
import 'package:academy_app/widgets/tab_view_details.dart';
import 'package:academy_app/widgets/util.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../widgets/app_bar_two.dart';
import '../providers/courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/from_network.dart';
import '../widgets/from_vimeo_id.dart';
import '../widgets/from_youtube.dart';

class CourseDetailScreen extends StatefulWidget {
  static const routeName = '/course-details';
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var _isInit = true;
  bool _isAuth = false;
  var _isLoading = false;
  String? _authToken;
  dynamic loadedCourseDetail;
  dynamic courseId;
  int? selected;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void _launchURL(String url) async => await canLaunch(url)
      ? await launch(url, forceSafariVC: false)
      : throw 'Could not launch $url';

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      var token = await SharedPreferenceHelper().getAuthToken();
      setState(() {
        _isLoading = true;
        // _authToken = Provider.of<Auth>(context, listen: false).token;
        if (token != null && token.isNotEmpty) {
          _isAuth = true;
        } else {
          _isAuth = false;
        }
      });

      // ignore: use_build_context_synchronously
      courseId = ModalRoute.of(context)!.settings.arguments as int;

      // ignore: use_build_context_synchronously
      Provider.of<Courses>(context, listen: false)
          .fetchCourseDetailById(courseId)
          .then((_) {
        loadedCourseDetail =
            Provider.of<Courses>(context, listen: false).getCourseDetail;
        // ignore: unused_local_variable
        final activeCourse =
            Provider.of<Courses>(context, listen: false).findById(courseId);
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final courseId = ModalRoute.of(context)!.settings.arguments as int;
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);
    return Scaffold(
      appBar: CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Courses>(
              builder: (context, courses, child) {
                final loadedCourseDetail = courses.getCourseDetail;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.6),
                                          BlendMode.dstATop),
                                      image: NetworkImage(
                                        loadedCourse.thumbnail.toString(),
                                      ),
                                    )),
                              ),
                            ),
                            ClipOval(
                              child: InkWell(
                                onTap: () {
                                  if (loadedCourse.courseOverviewProvider ==
                                      'vimeo') {
                                    String vimeoVideoId = loadedCourse
                                        .courseOverviewUrl!
                                        .split('/')
                                        .last;
                                    // _showVimeoModal(context, vimeoVideoId);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PlayVideoFromVimeoId(
                                                    courseId: loadedCourse.id!,
                                                    vimeoVideoId:
                                                        vimeoVideoId)));
                                  } else if (loadedCourse
                                          .courseOverviewProvider ==
                                      'html5') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayVideoFromNetwork(
                                                  courseId: loadedCourse.id!,
                                                  videoUrl: loadedCourse
                                                      .courseOverviewUrl!)),
                                    );
                                  } else {
                                    if (loadedCourse
                                        .courseOverviewProvider!.isEmpty) {
                                      CommonFunctions.showSuccessToast(
                                          'Video url not provided');
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlayVideoFromYoutube(
                                                    courseId: loadedCourse.id!,
                                                    videoUrl: loadedCourse
                                                        .courseOverviewUrl!),
                                          ));
                                    }
                                  }
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [kDefaultShadow],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      'assets/images/play.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -15,
                              right: 20,
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      if (_isAuth) {
                                        var msg =
                                            loadedCourseDetail.isWishlisted;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              buildPopupDialogWishList(
                                                  context,
                                                  loadedCourseDetail
                                                      .isWishlisted,
                                                  loadedCourse.id,
                                                  msg),
                                        );
                                      } else {
                                        CommonFunctions.showSuccessToast(
                                            'الرجاء تسجيل الدخول أولا');
                                      }
                                    },
                                    tooltip: 'الدورات المفضلة',
                                    backgroundColor: kRedColor,
                                    child: Icon(
                                      loadedCourseDetail.isWishlisted!
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: loadedCourse.title,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Text(''),
                            ),
                          ],
                        ),
                      ),


                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: ListView.builder(
                                key: Key(
                                    'builder ${selected.toString()}'), //attention
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: loadedCourseDetail.mSection!.length,
                                itemBuilder: (ctx, index) {
                                  final section =
                                      loadedCourseDetail.mSection![index];
                                  return Card(
                                    elevation: 0.3,
                                    child: ExpansionTile(
                                      key: Key(index.toString()), //attention
                                      initiallyExpanded: index == selected,
                                      onExpansionChanged: ((newState) {
                                        if (newState) {
                                          setState(() {
                                            selected = index;
                                          });
                                        } else {
                                          setState(() {
                                            selected = -1;
                                          });
                                        }
                                      }), //attention
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                              ),
                                              child: CustomText(
                                                text: HtmlUnescape().convert(
                                                    section.title.toString()),
                                                colors: kDarkGreyColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: kTimeBackColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 5.0,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: CustomText(
                                                        text: section
                                                            .totalDuration,
                                                        fontSize: 10,
                                                        colors: kTimeColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: kLessonBackColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 5.0,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              kLessonBackColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        child: CustomText(
                                                          text:
                                                              '${section.mLesson!.length} الدروس ',
                                                          fontSize: 10,
                                                          colors:
                                                              kDarkGreyColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Expanded(
                                                    flex: 2, child: Text("")),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (ctx, index) {
                                            return LessonListItem(
                                              lesson: section.mLesson![index],
                                              courseId:
                                                  loadedCourseDetail.courseId!,
                                            );
                                          },
                                          itemCount: section.mLesson!.length,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

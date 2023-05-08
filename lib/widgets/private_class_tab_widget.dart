// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:academy_app/models/live_class_model.dart';
import 'package:academy_app/providers/shared_pref_helper.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../screens/video_conferance_page.dart';
import '../screens/webview_screen.dart';
import 'custom_text.dart';
import 'package:http/http.dart' as http;

class PrivateClassTabWidget extends StatefulWidget {
  final int courseId;
  const PrivateClassTabWidget({Key? key, required this.courseId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LiveClassTabWidgetState createState() => _LiveClassTabWidgetState();
}

class _LiveClassTabWidgetState extends State<PrivateClassTabWidget> {
  dynamic token;

  Future<LiveClassModel>? futureLiveClassModel;

  Future<LiveClassModel> fetchLiveClassModel() async {
    token = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/zoom_live_class?course_id=${widget.courseId}&auth_token=$token';
    try {
      final response = await http.get(Uri.parse(url));

      return LiveClassModel.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    futureLiveClassModel = fetchLiveClassModel();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    return FutureBuilder<LiveClassModel>(
      future: futureLiveClassModel,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .50,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (dataSnapshot.error != null) {
            /*
            Note: the returned value from Postman is empty as following.
              zoom_live_class_details	[]
              zoom_api_key	""
              zoom_secret_key	""
            */
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    color: kNoteColor,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        'لايوجد غرف حتي الان  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          wordSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(
                    dataSnapshot.data!.zoomLiveClassDetails!.time.toString()) *
                1000);
            // 12 Hour format:
            var date = DateFormat('hh:mm a : E, dd MMM yyyy').format(dt);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.event_available,
                        color: Colors.black45,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: CustomText(
                          text: 'ميعاد الغرفة',
                          fontSize: 15,
                          colors: kTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomText(
                  text: date,
                  fontSize: 18,
                  colors: kTextColor,
                  // fontWeight: FontWeight.bold,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    color: kNoteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        dataSnapshot.data!.zoomLiveClassDetails!.noteToStudents
                            .toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          wordSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'كلمة المرور',
                      desc: 'الرجاء إدخال كلمة المرور',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        if (passwordController.text ==
                            dataSnapshot
                                .data!.zoomLiveClassDetails!.zoomMeetingPassword
                                .toString()) {
                          // >> zoomApi and zoomSec is not working, so that we will use another way <<

                          // final token = await SharedPreferenceHelper().getAuthToken();
                          // final url = '$BASE_URL/api/zoom_mobile_web_view/${widget.courseId}/$token';
                          // // print(_url);
                          // Navigator.of(context).pushNamed(WebViewScreen.routeName, arguments: url);

                          // The other way
                          myMeetingId = widget.courseId.toString();
                          Navigator.of(context)
                              .pushNamed(VideoConferancePage.routeName);
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'خطأ',
                            desc: 'كلمة المرور غير صحيحة',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                            btnCancelText: 'إلغاء',
                            btnOkText: 'موافق',
                            btnCancelColor: Colors.grey,
                            btnOkColor: kRedColor,
                          ).show();
                        }
                      },
                      btnCancelText: 'إلغاء',
                      btnOkText: 'موافق',
                      btnCancelColor: Colors.grey,
                      btnOkColor: kRedColor,
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            hintText: 'كلمة المرور',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).show();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    primary: kOrangeColor,
                  ),
                  icon: const Icon(
                    Icons.videocam_rounded,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CustomText(
                      text: 'انضم إلى غرفة التحدي',
                      fontSize: 17,
                      colors: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}

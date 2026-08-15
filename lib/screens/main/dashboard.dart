import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/profile.dart';
import 'package:tailorhub/services/profile_service.dart';
import 'package:tailorhub/utils/name_utils.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ProfileService _profileService = ProfileService();

  Profile? _profile;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final result = await _profileService.getCurrentProfile();

      if (!mounted) return;

      setState(() {
        _profile = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('EEEE, d MMMM').format(now);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Custombg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todayDate,
                          style: AppFonts.label(
                            color: AppColor.grey.withValues(alpha: .4),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Welcome, ${_profile?.fullName.split(' ').first ?? 'Tailor'}",
                          style: AppFonts.heading(color: AppColor.text),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "what are we sketching today?",
                          style: AppFonts.body(color: AppColor.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColor.background,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: AppColor.grey.withValues(alpha: .3),
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 20,
                          color: AppColor.text,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            width: 2,
                            color: AppColor.primary.withValues(alpha: .4),
                          ),
                        ),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColor.first,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              width: 2,
                              color: AppColor.first.withValues(alpha: .6),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _profile == null
                                  ? ''
                                  : getInitials(_profile!.fullName),
                              style: AppFonts.bodyLarge(
                                color: AppColor.background,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.first,
                        AppColor.secondary.withValues(alpha: .25),
                      ],
                      stops: const [0.55, 1.0],
                      begin: const Alignment(-1.0, -0.3),
                      end: const Alignment(1.0, 0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.background.withValues(alpha: .2),
                          ),
                          child: Icon(
                            CupertinoIcons.sparkles,
                            size: 20,
                            color: AppColor.background,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Unlock Atelier Premium",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'DMSANS',
                                fontVariations: [FontVariation('wght', 700)],
                                color: AppColor.background,
                              ),
                            ),
                            Text(
                              "Unlock Premium items",
                              style: AppFonts.body(color: AppColor.grey),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColor.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Work",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'CormorantGaramond',
                              fontVariations: [FontVariation('wght', 500)],
                              color: AppColor.text,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "All orders",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'DMSANS',
                                    fontVariations: [
                                      FontVariation('wght', 600),
                                    ],
                                    color: AppColor.primary,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: AppColor.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

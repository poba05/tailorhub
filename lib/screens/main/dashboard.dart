import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/models/profile.dart';
import 'package:tailorhub/screens/order/new_orders.dart';
import 'package:tailorhub/screens/order/order_screen.dart';
import 'package:tailorhub/services/profile_service.dart';
import 'package:tailorhub/utils/name_utils.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:intl/intl.dart';
import 'package:tailorhub/widgets/empty_state.dart';
import 'package:tailorhub/widgets/order_container.dart';
import 'package:tailorhub/services/order_service.dart';
import 'package:tailorhub/widgets/quickaction.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ProfileService _profileService = ProfileService();
  final OrderService _orderService = OrderService();

  Profile? _profile;
  List<Order> orders = [];

  bool isLoading = false;
  bool showQuickActions = false;

  bool isOrderLoading = false;
  String? ordersError;

  @override
  void initState() {
    super.initState();

    loadProfile();
    loadOrders();
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

      debugPrint('$e');
    }
  }

  Future<void> loadOrders() async {
    setState(() {
      isOrderLoading = true;
      ordersError = null;
    });

    try {
      final result = await _orderService.getUpcomingOrders();

      if (!mounted) return;

      setState(() {
        orders = result;
        isOrderLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        ordersError = 'Unable to Load';
        isOrderLoading = false;
      });

      debugPrint('Order error: $e');
    }
  }

  Widget buildQuickAction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        quickAction(
          icon: Icons.cut,
          title: "New order",
          description: "Start a garment from an existing template",
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const NewOrders();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final slide =
                          Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
              ),
            );
          },
        ),
        SizedBox(height: 10),
        quickAction(
          icon: Icons.person_add,
          title: "New Client",
          description: "Add a new client to your list",
          onTap: () {},
        ),
      ],
    );
  }

  Widget buildAddButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showQuickActions = !showQuickActions;
        });
      },
      child: AnimatedRotation(
        turns: showQuickActions ? 0.125 : 0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: AppColor.first,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.first.withValues(alpha: .3),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(Icons.add, size: 28, color: AppColor.background),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('EEEE, d MMMM').format(now);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Custombg(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dashboardHeader(todayDate),
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
                                  color: AppColor.background.withValues(
                                    alpha: .2,
                                  ),
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
                                      fontVariations: [
                                        FontVariation('wght', 700),
                                      ],
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
                      previewOrders(context),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (showQuickActions)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showQuickActions = false;
                  });
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                  child: Container(color: Colors.black.withOpacity(0.12)),
                ),
              ),
            ),
          Positioned(
            bottom: 75,
            left: 260,
            right: 0,
            child: Center(child: buildAddButton()),
          ),
          if (showQuickActions)
            Positioned(bottom: 135, right: 20, child: buildQuickAction()),
        ],
      ),
    );
  }

  Container previewOrders(BuildContext context) {
    return Container(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const OrderScreen();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            final slide =
                                Tween<Offset>(
                                  begin: const Offset(0, 0.08),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  ),
                                );
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: slide,
                                child: child,
                              ),
                            );
                          },
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "All orders",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'DMSANS',
                        fontVariations: [FontVariation('wght', 600)],
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
          if (isOrderLoading)
            const Center(child: CircularProgressIndicator())
          else if (ordersError != null)
            Text(ordersError!)
          else if (orders.isEmpty)
            const EmptyState(
              title: "No Orders Yet",
              subTitle: "create the orders to appear here",
              buttonText: "New Order",
            )
          else
            Column(
              children: orders.map((order) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OrderContainer(order: order),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Row dashboardHeader(String todayDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todayDate,
              style: AppFonts.label(color: AppColor.grey.withValues(alpha: .4)),
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
                  _profile == null ? '' : getInitials(_profile!.fullName),
                  style: AppFonts.bodyLarge(color: AppColor.background),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

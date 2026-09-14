import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/models/profile.dart';
import 'package:tailorhub/screens/order/order_screen.dart';
import 'package:tailorhub/services/client_services.dart';
import 'package:tailorhub/services/profile_service.dart';
import 'package:tailorhub/utils/name_utils.dart';
import 'package:tailorhub/widgets/create_btn_popup.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:intl/intl.dart';
import 'package:tailorhub/widgets/empty_state.dart';
import 'package:tailorhub/widgets/order_container.dart';
import 'package:tailorhub/services/order_service.dart';
import 'package:tailorhub/widgets/skeleton_box.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ProfileService _profileService = ProfileService();
  final OrderService _orderService = OrderService();
  final ClientServices _clientServices = ClientServices();

  Profile? _profile;
  List<Order> orders = [];
  List<Clients> clients = [];

  bool isLoading = false;

  bool isOrderLoading = false;
  String? ordersError;

  int totalClients = 0;
  int clientsThisMonth = 0;
  int activeOrders = 0;
  int dueThisWeek = 0;
  int completedOrders = 0;
  int pending = 0;

  @override
  void initState() {
    super.initState();

    loadProfile();
    loadOrders();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
    });
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

  Future<void> loadClients() async {
    final result = await _clientServices.getclients();

    if (!mounted) return;

    setState(() {
      clients = result;
    });
  }

  Future<void> loadDashboardData() async {
    final clients = await _clientServices.getclients();
    final thisMonth = await _clientServices.getClientsCreatedThisMonth();
    final totalActiveOrders = await _orderService.getActiveOrders();
    final dueinaWeek = await _orderService.getOrdersDueinOneWeek();
    final ordersCompleted = await _orderService.getCompletdOrders();
    final awaitPayment = await _orderService.getPending();

    if (!mounted) return;

    setState(() async {
      totalClients = clients.length;
      clientsThisMonth = thisMonth;
      activeOrders = totalActiveOrders;
      dueThisWeek = dueinaWeek;
      completedOrders = ordersCompleted;
      pending = awaitPayment;
    });
  }

  List<dynamic> get summaryDetails => [
    {
      'id': 1,
      'figure': totalClients,
      'title': "Total Clients",
      'description': '+$clientsThisMonth Last month',
      'percentage': 83,
      'color': AppColor.blue,
    },
    {
      'id': 2,
      'figure': activeOrders,
      'title': "Active orders",
      'description': '$dueThisWeek due this week',
      'percentage': 68,
      'color': AppColor.first,
    },
    {
      'id': 3,
      'figure': completedOrders,
      'title': "Total Clients",
      'description': 'Steadily be on time',
      'percentage': 96,
      'color': AppColor.success,
    },
    {
      'id': 4,
      'figure': pending,
      'title': "Total Clients",
      'description': 'awaiting deposit',
      'percentage': 32,
      'color': AppColor.secondary,
    },
  ];

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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: summaryDetails.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.5,
                        ),
                        itemBuilder: (context, index) {
                          final items = summaryDetails[index];
                          return buildStatsCard(
                            value: '${items['figure']}',
                            title: items['title'],
                            subtitle: items['description']?.toString() ?? '',
                            progress: (items['percentage'] as num).toDouble(),
                            progressColor: items['color'] as Color,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const CreateBtnPopup(),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todayDate,
                style: AppFonts.label(
                  color: AppColor.grey.withValues(alpha: .5),
                ),
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const SkeletonBox(height: 20, width: 160)
                  : Text(
                      "Welcome, ${_profile?.fullName?.split(' ').first ?? 'Tailor'}",
                      style: AppFonts.heading(color: AppColor.text),
                    ),
              const SizedBox(height: 5),
              Text(
                "what are we sketching today?",
                style: AppFonts.body(color: AppColor.grey),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color: AppColor.grey.withValues(alpha: .2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.first.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 20,
              color: AppColor.text,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
                color: AppColor.primary.withValues(alpha: .28),
              ),
            ),
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                gradient: AppGradient.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
                child: Center(
                child: Text(
                  getInitials(_profile?.fullName ?? ''),
                  style: AppFonts.bodyLarge(color: AppColor.background),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column summaryCards() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Studio at a glance",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'CormorantGaramond',
            fontVariations: [FontVariation('wght', 500)],
            color: AppColor.text,
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return Container();
          },
        ),
      ],
    );
  }

  Widget buildStatsCard({
    required String value,
    required String title,
    required String? subtitle,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.grey.withValues(alpha: .15)),
        borderRadius: BorderRadius.circular(14),
        color: AppColor.plainWhite,
        boxShadow: [
          BoxShadow(
            color: AppColor.first.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'CormorantGarmond',
                  fontVariations: [FontVariation('wght', 500)],
                  color: AppColor.text,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'DMSANS',
                  fontVariations: [FontVariation('wght', 700)],
                  color: AppColor.text,
                ),
              ),
              Text(
                subtitle ?? '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'DMSANS',
                  fontVariations: [FontVariation('wght', 400)],
                  color: AppColor.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 8.0,
            color: progressColor,
          ),
        ],
      ),
    );
  }
}

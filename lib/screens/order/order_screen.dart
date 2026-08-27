import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/screens/order/new_orders.dart';
import 'package:tailorhub/services/order_service.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:tailorhub/widgets/empty_state.dart';
import 'package:tailorhub/widgets/null_serach.dart';
import 'package:tailorhub/widgets/order_container.dart';
import 'package:intl/intl.dart';
import 'package:tailorhub/widgets/quickaction.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderService _orderService = OrderService();
  final TextEditingController _searchController = TextEditingController();

  List<Order> orders = [];
  List<Order> filteredOrders = [];

  bool isLoading = true;
  String? errorMessage;

  String selectedFilter = 'All';
  bool showQuickActions = false;

  final List<String> filters = [
    'All',
    'Active',
    'Due soon',
    'Ready',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _orderService.getAllOrders();

      if (!mounted) return;

      setState(() {
        orders = result;
        filteredOrders = Order.latestFirst(result);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load orders';
        isLoading = false;
      });

      debugPrint('$e');
    }
  }

  void applyFilter() {
    List<Order> result = List.from(orders);

    //              SEARCH
    final query = _searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((order) {
        return order.orderName.toLowerCase().contains(query) ||
            order.orderId.toLowerCase().contains(query) ||
            order.clientName.toLowerCase().contains(query);
      }).toList();
    }

    //            FILTER
    switch (selectedFilter) {
      case 'Active':
        result = result.where((orders) {
          return orders.status.toLowerCase() != 'delivered';
        }).toList();
        break;

      case 'Ready':
        result = result.where((orders) {
          return orders.status.toLowerCase() == 'ready';
        }).toList();
        break;

      case 'Delivered':
        result = result.where((orders) {
          return orders.status.toLowerCase() == 'delivered';
        }).toList();
        break;

      case 'Due soon':
        final today = DateTime.now();

        final currentDate = DateTime(today.year, today.month, today.day);

        result = result.where((orders) {
          final deadline = DateTime(
            orders.deadline.year,
            orders.deadline.month,
            orders.deadline.day,
          );

          final daysRemaining = deadline.difference(currentDate).inDays;

          return daysRemaining >= 0 && daysRemaining <= 2;
        }).toList();
        break;

      case 'All':
        break;
    }
    setState(() {
      filteredOrders = Order.latestFirst(result);
    });
  }

  double get outstandingAmount {
    return orders
        .where((order) => order.status.toLowerCase() != 'delivered')
        .fold(0.0, (total, order) => total + order.orderPrice);
  }

  String get formattedOutstanding {
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    ).format(outstandingAmount);
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Custombg(
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(child: buildOrderContent()),
                  Positioned(top: 0, left: 0, right: 0, child: buildHeader()),
                ],
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

  Widget buildOrderContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, style: AppFonts.body(color: AppColor.grey)),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sync, size: 20, color: AppColor.background),
                  SizedBox(width: 5),
                  Text(
                    "Retry",
                    style: AppFonts.buttonText(color: AppColor.background),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (orders.isEmpty) {
      return EmptyState(
        title: "No orders yet",
        subTitle: "Create new orders to appear here",
        buttonText: "New Order",
      );
    }
    if (filteredOrders.isEmpty) {
      return NullSerach();
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 200, left: 8, right: 8, bottom: 20),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OrderContainer(order: order),
        );
      },
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.first.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Orders", style: AppFonts.heading(color: AppColor.text)),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: formattedOutstanding,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'DMSANS',
                    fontVariations: [FontVariation('wght', 700)],
                    color: AppColor.text,
                  ),
                ),
                TextSpan(
                  text: " Outstanding",
                  style: AppFonts.body(color: AppColor.text),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            hintText: "Search orders & references",
            prefix: Icons.search,
            controller: _searchController,
            onchanged: (_) {
              applyFilter();
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          buildFilters(),
        ],
      ),
    );
  }

  Widget buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
                applyFilter();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.first : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColor.grey.withValues(alpha: .2),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.first.withValues(alpha: 0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: AppFonts.body(
                    color: isSelected ? AppColor.background : AppColor.text,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

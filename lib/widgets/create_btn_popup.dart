import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/screens/client/new_client.dart';
import 'package:tailorhub/screens/order/new_orders.dart';
import 'package:tailorhub/widgets/quickaction.dart';

class CreateBtnPopup extends StatefulWidget {
  const CreateBtnPopup({super.key});

  @override
  State<CreateBtnPopup> createState() => _CreateBtnPopupState();
}

class _CreateBtnPopupState extends State<CreateBtnPopup> {
  bool showQuickActions = false;

  void _toggleQuickActions() {
    setState(() {
      showQuickActions = !showQuickActions;
    });
  }

  void _openNewOrder(BuildContext context) {
    setState(() {
      showQuickActions = false;
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const NewOrders();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  void _openNewClient(BuildContext context) {
    setState(() {
      showQuickActions = false;
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const NewClient();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        quickAction(
          icon: Icons.cut,
          title: 'New order',
          description: 'Start a garment from an existing template',
          onTap: () => _openNewOrder(context),
        ),
        const SizedBox(height: 10),
        quickAction(
          icon: Icons.person_add,
          title: 'New Client',
          description: 'Add a new client to your list',
          onTap: () => _openNewClient(context),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _toggleQuickActions,
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
    return Stack(
      children: [
        if (showQuickActions)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleQuickActions,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: Container(color: Colors.black.withOpacity(0.12)),
              ),
            ),
          ),
        Positioned(
          bottom: 35,
          left: 260,
          right: 0,
          child: Center(child: _buildAddButton()),
        ),
        if (showQuickActions)
          Positioned(bottom: 105, right: 20, child: _buildQuickAction(context)),
      ],
    );
  }
}

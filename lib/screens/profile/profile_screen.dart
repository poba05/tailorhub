import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/profile.dart';
import 'package:tailorhub/screens/client/client_screen.dart';
import 'package:tailorhub/screens/order/order_screen.dart';
import 'package:tailorhub/screens/template/template_screen.dart';
import 'package:tailorhub/services/profile_service.dart';
import 'package:tailorhub/utils/name_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  Profile? _profile;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    fetchProfile();
    super.initState();
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final profile = await _profileService.getCurrentProfile();
      setState(() {
        _profile = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load profile. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const name = 'Your Name';
    const studio = 'Your Studio';
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Studio profile',
                    style: AppFonts.heading(color: AppColor.text),
                  ),
                ),
                IconButton(
                  tooltip: 'Settings',
                  onPressed: () =>
                      _showNotice(context, 'Settings will be connected soon.'),
                  icon: const Icon(Icons.tune_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppGradient.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.first.withValues(alpha: .22),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withValues(alpha: .18),
                        child: Text(
                          getInitials(_profile?.fullName ?? name),
                          style: AppFonts.heading(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .16),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'FREE PLAN',
                          style: AppFonts.label(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _profile?.fullName ?? name,
                    style: AppFonts.heading(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _profile?.businessName ?? studio,
                    style: AppFonts.bodyLarge(
                      color: Colors.white.withValues(alpha: .82),
                    ),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: () => _showNotice(
                      context,
                      'Profile editing will be connected to your profile service.',
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Edit profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: .55),
                      ),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('YOUR WORKSPACE'),
            const SizedBox(height: 10),
            _summaryCard(),
            const SizedBox(height: 24),
            _sectionTitle('PREFERENCES'),
            const SizedBox(height: 10),
            _menuCard(context),
            const SizedBox(height: 22),
            Center(
              child: Text(
                'TailorHub · Made for the work you do',
                style: AppFonts.body(color: AppColor.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) =>
      Text(title, style: AppFonts.label(color: AppColor.grey));

  Widget _summaryCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: _cardDecoration(),
    child: Column(
      children: [
        _summaryRow(
          Icons.people_outline_rounded,
          'Client book',
          'Your client list and contact details',
          () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const ClientScreen();
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
        const Divider(height: 24),
        _summaryRow(
          Icons.cut_rounded,
          'Orders',
          'Track fittings, deadlines and progress',
          () {
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
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
              ),
            );
          },
        ),
        const Divider(height: 24),
        _summaryRow(
          Icons.straighten_rounded,
          'Measurement library',
          'Manage reusable garment measurements',
          () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const TemplateScreen();
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
      ],
    ),
  );

  Widget _summaryRow(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) => Row(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColor.tertiary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColor.first),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppFonts.bodyLarge(color: AppColor.text)),
            Text(subtitle, style: AppFonts.body(color: AppColor.grey)),
          ],
        ),
      ),
      Icon(Icons.chevron_right_rounded, color: AppColor.grey),
    ],
  );

  Widget _menuCard(BuildContext context) => Container(
    decoration: _cardDecoration(),
    child: Column(
      children: [
        _menuItem(
          context,
          Icons.notifications_none_rounded,
          'Notifications',
          'Reminders and updates',
        ),
        const Divider(height: 1, indent: 64),
        _menuItem(
          context,
          Icons.help_outline_rounded,
          'Help and support',
          'Get help using TailorHub',
        ),
        const Divider(height: 1, indent: 64),
        _menuItem(
          context,
          Icons.lock_outline_rounded,
          'Privacy and security',
          'Account and data controls',
        ),
        const Divider(height: 1, indent: 64),
        _menuItem(
          context,
          Icons.logout_rounded,
          'Sign out',
          'End your current session',
          danger: true,
        ),
      ],
    ),
  );

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    bool danger = false,
  }) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Icon(icon, color: danger ? AppColor.error : AppColor.first),
    title: Text(
      title,
      style: AppFonts.bodyLarge(color: danger ? AppColor.error : AppColor.text),
    ),
    subtitle: Text(subtitle, style: AppFonts.body(color: AppColor.grey)),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: () =>
        _showNotice(context, '$title will be connected to your account flow.'),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: AppColor.grey.withValues(alpha: .16)),
    boxShadow: [
      BoxShadow(
        color: AppColor.first.withValues(alpha: .045),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  void _showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

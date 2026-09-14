import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/clients_category.dart';
import 'package:tailorhub/services/client_services.dart';
import 'package:tailorhub/utils/name_utils.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';

class NewClient extends StatefulWidget {
  const NewClient({super.key});

  @override
  State<NewClient> createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  final ClientServices _clientServices = ClientServices();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  ClientsCategory selectedCategory = ClientsCategory.newClient;

  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> saveClient() async {
    final name = nameController.text.trim();
    final phoneNo = phoneNumberController.text.trim();
    final emailAdd = emailController.text.trim();
    final location = locationController.text.trim();

    if (name.isEmpty || phoneNo.isEmpty) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _clientServices.createNewClient(
        name: name,
        phone: phoneNo,
        location: location.isEmpty ? null : location,
        email: emailAdd.isEmpty ? null : emailAdd,
        category: selectedCategory.name,
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error creating client: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save client')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 108, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDisplayCard(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DottedLine(
                          dashColor: AppColor.grey.withValues(alpha: 0.45),
                          dashGapLength: 4,
                          dashLength: 6,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Details',
                          style: AppFonts.label(color: AppColor.grey),
                        ),
                      ),
                      Expanded(
                        child: DottedLine(
                          dashColor: AppColor.grey.withValues(alpha: 0.45),
                          dashGapLength: 4,
                          dashLength: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  buildDetailsCard(),
                  const SizedBox(height: 18),
                  buildLocationCard(),
                  const SizedBox(height: 18),
                  buildRelationshipCard(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
              decoration: BoxDecoration(
                color: AppColor.plainWhite,
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.grey.withValues(alpha: 0.18),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.first.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: AppColor.plainWhite,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.grey.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Client',
                          style: AppFonts.bodyLarge(color: AppColor.text),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Name and number are all you need to start',
                          style: AppFonts.body(color: AppColor.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: AppColor.first.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_add_outlined,
                      size: 20,
                      color: AppColor.first,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              decoration: BoxDecoration(
                color: AppColor.plainWhite,
                border: Border(
                  top: BorderSide(color: AppColor.grey.withValues(alpha: 0.18)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.first.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    onPressed: saveClient,
                    child: Text(
                      'Save Client',
                      style: AppFonts.buttonText(color: AppColor.background),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a name and phone number to save',
                    style: AppFonts.body(color: AppColor.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDisplayCard() {
    final name = nameController.text.trim();
    final phoneNo = phoneNumberController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        border: Border.all(color: AppColor.grey.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColor.first.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: AppColor.first,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColor.first.withValues(alpha: 0.24),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              getInitials(name.isEmpty ? '__' : name),
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'DMSANS',
                fontVariations: [FontVariation('wght', 700)],
                color: AppColor.plainWhite,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Client profile',
                  style: AppFonts.label(color: AppColor.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  name.isEmpty ? 'Client Name' : name,
                  style: AppFonts.heading(color: AppColor.text),
                ),
                const SizedBox(height: 6),
                Text(
                  phoneNo.isEmpty ? 'Phone number' : phoneNo,
                  style: AppFonts.bodyLarge(color: AppColor.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        border: Border.all(color: AppColor.grey.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColor.first.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 20,
                  color: AppColor.first,
                ),
              ),
              const SizedBox(width: 10),
              Text('Who they are', style: AppFonts.label(color: AppColor.grey)),
            ],
          ),
          const SizedBox(height: 18),
          Text('Full name', style: AppFonts.label(color: AppColor.grey)),
          const SizedBox(height: 8),
          CustomTextfield(
            hintText: 'e.g. Zainab Oyeleran',
            prefix: Icons.person_outline,
            controller: nameController,
            onchanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 14),
          Text('Phone number', style: AppFonts.label(color: AppColor.grey)),
          const SizedBox(height: 8),
          CustomTextfield(
            hintText: '+234 800 000 0000',
            prefix: Icons.phone_outlined,
            controller: phoneNumberController,
            onchanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 14),
          Text('Email (optional)', style: AppFonts.label(color: AppColor.grey)),
          const SizedBox(height: 8),
          CustomTextfield(
            hintText: 'name@email.com',
            prefix: Icons.mail_outline,
            controller: emailController,
            onchanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        border: Border.all(color: AppColor.grey.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColor.first.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: AppColor.first,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Where to find them',
                style: AppFonts.label(color: AppColor.grey),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Address', style: AppFonts.label(color: AppColor.grey)),
          const SizedBox(height: 8),
          CustomTextfield(
            hintText: 'Street, Area, City',
            prefix: Icons.location_on_outlined,
            controller: locationController,
            onchanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildRelationshipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        border: Border.all(color: AppColor.grey.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColor.first.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.flare_outlined,
                  size: 20,
                  color: AppColor.first,
                ),
              ),
              const SizedBox(width: 10),
              Text('Relationship', style: AppFonts.label(color: AppColor.grey)),
            ],
          ),
          const SizedBox(height: 18),
          Text('Client tier', style: AppFonts.label(color: AppColor.grey)),
          const SizedBox(height: 10),
          buildCategoryOptions(
            category: ClientsCategory.newClient,
            title: 'New',
            description: 'First garment with you',
          ),
          const SizedBox(height: 8),
          buildCategoryOptions(
            category: ClientsCategory.regularClient,
            title: 'Regular',
            description: 'Returns throughout the year',
          ),
          const SizedBox(height: 8),
          buildCategoryOptions(
            category: ClientsCategory.vipClient,
            title: 'VIP',
            description: 'Priority in the workroom',
          ),
        ],
      ),
    );
  }

  Widget buildCategoryOptions({
    required ClientsCategory category,
    required String title,
    required String description,
  }) {
    final bool isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.first.withValues(alpha: 0.08)
              : AppColor.background,
          border: Border.all(
            color: isSelected
                ? AppColor.first.withValues(alpha: 0.4)
                : AppColor.grey.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.first : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColor.first.withValues(alpha: 0.5)
                      : AppColor.grey.withValues(alpha: 0.4),
                ),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: AppColor.plainWhite,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppFonts.bodyLarge(color: AppColor.text)),
                  const SizedBox(height: 2),
                  Text(description, style: AppFonts.body(color: AppColor.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Build the remaining cards and also connect them to the database, then create the bottom navigation//

import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/clients_category.dart';
import 'package:tailorhub/services/client_services.dart';
import 'package:tailorhub/widgets/client_container.dart';
import 'package:tailorhub/widgets/create_btn_popup.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:tailorhub/widgets/empty_state.dart';
import 'package:tailorhub/widgets/null_serach.dart';
import 'package:tailorhub/widgets/skeleton_box.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final ClientServices _clientService = ClientServices();
  final TextEditingController _searchController = TextEditingController();

  List<Clients> clients = [];
  List<Clients> filteredClients = [];

  bool isLoading = true;
  String? errorMessage;

  String selectedFilter = 'All';

  final List<String> filters = ['All', 'VIP', 'Regular', 'New', 'Dormant'];

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadClients() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _clientService.getclients();

      if (!mounted) return;

      setState(() {
        clients = result;
        filteredClients = Clients.latestFirst(result);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to Load Clients. Please try again later.';
        isLoading = false;
      });

      debugPrint('Error loading clients: $e');
    }
  }

  void applyFilter() {
    List<Clients> result = List.from(clients);
    final query = _searchController.text.trim().toLowerCase().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((client) {
        return client.name.toLowerCase().contains(query) ||
            client.email!.toLowerCase().contains(query) ||
            client.phone!.toLowerCase().contains(query);
      }).toList();
    }

    switch (selectedFilter) {
      case 'VIP':
        result = result
            .where((client) => client.category == ClientsCategory.vipClient)
            .toList();
        break;
      case 'Regular':
        result = result
            .where((client) => client.category == ClientsCategory.regularClient)
            .toList();
        break;
      case 'New':
        result = result
            .where((client) => client.category == ClientsCategory.newClient)
            .toList();
        break;
      case 'Dormant':
        result = result
            .where((client) => client.category == ClientsCategory.dormantCLient)
            .toList();
        break;
      case 'All':
      default:
        break;
    }

    setState(() {
      filteredClients = Clients.latestFirst(result);
    });
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
                  Positioned.fill(child: buildClientContent()),
                  Positioned(top: 0, left: 0, right: 0, child: buildHeader()),
                ],
              ),
            ),
          ),
          const CreateBtnPopup(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
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
        crossAxisAlignment: .start,
        children: [
          Text("Clients", style: AppFonts.heading(color: AppColor.text)),
          const SizedBox(height: 5),
          Text(
            "${filteredClients.length} of ${clients.length} clients",
            style: AppFonts.body(color: AppColor.grey),
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            hintText: "Search Clients",
            prefix: Icons.person_search_outlined,
            controller: _searchController,
            onchanged: (_) {
              applyFilter();
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
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
            padding: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                  applyFilter();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.first : AppColor.plainWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColor.grey.withValues(alpha: .2),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.first.withValues(alpha: 0.18),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: AppFonts.body(
                    color: isSelected ? AppColor.plainWhite : AppColor.text,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildClientContent() {
    if (isLoading) {
      return Column(
        children: List.generate(
          4,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SkeletonBox(height: 80, borderRadius: 16),
          ),
        ),
      );
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(errorMessage!, style: AppFonts.body(color: AppColor.grey)),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: .center,
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
    if (clients.isEmpty) {
      return EmptyState(
        title: "No clients yet",
        subTitle: "Create Clients to appear here",
        buttonText: 'New Client',
      );
    }
    if (filteredClients.isEmpty) {
      return NullSerach();
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 300, left: 8, right: 8, bottom: 20),
      itemCount: filteredClients.length,
      itemBuilder: (context, index) {
        final client = filteredClients[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ClientContainer(client: client),
        );
      },
    );
  }
}

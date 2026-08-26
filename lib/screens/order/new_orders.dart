import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/new_order_data.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/services/client_services.dart';
import 'package:tailorhub/services/order_service.dart';
import 'package:tailorhub/utils/name_utils.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';
import 'package:tailorhub/widgets/empty_state.dart';
import 'package:tailorhub/widgets/step_progress_indicator.dart';

class NewOrders extends StatefulWidget {
  const NewOrders({super.key});

  @override
  State<NewOrders> createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  final NewOrderData orderData = NewOrderData();

  int currentStep = 0;
  int totalSteps = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: SafeArea(child: Column(children: [buildCurrentStep()])),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                color: AppColor.background,
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.grey.withValues(alpha: .3),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (currentStep > 0) {
                            setState(() {
                              currentStep--;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.grey.withValues(alpha: .4),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: AppColor.text,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New Order",
                            style: AppFonts.label(color: AppColor.text),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Step $currentStep of $totalSteps",
                            style: AppFonts.body(color: AppColor.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.first.withValues(alpha: .3),
                        ),
                        child: Icon(
                          Icons.cut,
                          size: 20,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  StepProgressIndicator(
                    currentStep: currentStep,
                    totalSteps: totalSteps,
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
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.background,
                border: Border(
                  top: BorderSide(color: AppColor.grey.withValues(alpha: .3)),
                ),
              ),
              child: Column(
                children: [
                  CustomButton(
                    onPressed: () {
                      if (currentStep < 3) {
                        currentStep++;
                      } else {}
                    },
                    child: currentStep == 3
                        ? Text(
                            "Create Order",
                            style: AppFonts.buttonText(
                              color: AppColor.background,
                            ),
                          )
                        : Text(
                            "Continue",
                            style: AppFonts.buttonText(
                              color: AppColor.background,
                            ),
                          ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Select or add a client to continue",
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

  Widget buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return ClientStep(
          selectedClient: orderData.clients,
          onClientSelected: (client) {
            setState(() {
              orderData.clients = client;
            });
          },
        );
      case 1:
        return GarmentStep(
          selectedGarment: orderData.garmentType,
          onGarmentSelected: (garment) {
            setState(() {
              orderData.garmentType = garment;
            });
          },
        );
      case 2:
        return DetailsStep(
          deadline: orderData.deadline,
          deposit: orderData.deposit,
          isRush: orderData.isRush,
          total: orderData.total,

          onDeadlineChanged: (date) {
            setState(() {
              orderData.deadline = date;
            });
          },
          onRushChanged: (value) {
            setState(() {
              orderData.isRush = value;
            });
          },
          onDepositChanged: (value) {
            setState(() {
              orderData.deposit = value;
            });
          },
          onTotalChanged: (value) {
            setState(() {
              orderData.total = value;
            });
          },
        );
      case 3:
        return ReviewStep(orderData: orderData);
      default:
        return const SizedBox.shrink();
    }
  }
}

class ClientStep extends StatefulWidget {
  final Clients? selectedClient;
  final ValueChanged<Clients> onClientSelected;
  const ClientStep({
    super.key,
    required this.selectedClient,
    required this.onClientSelected,
  });

  @override
  State<ClientStep> createState() => _ClientStepState();
}

class _ClientStepState extends State<ClientStep> {
  final ClientServices _clientServices = ClientServices();
  final OrderService _orderService = OrderService();

  List<Clients> clients = [];
  List<Order> orders = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadClients();
    loadOrders();
  }

  Future<void> loadClients() async {
    try {
      final result = await _clientServices.getclients();

      if (!mounted) return;

      setState(() {
        clients = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load clients';
        isLoading = false;
      });

      debugPrint('$e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 105, left: 8, right: 8, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Who is this for?",
            style: AppFonts.label(color: AppColor.error),
          ),
          SizedBox(height: 10),
          Text(
            "Connect a client",
            style: AppFonts.heading(color: AppColor.text),
          ),
          SizedBox(height: 10),
          Text(
            "Pick someone from your book — their\nmeasurements and history come with them.",
            style: AppFonts.body(color: AppColor.grey),
          ),
          SizedBox(height: 30),
          CustomTextfield(
            hintText: "Search your client book",
            prefix: Icons.search,
          ),
          SizedBox(height: 10),
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: AppColor.first,
              strokeWidth: 1.5,
              dashPattern: [6, 4],
              radius: Radius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.first.withValues(alpha: .4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColor.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person_add,
                      size: 20,
                      color: AppColor.primary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New client",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "DMSANS",
                          fontVariations: [FontVariation('wght', 700)],
                          color: AppColor.primary,
                        ),
                      ),
                      Text(
                        "Capture a name and number now, details later",
                        style: AppFonts.body(
                          color: AppColor.first.withValues(alpha: .4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "------------------",
                  style: AppFonts.body(color: AppColor.grey),
                ),
                Flexible(
                  child: Text(
                    " ${clients.length} in your book ",
                    textAlign: TextAlign.center,
                    style: AppFonts.bodyLarge(color: AppColor.grey),
                  ),
                ),
                Text(
                  "------------------",
                  style: AppFonts.body(color: AppColor.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    errorMessage!,
                    style: AppFonts.body(color: AppColor.grey),
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sync, size: 20, color: AppColor.background),
                        SizedBox(width: 5),
                        Text(
                          "Retry",
                          style: AppFonts.buttonText(
                            color: AppColor.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (clients.isEmpty)
            const EmptyState(
              title: "No Clients yet",
              subTitle: "Add new clients to create order",
              buttonText: "New Client",
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: clients.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: buildClientCard(clients[index]),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget buildClientCard(Clients client) {
    final isSelected = widget.selectedClient?.id == client.id;
    final orderCount = _orderService.getClientOrderCount(client.id);

    return GestureDetector(
      onTap: () {
        widget.onClientSelected(client);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColor.first
                : AppColor.grey.withValues(alpha: .5),
          ),
        ),
        child: Row(
          children: [
            Container(
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
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    width: 2,
                    color: AppColor.first.withValues(alpha: .6),
                  ),
                ),
                child: Center(
                  child: Text(
                    getInitials(client.name),
                    style: AppFonts.bodyLarge(color: AppColor.background),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "DMSANS",
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.text,
                    ),
                  ),
                  FutureBuilder<int>(
                    future: _orderService.getClientOrderCount(client.id),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return Text(
                        "${client.phone} • $count",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.body(color: AppColor.grey),
                      );
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColor.primary : AppColor.grey,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GarmentStep extends StatelessWidget {
  final String? selectedGarment;
  final ValueChanged<String> onGarmentSelected;
  const GarmentStep({
    super.key,
    required this.selectedGarment,
    required this.onGarmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Garment ui
    return Column();
  }
}

class DetailsStep extends StatelessWidget {
  final DateTime? deadline;
  final bool isRush;
  final double total;
  final double deposit;

  final ValueChanged<DateTime> onDeadlineChanged;
  final ValueChanged<bool> onRushChanged;
  final ValueChanged<double> onTotalChanged;
  final ValueChanged<double> onDepositChanged;
  const DetailsStep({
    super.key,
    required this.deadline,
    required this.isRush,
    required this.total,
    required this.deposit,
    required this.onDeadlineChanged,
    required this.onRushChanged,
    required this.onTotalChanged,
    required this.onDepositChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Details ui
    return Column();
  }
}

class ReviewStep extends StatelessWidget {
  final NewOrderData orderData;
  const ReviewStep({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    // review ui
    return Column();
  }
}

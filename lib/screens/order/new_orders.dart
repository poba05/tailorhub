import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/garment_type.dart';
import 'package:tailorhub/models/new_order_data.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/services/client_services.dart';
import 'package:tailorhub/services/garmenttype_service.dart';
import 'package:tailorhub/services/order_service.dart';
import 'package:tailorhub/utils/name_utils.dart';
import 'package:tailorhub/widgets/color_circle.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';
import 'package:tailorhub/widgets/delivery_date_picker.dart';
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
              padding: const EdgeInsets.only(bottom: 80),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [buildCurrentStep()],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.grey.withValues(alpha: .18),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.first.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
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
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: AppColor.grey.withValues(alpha: .25),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: AppColor.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New Order",
                            style: AppFonts.label(color: AppColor.text),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Step $currentStep of $totalSteps",
                            style: AppFonts.body(color: AppColor.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradient.primaryGradient,
                        ),
                        child: Icon(
                          Icons.cut,
                          size: 20,
                          color: AppColor.background,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColor.grey.withValues(alpha: .18)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.first.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomButton(
                    onPressed: () {
                      if (currentStep < 3) {
                        setState(() {
                          currentStep++;
                        });
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
                  const SizedBox(height: 6),
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
          selectedGarment: orderData.garment,
          onGarmentSelected: (garment) {
            setState(() {
              orderData.garment = garment;
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
  final ValueChanged<Clients?> onClientSelected;
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
          buildSelectedClient(),
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

    return GestureDetector(
      onTap: () {
        widget.onClientSelected(client);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColor.first
                : AppColor.grey.withValues(alpha: .5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withValues(alpha: .2),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                gradient: AppGradient.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  getInitials(client.name),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "DMSANS",
                    fontVariations: [FontVariation('wght', 700)],
                    color: AppColor.background,
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
              child: isSelected
                  ? Icon(Icons.check, size: 10, color: AppColor.background)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedClient() {
    final client = widget.selectedClient;

    if (client == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppGradient.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColor.grey.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                getInitials(client.name),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "DMSANS",
                  fontVariations: [FontVariation('wght', 700)],
                  color: AppColor.background,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "order for".toUpperCase(),
                style: AppFonts.label(
                  color: AppColor.grey.withValues(alpha: .5),
                ),
              ),
              Text(
                client.name,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "DMSANS",
                  fontVariations: [FontVariation('wght', 700)],
                  color: AppColor.background,
                ),
              ),
              Text(
                '${client.phone}',
                style: AppFonts.body(
                  color: AppColor.grey.withValues(alpha: .5),
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.onClientSelected(null);
              });
            },
            child: Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                color: AppColor.grey.withValues(alpha: .3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 20,
                color: AppColor.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GarmentStep extends StatefulWidget {
  final GarmentType? selectedGarment;
  final ValueChanged<GarmentType> onGarmentSelected;

  const GarmentStep({
    super.key,
    required this.selectedGarment,
    required this.onGarmentSelected,
  });

  @override
  State<GarmentStep> createState() => _GarmentStepState();
}

class _GarmentStepState extends State<GarmentStep> {
  final GarmenttypeService _garmenttypeService = GarmenttypeService();

  List<GarmentType> garmentType = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadGarmentTypes();
  }

  Future<void> loadGarmentTypes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _garmenttypeService.getGarmentType();

      if (!mounted) return;

      setState(() {
        garmentType = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load Garments';
        isLoading = false;
      });
      debugPrint('Garment Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 105, left: 8, right: 8, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are we making?'.toUpperCase(),
            style: AppFonts.label(color: AppColor.error),
          ),
          const SizedBox(height: 10),
          Text(
            'Choose the garment',
            style: AppFonts.heading(color: AppColor.text),
          ),
          const SizedBox(height: 10),
          Text(
            'Starting from a template pre-fills the\nmeasurement sheet for this order.',
            style: AppFonts.body(color: AppColor.grey),
          ),
          const SizedBox(height: 30),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(
              child: Text(
                errorMessage!,
                style: AppFonts.body(color: AppColor.grey),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: garmentType.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                return buildGarmentType(garmentType[index]);
              },
            ),

          SizedBox(height: 20),
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
                    "  Order name  ",
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
          CustomTextfield(prefix: Icons.title, hintText: "e.g pink silk suit"),
        ],
      ),
    );
  }

  Widget buildGarmentType(GarmentType garmentType) {
    final isSelected = widget.selectedGarment?.id == garmentType.id;

    return GestureDetector(
      onTap: () {
        widget.onGarmentSelected(garmentType);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.plainWhite,
          border: Border.all(
            color: isSelected
                ? AppColor.primary
                : AppColor.grey.withValues(alpha: .3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withValues(alpha: .5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    gradient: AppGradient.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      getInitials(garmentType.name),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'DMSANS',
                        fontVariations: [FontVariation('wght', 700)],
                        color: AppColor.plainWhite,
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              garmentType.name,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'DMSANS',
                fontVariations: [FontVariation('wght', 700)],
                color: AppColor.text,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              garmentType.description ?? '',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'DMSANS',
                fontVariations: [FontVariation('wght', 300)],
                color: AppColor.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsStep extends StatefulWidget {
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
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  final fabricNameController = TextEditingController();
  final totalAmountController = TextEditingController();
  final balanceAmountController = TextEditingController();

  Color? selectedColor;

  final List<Color> colors = [
    AppColor.error,
    AppColor.warning,
    AppColor.grey,
    AppColor.text,
    AppColor.success,
  ];

  @override
  void dispose() {
    super.dispose();
    fabricNameController.dispose();
    totalAmountController.dispose();
    balanceAmountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Details ui
    return Padding(
      padding: const EdgeInsets.only(top: 105, left: 8, right: 8, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "when and how much".toUpperCase(),
            style: AppFonts.label(color: AppColor.error),
          ),
          SizedBox(height: 10),
          Text(
            "Schedule & payment",
            style: AppFonts.heading(color: AppColor.text),
          ),
          SizedBox(height: 10),
          Text(
            "Set the collection date and record what the\nclient is paying today.",
            style: AppFonts.body(color: AppColor.grey),
          ),
          SizedBox(height: 30),
          DeliveryDatePicker(
            selectedDate: widget.deadline,
            isRush: widget.isRush,
            onDateSelected: widget.onDeadlineChanged,
            onRushChanged: widget.onRushChanged,
          ),
          SizedBox(height: 10),
          buildDetailFabricInfo(),
          SizedBox(height: 10),
          buildPaymentfee(),
        ],
      ),
    );
  }

  Widget buildDetailFabricInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.grey.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .start,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColor.first.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.dry_cleaning, color: AppColor.first),
              ),
              SizedBox(width: 10),
              Text("Fabric", style: AppFonts.label(color: AppColor.grey)),
            ],
          ),
          SizedBox(height: 10),
          CustomTextfield(
            controller: fabricNameController,
            prefix: Icons.title,
            hintText: "Fabric name e.g. Duchess satin",
          ),
          SizedBox(height: 20),
          Row(
            children: [
              ...colors.map(
                (color) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: ColorCircle(
                    color: color,
                    isSelected: selectedColor == color,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: .circle,
                    border: Border.all(
                      color: AppColor.grey.withValues(alpha: .3),
                    ),
                  ),
                  child: Icon(Icons.add, size: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentfee() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.grey.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColor.first.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.payment_outlined, color: AppColor.first),
              ),
              SizedBox(width: 10),
              Text("Payment", style: AppFonts.label(color: AppColor.grey)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: CustomTextfield(
                  controller: totalAmountController,
                  prefix: Icons.currency_exchange,
                  hintText: "total price",
                  label: "Total",
                ),
              ),
              Expanded(
                child: CustomTextfield(
                  controller: balanceAmountController,
                  prefix: Icons.currency_exchange,
                  hintText: "Amount Paid",
                  label: "Balance",
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

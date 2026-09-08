import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/garment_measurements.dart';
import 'package:tailorhub/models/garment_type.dart';
import 'package:tailorhub/models/new_order_data.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/services/client_services.dart';
import 'package:tailorhub/services/garment_measurement_services.dart';
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

  List<GarmentMeasurements> measurementDefinition = [];

  int currentStep = 0;
  int totalSteps = 5;

  bool isCreatingOrder = false;

  Future<void> createOrder() async {
    if (orderData.clients == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a client')));
      return;
    }
    if (orderData.garment == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a garment')));
      return;
    }
    if (orderData.orderName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an order name')),
      );
      return;
    }

    setState(() {
      isCreatingOrder = true;
    });

    try {
      debugPrint('================ CREATING ORDER ================');
      debugPrint('Client: ${orderData.clients!.name}');
      debugPrint('Garment: ${orderData.garment!.name}');
      debugPrint('Order Name: ${orderData.orderName}');
      debugPrint('Total: ${orderData.total}');
      debugPrint('deposit: ${orderData.deposit}');
      debugPrint('Measuremnts: ${orderData.measurements}');

      final orderId = await OrderService().createOrder(orderData);

      debugPrint('ORDER CREATED SUCCESSFULLY');
      debugPrint('Order id: $orderId');

      if (!mounted) return;

      setState(() {
        isCreatingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order created successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isCreatingOrder = false;
      });

      debugPrint('CREATE ORDER ERROR: $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create order: $e')));
    }
  }

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
                    onPressed: isCreatingOrder
                        ? null
                        : () {
                            if (currentStep < totalSteps - 1) {
                              setState(() {
                                currentStep++;
                              });
                            } else {
                              createOrder();
                            }
                          },
                    child: currentStep == 4
                        ? isCreatingOrder
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
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
          onOrderNameChanged: (name) {
            setState(() {
              orderData.orderName = name;
            });
          },
        );
      case 2:
        return MeasurementStep(
          garment: orderData.garment!,
          measurements: orderData.measurements,

          onMeasurementsChanged: (values) {
            setState(() {
              orderData.measurements = values;
            });
          },

          onMeasurementDefinitionsLoaded: (values) {
            setState(() {
              measurementDefinition = values;
            });
          },
        );
      case 3:
        return DetailsStep(
          deadline: orderData.deadline,
          deposit: orderData.deposit,
          isRush: orderData.isRush,
          total: orderData.total,
          fabricName: orderData.fabricName,
          fabricColor: orderData.fabricColor,
          notes: orderData.notes,

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
          onFabricNameChanged: (value) {
            setState(() {
              orderData.fabricName = value;
            });
          },
          onFabricColorChanged: (value) {
            setState(() {
              orderData.fabricColor = value;
            });
          },
          onNotesChanged: (value) {
            setState(() {
              orderData.notes = value.toString();
            });
          },
        );
      case 4:
        return ReviewStep(
          orderData: orderData,
          measurements: measurementDefinition,

          onBackToClient: () {
            setState(() {
              currentStep = 0;
            });
          },
        );
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
  final ValueChanged<String> onOrderNameChanged;

  const GarmentStep({
    super.key,
    required this.selectedGarment,
    required this.onGarmentSelected,
    required this.onOrderNameChanged,
  });

  @override
  State<GarmentStep> createState() => _GarmentStepState();
}

class _GarmentStepState extends State<GarmentStep> {
  final GarmenttypeService _garmenttypeService = GarmenttypeService();
  final orderNameController = TextEditingController();

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
  void dispose() {
    super.dispose();
    orderNameController.dispose();
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
          CustomTextfield(
            prefix: Icons.title,
            hintText: "e.g pink silk suit",
            controller: orderNameController,
            onchanged: widget.onOrderNameChanged,
          ),
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

class MeasurementStep extends StatefulWidget {
  final GarmentType garment;
  final Map<String, double> measurements;

  final ValueChanged<Map<String, double>> onMeasurementsChanged;

  final ValueChanged<List<GarmentMeasurements>> onMeasurementDefinitionsLoaded;

  const MeasurementStep({
    super.key,
    required this.garment,
    required this.measurements,
    required this.onMeasurementsChanged,
    required this.onMeasurementDefinitionsLoaded,
  });

  @override
  State<MeasurementStep> createState() => _MeasurementStepState();
}

class _MeasurementStepState extends State<MeasurementStep> {
  final GarmentMeasurementServices _measurementService =
      GarmentMeasurementServices();

  List<GarmentMeasurements> measurements = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadMeasurements();
  }

  Future<void> loadMeasurements() async {
    try {
      final result = await _measurementService.getMeasurements(
        widget.garment.id,
      );

      if (!mounted) return;

      widget.onMeasurementDefinitionsLoaded(result);

      final updatedMeasurements = Map<String, double>.from(widget.measurements);

      for (final measurement in result) {
        if (!updatedMeasurements.containsKey(measurement.id) &&
            measurement.defaultValue != null) {
          updatedMeasurements[measurement.id] = measurement.defaultValue!;
        }
      }

      widget.onMeasurementsChanged(updatedMeasurements);

      setState(() {
        measurements = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load measurements';
        isLoading = false;
      });

      debugPrint('Measurement Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 105, left: 8, right: 8, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TAKE MEASUREMENTS',
            style: AppFonts.label(color: AppColor.error),
          ),

          const SizedBox(height: 10),

          Text(
            '${widget.garment.name} measurements',
            style: AppFonts.heading(color: AppColor.text),
          ),

          const SizedBox(height: 10),

          Text(
            'Enter the client measurements for this garment.',
            style: AppFonts.body(color: AppColor.grey),
          ),

          const SizedBox(height: 25),

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
            buildMeasurementGroups(),

          const SizedBox(height: 25),

          Center(
            child: Text(
              '—  EVERY FIGURE IN "${measurements.isNotEmpty ? measurements.first.unit.toUpperCase() : 'IN'}"  —',
              style: AppFonts.body(color: AppColor.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMeasurementGroups() {
    final grouped = <String, List<GarmentMeasurements>>{};

    for (final measurement in measurements) {
      grouped.putIfAbsent(measurement.category, () => []);

      grouped[measurement.category]!.add(measurement);
    }

    return Column(
      children: grouped.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: buildMeasurementCard(
            category: entry.key,
            measurements: entry.value,
          ),
        );
      }).toList(),
    );
  }

  Widget buildMeasurementCard({
    required String category,
    required List<GarmentMeasurements> measurements,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColor.grey.withValues(alpha: .15)),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: .08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          buildCategoryHeader(category, measurements.length),

          const Divider(height: 1),

          ...measurements.map(
            (measurement) => buildMeasurementRow(measurement),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryHeader(String category, int count) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColor.first.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getCategoryIcon(category),
              size: 18,
              color: AppColor.first,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: AppFonts.label(color: AppColor.text)),

                const SizedBox(height: 2),

                Text(
                  '$count measurements',
                  style: AppFonts.body(color: AppColor.grey),
                ),
              ],
            ),
          ),

          Icon(Icons.more_horiz, size: 20, color: AppColor.grey),
        ],
      ),
    );
  }

  Widget buildMeasurementRow(GarmentMeasurements measurement) {
    final value = widget.measurements[measurement.id];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.grey.withValues(alpha: .04)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              measurement.name,
              style: TextStyle(
                fontSize: 14,
                fontFamily: "DMSANS",
                fontVariations: [FontVariation('wght', 400)],
                color: AppColor.text,
              ),
            ),
          ),

          Text(
            value == null ? '--' : value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 14,
              fontFamily: "DMSANS",
              fontVariations: [FontVariation('wght', 700)],
              color: AppColor.text,
            ),
          ),

          const SizedBox(width: 6),

          Text(measurement.unit, style: AppFonts.body(color: AppColor.grey)),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              editMeasurement(measurement);
            },
            child: Icon(Icons.edit_outlined, size: 17, color: AppColor.grey),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              copyMeasurement(measurement);
            },
            child: Icon(Icons.copy_outlined, size: 17, color: AppColor.grey),
          ),

          const SizedBox(width: 8),

          Icon(Icons.more_horiz, size: 18, color: AppColor.grey),
        ],
      ),
    );
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'upper body':
        return Icons.checkroom_outlined;

      case 'lower body':
        return Icons.swap_vert;

      case 'extra measurements':
        return Icons.auto_awesome;

      default:
        return Icons.straighten;
    }
  }

  void editMeasurement(GarmentMeasurements measurement) {
    final controller = TextEditingController(
      text: widget.measurements[measurement.id]?.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit measurement',
                  style: AppFonts.heading(color: AppColor.text),
                ),

                const SizedBox(height: 6),

                Text(
                  measurement.name,
                  style: AppFonts.body(color: AppColor.grey),
                ),

                const SizedBox(height: 20),

                CustomTextfield(
                  controller: controller,
                  hintText: 'Enter measurement',
                  prefix: Icons.straighten,
                ),

                const SizedBox(height: 20),

                CustomButton(
                  onPressed: () {
                    final value = double.tryParse(controller.text.trim());

                    if (value == null) return;

                    final updated = Map<String, double>.from(
                      widget.measurements,
                    );

                    updated[measurement.id] = value;

                    widget.onMeasurementsChanged(updated);

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save measurement',
                    style: AppFonts.buttonText(color: AppColor.background),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void copyMeasurement(GarmentMeasurements measurement) {
    // We'll implement this next.
  }
}

class DetailsStep extends StatefulWidget {
  final DateTime? deadline;
  final bool isRush;
  final double total;
  final double deposit;

  final String? fabricName;
  final String? fabricColor;
  final String? notes;

  final ValueChanged<DateTime> onDeadlineChanged;
  final ValueChanged<bool> onRushChanged;
  final ValueChanged<double> onTotalChanged;
  final ValueChanged<double> onDepositChanged;
  final ValueChanged<String?> onFabricNameChanged;
  final ValueChanged<String?> onFabricColorChanged;
  final ValueChanged<String?> onNotesChanged;
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
    required this.onFabricNameChanged,
    required this.onFabricColorChanged,
    required this.onNotesChanged,
    this.fabricName,
    this.fabricColor,
    this.notes,
  });

  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  final fabricNameController = TextEditingController();
  final totalAmountController = TextEditingController();
  final depositAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with incoming values so review shows correct amounts
    if (widget.total > 0) {
      totalAmountController.text = widget.total.toStringAsFixed(0);
    }

    if (widget.deposit > 0) {
      depositAmountController.text = widget.deposit.toStringAsFixed(0);
    }

    // Initialize fabric name & color from incoming values
    if (widget.fabricName != null && widget.fabricName!.isNotEmpty) {
      fabricNameController.text = widget.fabricName!;
    }

    selectedColor = parseHexColor(widget.fabricColor);
  }

  Color? selectedColor;

  Color? parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceFirst('#', '');
    try {
      final value = int.parse(cleaned, radix: 16);
      if (cleaned.length == 6) {
        return Color(0xFF000000 | value);
      } else if (cleaned.length == 8) {
        return Color(value);
      }
    } catch (_) {}
    return null;
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

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
    depositAmountController.dispose();
  }

  double _parseAmount(String value) {
    return double.tryParse(
          value.replaceAll(',', '').replaceAll('₦', '').trim(),
        ) ??
        0;
  }

  void _calculateDeposit(double percentage) {
    final total = _parseAmount(totalAmountController.text);

    if (total <= 0) return;

    final deposit = total * percentage;

    depositAmountController.text = deposit.toStringAsFixed(0);

    widget.onTotalChanged(total);
    widget.onDepositChanged(deposit);

    setState(() {});
  }

  void _updatDepositFromUser() {
    final total = _parseAmount(totalAmountController.text);
    final deposit = _parseAmount(depositAmountController.text);

    widget.onTotalChanged(total);
    widget.onDepositChanged(deposit);

    setState(() {});
  }

  double get balance {
    final total = _parseAmount(totalAmountController.text);
    final deposit = _parseAmount(depositAmountController.text);

    final result = total - deposit;

    return result < 0 ? 0 : result;
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
          SizedBox(height: 10),
          buildNotesDetail(),
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
            onchanged: (v) {
              widget.onFabricNameChanged(v);
            },
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
                    widget.onFabricColorChanged(colorToHex(color));
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
                  onchanged: (_) {
                    _updatDepositFromUser();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomTextfield(
                  controller: depositAmountController,
                  prefix: Icons.currency_exchange,
                  hintText: "Amount Paid",
                  label: "Deposit",
                  onchanged: (_) {
                    _updatDepositFromUser();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          buildDepositOptions(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Balance remains: ",
                style: AppFonts.body(color: AppColor.grey),
              ),
              Text(
                "₦${balance.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'DMSANS',
                  fontVariations: [FontVariation('wght', 700)],
                  color: balance == 0 ? AppColor.text : AppColor.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNotesDetail() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.grey.withValues(alpha: .3)),
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.note_outlined, color: AppColor.first),
              ),
              SizedBox(width: 10),
              Text("Notes", style: AppFonts.label(color: AppColor.grey)),
            ],
          ),
          SizedBox(height: 10),
          CustomTextfield(
            hintText: "Additional things to note",
            height: 50,
            onchanged: widget.onNotesChanged,
          ),
        ],
      ),
    );
  }

  Widget buildDepositOptions() {
    return Row(
      children: [
        Expanded(
          child: buildDepositOption(
            title: "25% Paid",
            onTap: () {
              _calculateDeposit(0.25);
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: buildDepositOption(
            title: "50% Paid",
            onTap: () {
              _calculateDeposit(0.50);
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: buildDepositOption(
            title: "Paid full",
            onTap: () {
              _calculateDeposit(1.0);
            },
          ),
        ),
      ],
    );
  }

  Widget buildDepositOption({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColor.first.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.first.withValues(alpha: .1)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'DMSANS',
            fontVariations: [FontVariation('wght', 700)],
            color: AppColor.first,
          ),
        ),
      ),
    );
  }
}

class ReviewStep extends StatefulWidget {
  final NewOrderData orderData;
  final List<GarmentMeasurements> measurements;
  final VoidCallback onBackToClient;
  const ReviewStep({
    super.key,
    required this.orderData,
    required this.measurements,
    required this.onBackToClient,
  });

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  @override
  Widget build(BuildContext context) {
    // review ui
    return Padding(
      padding: const EdgeInsets.only(top: 105, left: 8, right: 8, bottom: 40),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .start,
        children: [
          Text("Almost There", style: AppFonts.label(color: AppColor.error)),
          SizedBox(height: 10),
          Text(
            "Review the order",
            style: AppFonts.heading(color: AppColor.text),
          ),
          SizedBox(height: 10),
          Text(
            "Check the details — you can edit everything\nafter the order is opened.",
            style: AppFonts.body(color: AppColor.grey),
          ),
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColor.plainWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.grey.withValues(alpha: .2)),
            ),
            child: Row(
              mainAxisAlignment: .start,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    gradient: AppGradient.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.primary.withValues(alpha: .4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      getInitials(widget.orderData.clients!.name.toString()),
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
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      widget.orderData.clients!.name.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'DMSANS',
                        fontVariations: [FontVariation('wght', 700)],
                        color: AppColor.text,
                      ),
                    ),
                    Text(
                      widget.orderData.clients!.phone.toString(),
                      style: AppFonts.body(color: AppColor.grey),
                    ),
                  ],
                ),
                Spacer(),
                TextButton(
                  onPressed: widget.onBackToClient,
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              color: AppColor.plainWhite,
              border: Border.all(color: AppColor.grey.withValues(alpha: .08)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColor.grey.withValues(alpha: .06),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildIndividualReviewContainer(
                  'Garment',
                  Text(
                    widget.orderData.garment?.name ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.text,
                    ),
                  ),
                ),
                buildIndividualReviewContainer(
                  'Order Name',
                  Text(
                    widget.orderData.orderName.isNotEmpty
                        ? widget.orderData.orderName
                        : widget.orderData.garment!.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.text,
                    ),
                  ),
                ),
                buildIndividualReviewContainer(
                  'Due',
                  Text(
                    widget.orderData.deadline != null
                        ? DateTime(
                            widget.orderData.deadline!.year,
                            widget.orderData.deadline!.month,
                            widget.orderData.deadline!.day,
                          ).toString().split(' ').first
                        : '-',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.text,
                    ),
                  ),
                ),
                buildIndividualReviewContainer(
                  'Fabric',
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: widget.orderData.fabricColor != null
                              ? Color(
                                  int.parse(
                                        widget.orderData.fabricColor!.substring(
                                          1,
                                        ),
                                        radix: 16,
                                      ) +
                                      0xFF000000,
                                )
                              : null,
                          border: Border.all(
                            color: AppColor.grey.withValues(alpha: .3),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.orderData.fabricName ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'DMSANS',
                          fontVariations: [FontVariation('wght', 700)],
                          color: AppColor.text,
                        ),
                      ),
                    ],
                  ),
                ),
                buildIndividualReviewContainer(
                  'Total',
                  Text(
                    "₦${widget.orderData.total.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.text,
                    ),
                  ),
                ),
                buildIndividualReviewContainer(
                  'Deposit',
                  Text(
                    "₦${widget.orderData.deposit.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: widget.orderData.deposit == 0
                          ? AppColor.text
                          : AppColor.warning,
                    ),
                  ),
                ),
                buildIndividualReviewContainer(
                  'Balance',
                  Text(
                    "₦${widget.orderData.balance.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: widget.orderData.balance == 0
                          ? AppColor.text
                          : AppColor.success,
                    ),
                  ),
                ),
                buildIndividualReviewContainer(
                  'Notes',
                  Text(
                    widget.orderData.notes,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              color: AppColor.plainWhite,
              border: Border.all(color: AppColor.grey.withValues(alpha: .08)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColor.grey.withValues(alpha: .06),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildIndividualReviewContainer(
                  'Measurements',
                  Text(
                    '${widget.orderData.measurements.length} measurements',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'DMSANS',
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.text,
                    ),
                  ),
                ),

                ...widget.measurements.map((measurement) {
                  final value = widget.orderData.measurements[measurement.id];

                  return buildReviewMeasurementRow(
                    measurement.name,
                    value,
                    measurement.unit,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndividualReviewContainer(String title, Widget child) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.label(
                    color: AppColor.grey.withValues(alpha: .7),
                  ),
                ),
              ),
              Spacer(),
              Align(alignment: Alignment.centerRight, child: child),
            ],
          ),
        ),
        Divider(height: 1, color: AppColor.grey.withValues(alpha: .12)),
      ],
    );
  }

  Widget buildReviewMeasurementRow(String name, double? value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
      child: Row(
        children: [
          Expanded(
            child: Text(name, style: AppFonts.body(color: AppColor.text)),
          ),
          Spacer(),
          Text(
            value == null ? '--' : value.toStringAsFixed(1),
            style: AppFonts.body(color: AppColor.text),
          ),
          SizedBox(width: 6),
          Text(unit, style: AppFonts.body(color: AppColor.grey)),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:booking_system_flutter/component/app_common_dialog.dart';
import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/dotted_line.dart';
import 'package:booking_system_flutter/component/image_border_component.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/screens/booking/component/edit_booking_service_dialog.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../model/service_detail_response.dart';
import '../../../network/rest_apis.dart';
import 'booking_slots.dart';

class BookingComponent extends StatelessWidget {
  final BookingData bookingData;

  const BookingComponent({super.key, required this.bookingData});

  Widget _buildRow(
    String title,
    String value, {
    bool bold = false,
    Widget? rightWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(width: 12),

          // Case 1: if rightWidget exists → show it at far right
          if (rightWidget != null) ...[
            const Spacer(), // pushes widget to the end
            rightWidget,
          ] else
            // Case 2: fallback → show value at far right
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
      color: Colors.transparent, // <-- remove white background
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0, // <-- also remove shadow if you want
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Status (middle) + Booking ID (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bookingData.status ?? "Pending",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  "#${bookingData.id ?? '12345'}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.primaryColor),
                ),
              ],
            ),
            12.height,
            Center(
              child: Text(
                "${bookingData.serviceName ?? "Car Wash"}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            12.height,
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "₹${bookingData.amount ?? "299 "} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: context.primaryColor, // primary color for price
                      ),
                    ),
                    if (bookingData.discount != null &&
                        bookingData.discount! > 0)
                      TextSpan(
                        text: "(${bookingData.discount}% OFF)",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green, // green for discount
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Row 4: Address
            _buildRow(
                "Your Address", bookingData.address ?? "123 Street, City"),

            // Row 5: Date & Time
            _buildRow(
                "Date & Time", bookingData.date ?? "12 Sep 2025, 10:30 AM"),

            // Row 6: Customer Name
            _buildRow(
                "Customer Name",
                bookingData.customersName ??
                    bookingData.customerName ??
                    "John Doe"),

            // Row 7: Contact Number
            _buildRow(
                "Contact Number", bookingData.customerPhone ?? "----------"),

            // Row 8: Plan
            _buildRow(
              "Plan",
              bookingData.plan != null
                  ? "${bookingData.plan!.name} ₹${bookingData.plan!.amount}"
                  : "No Plan",
            ),

            // Row 9: Wash Type
            _buildRow(
              "Wash Type",
              bookingData.bookingsType == "instance"
                  ? "Instant Wash"
                  : bookingData.bookingsType == "daily"
                      ? "Daily Wash"
                      : bookingData.bookingsType.validate(), // fallback
            ),

            // Row 10: Location Type
            _buildRow(
              "Location",
              bookingData.bookingAt == "home"
                  ? "At Home"
                  : bookingData.bookingAt == "shed"
                      ? "At Shed"
                      : "At Home", // fallback if null/other
            ),

            // Row 11: Addons (View More button)
            if (bookingData.serviceaddon != null &&
                bookingData.serviceaddon!.isNotEmpty)
              _buildRow(
                "Addons",
                "",
                rightWidget: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddonsScreen(addons: bookingData.serviceaddon!),
                      ),
                    );
                  },
                  child: Text("View More",
                      style: TextStyle(color: context.primaryColor)),
                ),
              ),

            // Row 12: Preferences (View More button)
            if (bookingData.extraVehicles != null &&
                bookingData.extraVehicles!.isNotEmpty)
              _buildRow(
                "Extra Vehicles",
                "",
                rightWidget: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExtraVehiclesScreen(
                            vehicles: bookingData.extraVehicles!),
                      ),
                    );
                  },
                  child: Text(
                    "View More",
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
              ),

            // Row 13: Payment Status
            _buildRow(
              "Payment Status",
              getPaymentStatusLabel(bookingData.paymentStatus),
              bold: true,
            ),
          ],
        ),
      ),
    ));
  }

  String getPaymentStatusLabel(String? status) {
    if (status == null || status.isEmpty) return "Pending";

    switch (status.toLowerCase()) {
      case "paid":
        return "Paid";
      case "unpaid":
        return "Unpaid";
      case "advanced_paid":
        return "Advance Paid";
      case "refunded":
        return "Refunded";
      default:
        // Replace underscores with spaces, then capitalize each word
        return status
            .split('_')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : "")
            .join(" ");
    }
  }
}

class AddonsScreen extends StatelessWidget {
  final List<Serviceaddon> addons;

  const AddonsScreen({Key? key, required this.addons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Addons"),
      ),
      body: ListView.builder(
        itemCount: addons.length,
        itemBuilder: (context, index) {
          final addon = addons[index];
          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 3,
            color: Colors.grey[400],
            child: Row(
              children: [
                // Left half - image
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // margin inside card
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), // rounded corners
                      child: addon.serviceAddonImage.isNotEmpty
                          ? Image.network(
                              addon.serviceAddonImage,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.extension, size: 40),
                            ),
                    ),
                  ),
                ),

                // Right half - details
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addon.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: context.primaryColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Price: \$${addon.price}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExtraVehiclesScreen extends StatefulWidget {
  final List<ExtraVehicle> vehicles;

  const ExtraVehiclesScreen({Key? key, required this.vehicles})
      : super(key: key);

  @override
  _ExtraVehiclesScreenState createState() => _ExtraVehiclesScreenState();
}

class _ExtraVehiclesScreenState extends State<ExtraVehiclesScreen> {
  final Map<int, PageController> _controllers = {};
  final Map<int, int> _currentPage = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start auto-scroll for each vehicle
      widget.vehicles.asMap().forEach((index, vehicle) {
        if (vehicle.serviceImages != null &&
            vehicle.serviceImages!.length > 1) {
          Timer.periodic(const Duration(seconds: 3), (timer) {
            final controller = _controllers[index];
            if (controller != null && controller.hasClients) {
              int nextPage = (_currentPage[index] ?? 0) + 1;
              if (nextPage >= vehicle.serviceImages!.length) nextPage = 0;
              controller.animateToPage(
                nextPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _currentPage[index] = nextPage;
            } else {
              timer.cancel();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extra Vehicles")),
      body: ListView.builder(
        itemCount: widget.vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = widget.vehicles[index];
          final controller = PageController(viewportFraction: 1.0);
          _controllers[index] = controller;

          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 3,
            color: Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Left - Carousel
                  Expanded(
                    flex: 5,
                    child: vehicle.serviceImages != null &&
                            vehicle.serviceImages!.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 120,
                                child: PageView.builder(
                                  controller: controller,
                                  itemCount: vehicle.serviceImages!.length,
                                  itemBuilder: (context, i) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        vehicle.serviceImages![i],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SmoothPageIndicator(
                                controller: controller,
                                count: vehicle.serviceImages!.length,
                                effect: WormEffect(
                                  dotWidth: 8,
                                  dotHeight: 8,
                                  spacing: 4,
                                  activeDotColor: context.primaryColor,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.directions_car, size: 40),
                          ),
                  ),

                  const SizedBox(width: 12),

                  // Right - Details
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.serviceName ?? "Unknown Vehicle",
                          style: boldTextStyle(
                              size: 16, color: context.primaryColor),
                        ),
                        8.height,
                        Text(
                          "Plan: ${vehicle.planName ?? "N/A"}",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "Quantity: ${vehicle.quantity}",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "Price: \$${vehicle.price}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

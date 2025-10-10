import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/utils/colors.dart' as context;
import 'package:flutter/material.dart';

class AllPlansScreen extends StatelessWidget {
  final List<ServicePlanData> plans;
  final int selectedPlanId;
  final Function(int planId, double price) onPlanSelected;

  const AllPlansScreen({
    Key? key,
    required this.plans,
    required this.selectedPlanId,
    required this.onPlanSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Plans")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          final isSelected = selectedPlanId == (plan.id ?? 0);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _planCardVertical(
              plan.id ?? 0,
              plan.name ?? "Plan",
              "₹${plan.amount ?? '0'}/WASH",
              plan.items ?? [],
              plan.amount ?? "0",
              isSelected,
              (planId, price) {
                onPlanSelected(planId, price);
                Navigator.pop(context); // close after selecting
              },
            ),
          );
        },
      ),
    );
  }

  Widget _planCardVertical(
    int planId,
    String title,
    String price,
    List<ServicePlanItemData> items,
    String amount,
    bool isSelected,
    Function(int, double) onSelect,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appStore.isDarkMode
            ? const Color(0xFF171A1F)
            : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appStore.isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: appStore.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Features
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) {
              final isActive = item.status == 1;
              return Row(
                children: [
                  Icon(
                    isActive ? Icons.check_circle : Icons.cancel,
                    size: 14,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.name ?? '',
                      style: TextStyle(
                        color: appStore.isDarkMode ? Colors.white : Colors.black,
                        decoration: isActive ? null : TextDecoration.lineThrough,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Select Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? context.primaryColor : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                onSelect(planId, double.tryParse(amount) ?? 0);
              },
              child: Text(
                "$title ₹$amount",
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

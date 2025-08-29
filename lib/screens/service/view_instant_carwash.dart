import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class ViewInstantWash extends StatefulWidget {
  const ViewInstantWash({super.key});

  @override
  State<ViewInstantWash> createState() => _ViewInstantWashState();
}

class _ViewInstantWashState extends State<ViewInstantWash> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 16, minute: 0);

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  int selectedWashWhere = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://stimg.cardekho.com/images/carexteriorimages/630x420/Mahindra/XUV-3XO/10184/1751288551835/front-left-side-47.jpg?imwidth=420&impolicy=resize",
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("XUV300",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text("XUV Plans",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6)))
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text("SUV",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Plans
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: const Color(0xFF171A1F),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("BASIC PLAN",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(height: 6),
                          Text("₹99/WASH",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                          SizedBox(height: 10),
                          Text("• Interior Cleaning\n• Foam Wash\n• Wax Work",
                              style: TextStyle(color: Colors.white70))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: const Color(0xFF171A1F),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("SHINE PLAN",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(height: 6),
                          Text("₹199/WASH",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                          SizedBox(height: 10),
                          Text("• Exterior Body Wash\n• Tyre & Alloy Clean",
                              style: TextStyle(color: Colors.white70))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Addons
              const Text("Addons",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(height: 10),
              _addonItem("AC Vent Cleaning", "₹100.00"),
              _addonItem("Leather Seat Conditioning", "₹100.00"),
              const SizedBox(height: 20),

              // Date & Slots
              const Text("Booking Date And Slots",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color(0xFF171A1F),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                        style: const TextStyle(color: Colors.white)),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color(0xFF171A1F),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(selectedTime.format(context),
                        style: const TextStyle(color: Colors.white)),
                  )),
                ],
              ),
              const SizedBox(height: 20),

              // Choose wash place
              const Text(
                "Choose Where To Wash Your Car",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedWashWhere = 0; // 0 = Home
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selectedWashWhere == 0
                              ? Theme.of(context).primaryColor
                              : const Color(0xFF171A1F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/home.png",
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            const Text("At Home",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedWashWhere = 1; // 1 = Shed
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selectedWashWhere == 1
                              ? Theme.of(context).primaryColor
                              : const Color(0xFF171A1F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/shed.png",
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            const Text("At Your Shed",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Gallery
              const Text("Gallery",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _galleryImg(),
                    _galleryImg(),
                    _galleryImg(),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Reviews
              const Text("Reviews",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(height: 10),
              _reviewItem("Donna Bins", "Quick, Clean, Super Convenient!"),
              _reviewItem(
                  "Saul Armstrong", "Affordable and Professional Service."),

              const SizedBox(height: 20),
              // Personal Details
              const Text("Personal Details",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(height: 10),
              _inputField("Enter name", nameCtrl),
              const SizedBox(height: 10),
              _inputField("Enter mobile number", phoneCtrl),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {},
                  child: const Text("Book Now",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _addonItem(String title, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF171A1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(price, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _placeOption(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF171A1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Widget _galleryImg() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1589923188900-85d2c6449540?q=80&w=800"),
            fit: BoxFit.cover),
      ),
    );
  }

  Widget _reviewItem(String name, String review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFF171A1F),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/women/44.jpg"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(review, style: const TextStyle(color: Colors.white70))
              ],
            ),
          ),
          const Icon(Icons.star, color: Colors.green, size: 18),
          const Text(" 4.5", style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Widget _inputField(String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        filled: true,
        fillColor: const Color(0xFF171A1F),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}

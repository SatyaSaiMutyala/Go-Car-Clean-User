import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'view_instant_carwash.dart';

class InstantWashScreen extends StatefulWidget {
  const InstantWashScreen({super.key});

  @override
  State<InstantWashScreen> createState() => _InstantWashScreenState();
}

class _InstantWashScreenState extends State<InstantWashScreen> {
  TextEditingController searchCont = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Instant Car Wash"),
        backgroundColor: context.primaryColor,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔍 Search & Filter Row (reusable style like your ViewAllServiceScreen)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AppTextField(
                  textFieldType: TextFieldType.OTHER,
                  focus: myFocusNode,
                  controller: searchCont,
                  suffix: CloseButton(
                    onPressed: () {
                      searchCont.clear();
                      setState(() {});
                    },
                  ).visible(searchCont.text.isNotEmpty),
                  onFieldSubmitted: (s) {
                    setState(() {}); // you can trigger API call here
                  },
                  decoration: InputDecoration(
                    hintText: "Search for vehicles",
                    filled: true,
                    fillColor: Colors.black54,
                    border: OutlineInputBorder(
                      borderRadius: radius(12),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: secondaryTextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  ),
                ).expand(),
                12.width,
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxDecorationDefault(color: context.primaryColor),
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ).onTap(() {
                  toast("Filter clicked");
                }),
              ],
            ),
          ),

          /// 🚗 Vehicle Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _vehicleCategory("Car",
                    "https://cdn-icons-png.flaticon.com/512/743/743131.png"),
                _vehicleCategory("Bike",
                    "https://cdn-icons-png.flaticon.com/512/1047/1047711.png"),
                _vehicleCategory("Scooty",
                    "https://cdn-icons-png.flaticon.com/512/2972/2972185.png"),
                _vehicleCategory("Bus",
                    "https://cdn-icons-png.flaticon.com/512/61/61222.png"),
              ],
            ),
          ),

          20.height,
          Text("Modals", style: boldTextStyle(color: Colors.white, size: 18))
              .paddingSymmetric(horizontal: 16),
          // here I want to add tabbar so make that code here
          12.height,

          /// 🚙 Car Models
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _carCard("SUV", "XUV300",
                    "https://stimg.cardekho.com/images/carexteriorimages/630x420/Mahindra/XUV-3XO/10184/1751288551835/front-left-side-47.jpg?imwidth=420&impolicy=resize"),
                16.height,
                _carCard("SUV", "XUV400",
                    "https://stimg.cardekho.com/images/carexteriorimages/630x420/Mahindra/XUV-3XO/10184/1751288551835/front-left-side-47.jpg?imwidth=420&impolicy=resize"),
                16.height,
                _carCard("SUV", "XUV500",
                    "https://stimg.cardekho.com/images/carexteriorimages/630x420/Mahindra/XUV-3XO/10184/1751288551835/front-left-side-47.jpg?imwidth=420&impolicy=resize"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Vehicle category widget
  Widget _vehicleCategory(String title, String iconUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Image.network(iconUrl, height: 32, fit: BoxFit.contain),
          ),
          6.height,
          Text(title, style: primaryTextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  /// Car model card widget
  Widget _carCard(String tag, String name, String imgUrl) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewInstantWash()))
      },
        child: Container(
      decoration: BoxDecoration(
        borderRadius: radius(16),
        color: Colors.black54,
      ),
      child: Stack(
        children: [
          /// Car image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),

          /// Tag at top-left corner
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: boxDecorationDefault(
                  color: Colors.blue, borderRadius: radius(8)),
              child: Text(tag,
                  style: boldTextStyle(color: Colors.white, size: 12)),
            ),
          ),

          /// Bottom gradient bar with model name
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.brown],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Text(
                name,
                style: boldTextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

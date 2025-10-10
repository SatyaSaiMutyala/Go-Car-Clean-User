import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/empty_error_state_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/model/dashboard_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_component_instance.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_extra_vehicle.dart';
import 'package:booking_system_flutter/screens/filter/filter_screen.dart';
import 'package:booking_system_flutter/screens/service/component/service_component.dart';
import 'package:booking_system_flutter/screens/service/service_book.dart';
import 'package:booking_system_flutter/screens/service/service_detail_screen.dart';
import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:booking_system_flutter/utils/constant.dart';

class VehicleSelectorBottomsheet extends StatefulWidget {
  const VehicleSelectorBottomsheet({super.key});

  @override
  State<VehicleSelectorBottomsheet> createState() =>
      _VehicleSelectorBottomsheetState();
}

class _VehicleSelectorBottomsheetState
    extends State<VehicleSelectorBottomsheet> {
  TextEditingController searchCont = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  Future<DashboardResponse>? future;
  CategoryData? selectedCategory;
Map<int, List<CategoryData>> selectedSubCategory = {};
Map<int, List<ServiceData>> selectedService = {};
  Future<List<CategoryData>>? futureSubcategories;
  List<CategoryData> selectedCategories = [];
  int page = 1;
  bool isLastPage = false;
  int? selectedPlanId;

  @override
  void initState() {
    super.initState();
    filterStore = FilterStore();
    init();
  }

  void init() {
    future = userDashboard(
      isCurrentLocation: appStore.isCurrentLocation,
      lat: getDoubleAsync(LATITUDE),
      long: getDoubleAsync(LONGITUDE),
    );
    setState(() {});
  }

  void loadSubcategories(int catId) {
    futureSubcategories = getSubCategoryListAPI(catId: catId);
    setState(() {});
  }

  void fetchAllServiceData() {
    searchServiceAPI(
      page: page,
      list: [],
      categoryId: selectedCategory != null
          ? selectedCategory!.id.toString()
          : filterStore.categoryId.join(','),
      subCategory: '',
      providerId: filterStore.providerId.join(","),
      isPriceMin: filterStore.isPriceMin,
      isPriceMax: filterStore.isPriceMax,
      ratingId: filterStore.ratingId.join(','),
      search: searchCont.text,
      latitude:
          appStore.isCurrentLocation ? getDoubleAsync(LATITUDE).toString() : "",
      longitude: appStore.isCurrentLocation
          ? getDoubleAsync(LONGITUDE).toString()
          : "",
      lastPageCallBack: (p0) {
        isLastPage = p0;
      },
      isFeatured: '',
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SnapHelperWidget<DashboardResponse>(
      future: future,
      loadingWidget: Loader(),
      errorBuilder: (error) => NoDataWidget(
        title: error,
        imageWidget: ErrorStateWidget(),
        retryText: language.reload,
        onRetry: () {
          appStore.setLoading(true);
          init();
        },
      ),
      onSuccess: (snap) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80), // keep space for button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                  Center(
                    child: Container(
                      width: 80, // width of the bar
                      height: 6, // thickness of the bar
                      margin:
                          EdgeInsets.only(bottom: 16), // spacing below the bar
                      decoration: BoxDecoration(
                        color: context.primaryColor, // color of the bar
                        borderRadius: BorderRadius.circular(10), // rounded edges
                        border: Border.all(
                            color:
                                appStore.isDarkMode ? Colors.white : Colors.black,
                            width: 1), // border
                      ),
                    ),
                  ),
                // Heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Which Type of Vehicle Do you Have?",
                    style: boldTextStyle(size: 18, color: appStore.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                16.height,

                // 1️⃣ Categories Row
                CategoryExtraVehicle(
                  categoryList: snap.category.validate(),
                  onCategorySelected: (categories) {
                    setState(() {
                      selectedCategories = categories;
                    });
                  },
                ),
                24.height,

                // 2️⃣ Subcategories per selected category
                for (var category in selectedCategories) ...[
                  SnapHelperWidget<List<CategoryData>>(
                    future: getSubCategoryListAPI(catId: category.id.validate()),
                    loadingWidget: Loader(),
                    onSuccess: (subCats) {
                      if (subCats.isEmpty) return SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "${category.name ?? ''} Models",
                              style: boldTextStyle(size: 18, color: appStore.isDarkMode ? Colors.white : Colors.black),
                            ),
                          ),
                          12.height,
                          SubCategorySelector(
                            subCategoryList: subCats,
                            onSubCategorySelected: (sub) {
                              setState(() {
                                selectedSubCategory[category.id!] = sub;
                              });
                            },
                          ),
                          16.height,
                        ],
                      );
                    },
                  ),
                ],

                // 3️⃣ Services for all selected subcategories
                for (var category in selectedCategories) ...[
                  for (var sub in (selectedSubCategory[category.id] ?? [])) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "${sub.name ?? ''} Brands",
                        style: boldTextStyle(size: 16, color: appStore.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                    12.height,
                    FutureBuilder<List<ServiceData>>(
                      future: searchServiceAPI(
                        categoryId: category.id.toString(),
                        subCategory: sub.id.toString(),
                        list: [],
                      ),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) return Loader();
                        if (snap.hasError) return Text("Error: ${snap.error}");
                        if (snap.data!.isEmpty) return Text("No services found");

                        return ServiceSelector(
                          services: snap.data!,
                          onServiceSelected: (serviceList) {
                            setState(() {
                              selectedService[sub.id!] = serviceList;
                            });
                          },
                        );
                      },
                    ),
                    20.height,
                  ],
                ],

                // 4️⃣ Plans for all selected services
                for (var category in selectedCategories) ...[
                  for (var sub in (selectedSubCategory[category.id] ?? [])) ...[
                    if ((selectedService[sub.id] ?? []).isNotEmpty) ...[
                      for (var service in (selectedService[sub.id] ?? [])) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "${service.name ?? ''} Plans",
                            style: boldTextStyle(size: 16, color: appStore.isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                       _plansForModel(service.plans ?? [])
                      ],
                      20.height,
                    ]
                  ],
                ],

                // 5️⃣ Confirm Button
                Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor, // ✅ use app primary color
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: () {
  if (selectedPlanId != null) {
    // find the selected plan from the services
    ServicePlanData? chosenPlan;
    ServiceData? chosenService;

    for (var serviceList in selectedService.values) {
      for (var s in serviceList) {
        final match = s.plans?.firstWhere(
          (p) => p.id == selectedPlanId,
          orElse: () => ServicePlanData(),
        );
        if (match != null && match.id != null && match.id == selectedPlanId) {
          chosenPlan = match;
          chosenService = s;
          break;
        }
      }
    }

    if (chosenPlan != null && chosenService != null) {
      final selectedPlan = SelectedVehiclePlan(
        vehicleType: selectedCategories.isNotEmpty
            ? selectedCategories.first.name ?? "Unknown"
            : "Unknown",
        vehicleName: chosenService.name ?? "Unknown",
        model: selectedSubCategory.values.isNotEmpty
            ? selectedSubCategory.values.first.first.name ?? "Unknown"
            : "Unknown",
        price: double.tryParse(chosenPlan!.amount ?? '0') ?? 0.0,
        planId: chosenPlan.id!,
      );

      Navigator.pop(context, selectedPlan); // ✅ return to parent
    }
  }
},
    child: const Text(
      "Confirm",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
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

Widget _plansForModel(List<ServicePlanData> plans) {
  if (plans.isEmpty) return SizedBox();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: plans.map((plan) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _planCard(
  plan.id ?? 0,   // 👈 pass ID
  plan.name ?? "Plan",
  "₹${plan.amount ?? '0'}/WASH",
  plan.items ?? [],
  plan.amount ?? "0",
),

            );
          }).toList(),
        ),
      ),
    ],
  );
}

Widget _planCard(
  int planId,
  String title,
  String price,
  List<ServicePlanItemData> items,
  String amount,
) {
  final isSelected = selectedPlanId == planId;

  return Container(
    width: 220,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: appStore.isDarkMode ? Color(0xFF171A1F) : Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appStore.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
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
                Text(
                  item.name ?? '',
                  style: TextStyle(
                    color: appStore.isDarkMode ? Colors.white : Colors.black,
                    decoration: isActive ? null : TextDecoration.lineThrough,
                  ),
                ),
              ],
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        // Select button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.white, // ✅ toggle
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedPlanId = planId; // ✅ mark selected
              });
            },
            child: Text(
              "$title ₹$amount",
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (appStore.isDarkMode ? Colors.black : Colors.black),
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

// import 'package:booking_system_flutter/main.dart';
// import 'package:booking_system_flutter/screens/service/service_book.dart';
// import 'package:booking_system_flutter/utils/images.dart';
// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';

void showVehicleSelector(BuildContext context) {
  Map<int, int> selectedBrandIndex = {};
  Map<int, int?> selectedModelIndex = {};
  Set<int> selectedVehicleTypes = {};

  final bikeBrands = [
    {
      'img': bike_image,
      'name': 'Bike',
      'models': [
        {'img': bike_image, 'name': 'Splendor'},
        {'img': bike_image, 'name': 'Splendor Plus'},
      ]
    },
    {
      'img': scooty_image,
      'name': 'Scooty',
      'models': [
        {'img': scooty_image, 'name': 'Scooty Pep'},
        {'img': scooty_image, 'name': 'Scooty Streak'},
      ]
    },
    {
      'img': bike_image,
      'name': 'Yamaha',
      'models': [
        {'img': bike_image, 'name': 'FZ'},
        {'img': bike_image, 'name': 'R15'},
      ]
    },
  ];

  final carBrands = [
    {
      'img': car_image,
      'name': 'Car',
      'models': [
        {'img': car_image, 'name': 'Swift'},
        {'img': car_image, 'name': 'Baleno'},
      ]
    },
    {
      'img': car_xuv300,
      'name': 'XUV300',
      'models': [
        {'img': car_xuv300, 'name': 'Base'},
        {'img': car_xuv300, 'name': 'Sport'},
      ]
    },
    {
      'img': car_xuv400,
      'name': 'XUV400',
      'models': [
        {'img': car_xuv400, 'name': 'EV'},
      ]
    },
  ];
  final busBrands = [
    {
      'img': bus_image,
      'name': 'Bus',
      'models': [
        {'img': bus_image, 'name': 'Tata'},
        {'img': bus_image, 'name': 'Ashok Leyland'},
      ]
    },
    {
      'img': bus_image,
      'name': 'Volvo',
      'models': [
        {'img': bus_image, 'name': '9400'},
        {'img': bus_image, 'name': '9600'},
      ]
    },
    {
      'img': bus_image,
      'name': 'Mini Bus',
      'models': [
        {'img': bus_image, 'name': 'Mini Bus'},
      ]
    },
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:
        appStore.isDarkMode ? Color(0xFF171A1F) : Color(0xFFE0E0E0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext modalContext) {
      return StatefulBuilder(
        builder: (modalContext, setModalState) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8, // ⬅️ 80% height
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80, // width of the bar
                        height: 6, // thickness of the bar
                        margin: EdgeInsets.only(
                            bottom: 16), // spacing below the bar
                        decoration: BoxDecoration(
                          color: context.primaryColor, // color of the bar
                          borderRadius:
                              BorderRadius.circular(10), // rounded edges
                          border: Border.all(
                              color: appStore.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              width: 1), // border
                        ),
                      ),
                      Text(
                        "Which Type of Vehicle Do you Have?",
                        style: TextStyle(
                          color:
                              appStore.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Bike
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (selectedVehicleTypes.contains(0)) {
                                  selectedVehicleTypes.remove(0);
                                } else {
                                  selectedVehicleTypes.add(0);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(bike_image, width: 32, height: 32),
                                SizedBox(width: 6),
                                Text("Bike",
                                    style: TextStyle(
                                        color: appStore.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold)),
                                if (selectedVehicleTypes.contains(0))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(Icons.check,
                                        color: Theme.of(context).primaryColor,
                                        size: 18),
                                  ),
                              ],
                            ),
                          ),
                          // Car
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (selectedVehicleTypes.contains(1)) {
                                  selectedVehicleTypes.remove(1);
                                } else {
                                  selectedVehicleTypes.add(1);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(car_image, width: 32, height: 32),
                                SizedBox(width: 6),
                                Text("Car",
                                    style: TextStyle(
                                        color: appStore.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold)),
                                if (selectedVehicleTypes.contains(1))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(Icons.check,
                                        color: Theme.of(context).primaryColor,
                                        size: 18),
                                  ),
                              ],
                            ),
                          ),
                          // Bus
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (selectedVehicleTypes.contains(2)) {
                                  selectedVehicleTypes.remove(2);
                                } else {
                                  selectedVehicleTypes.add(2);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(bus_image, width: 32, height: 32),
                                SizedBox(width: 6),
                                Text("Bus",
                                    style: TextStyle(
                                        color: appStore.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold)),
                                if (selectedVehicleTypes.contains(2))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(Icons.check,
                                        color: Theme.of(context).primaryColor,
                                        size: 18),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Add these maps at the top of your State class to track selected brands:

                      if (selectedVehicleTypes.isNotEmpty) ...[
                        SizedBox(height: 18),
                        Text("Choose your brand",
                            style: TextStyle(
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        SizedBox(height: 12),

                        // Render all brand rows first
                        for (var type in selectedVehicleTypes) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type == 0
                                      ? "Bike"
                                      : type == 1
                                          ? "Car"
                                          : "Bus",
                                  style: TextStyle(
                                      color: appStore.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 8),

                                // Brand Selection
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              (type == 0
                                                  ? bikeBrands.length
                                                  : type == 1
                                                      ? carBrands.length
                                                      : busBrands.length);
                                          i++) ...[
                                        GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              selectedBrandIndex[type] = i;
                                              selectedModelIndex[type] =
                                                  null; // Reset model when brand changes
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 12),
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                    selectedBrandIndex[type] ==
                                                            i
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.transparent,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  (type == 0
                                                      ? bikeBrands[i]['img']
                                                      : type == 1
                                                          ? carBrands[i]['img']
                                                          : busBrands[i][
                                                              'img']) as String,
                                                  width: 48,
                                                  height: 48,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  (type == 0
                                                      ? bikeBrands[i]['name']
                                                      : type == 1
                                                          ? carBrands[i]['name']
                                                          : busBrands[i][
                                                              'name']) as String,
                                                  style: TextStyle(
                                                      color: appStore.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 13),
                                                ),
                                                if (selectedBrandIndex[type] ==
                                                    i)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: Icon(Icons.check,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 16),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Pick your model section AFTER all brand sections
                        if (selectedBrandIndex.values
                            .any((v) => v != null)) ...[
                          SizedBox(height: 16),
                          Text(
                            "Pick your model below",
                            style: TextStyle(
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign
                                .start, // ⬅️ ensures text is left aligned
                          ),
                          SizedBox(height: 8),

                          // Show models for ALL selected types + brands
                          for (var entry in selectedBrandIndex.entries
                              .where((e) => e.value != null)) ...[
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                entry.key == 0
                                    ? "Bike Models"
                                    : entry.key == 1
                                        ? "Car Models"
                                        : "Bus Models",
                                style: TextStyle(
                                    color: appStore.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            SizedBox(height: 8),
                            Builder(builder: (_) {
                              final type = entry.key;
                              final brandIndex = entry.value!;
                              final models = (type == 0
                                      ? bikeBrands[brandIndex]['models']
                                      : type == 1
                                          ? carBrands[brandIndex]['models']
                                          : busBrands[brandIndex]['models'])
                                  as List;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (int j = 0; j < models.length; j++) ...[
                                      GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            selectedModelIndex[type] = j;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 12),
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  selectedModelIndex[type] == j
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.transparent,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                  models[j]['img'] as String,
                                                  width: 48,
                                                  height: 48),
                                              SizedBox(width: 6),
                                              Text(models[j]['name'] as String,
                                                  style: TextStyle(
                                                      color: appStore.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 13)),
                                              if (selectedModelIndex[type] == j)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4),
                                                  child: Icon(Icons.check,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 16),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }),
                          ],

                          // ⬇️ AFTER all model sections, render plans
                          if (selectedModelIndex.values
                              .any((v) => v != null)) ...[
                            SizedBox(height: 20),
                            Text("Available Plans",
                                style: TextStyle(
                                    color: appStore.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            SizedBox(height: 12),
                            for (var entry in selectedModelIndex.entries
                                .where((e) => e.value != null)) ...[
                              // Builder(builder: (_) {
                              //   final type = entry.key;
                              //   final brandIndex = selectedBrandIndex[type]!;
                              //   final modelIndex = entry.value!;
                              //   final models = (type == 0
                              //           ? bikeBrands[brandIndex]['models']
                              //           : type == 1
                              //               ? carBrands[brandIndex]['models']
                              //               : busBrands[brandIndex]['models'])
                              //       as List;

                              //   return Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       _plansForModel(
                              //         models[modelIndex]['name'] as String,
                              //       ),
                              //       SizedBox(height: 16),
                              //     ],
                              //   );
                              // }),
                            ],
                          ]
                        ]
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceBookScreen(),
                              ),
                            );
                          },
                          child: Text("Confirm",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: appStore.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        },
      );
    },
  );
}





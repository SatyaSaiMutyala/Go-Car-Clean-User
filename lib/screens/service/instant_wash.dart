import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/empty_error_state_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/model/dashboard_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_component_instance.dart';
import 'package:booking_system_flutter/screens/filter/filter_screen.dart';
import 'package:booking_system_flutter/screens/service/component/service_component.dart';
import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'view_instant_carwash.dart';

class InstantWashScreen extends StatefulWidget {
  const InstantWashScreen({super.key});

  @override
  State<InstantWashScreen> createState() => _InstantWashScreenState();
}

class _InstantWashScreenState extends State<InstantWashScreen> {
  TextEditingController searchCont = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  Future<DashboardResponse>? future;
  CategoryData? selectedCategory;
  Future<List<CategoryData>>? futureSubcategories;
  ServiceData dummyService = ServiceData(
    id: 14,
    name: "Dummy Service",
    description: "This is a placeholder service for demo",
    // add other required fields if your model enforces them
  );
  int page = 1;
  bool isLastPage = false;
  

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
      categoryId: selectedCategory != null ? selectedCategory!.id.toString() : filterStore.categoryId.join(','),
      subCategory: '',
      providerId: filterStore.providerId.join(","),
      isPriceMin: filterStore.isPriceMin,
      isPriceMax: filterStore.isPriceMax,
      ratingId: filterStore.ratingId.join(','),
      search: searchCont.text,
      latitude: appStore.isCurrentLocation ? getDoubleAsync(LATITUDE).toString() : "",
      longitude: appStore.isCurrentLocation ? getDoubleAsync(LONGITUDE).toString() : "",
      lastPageCallBack: (p0) {
        isLastPage = p0;
      },
      isFeatured: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Instant Car Wash")),
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
          return Column(children: [
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   child: Row(
            //     children: [
            //       AppTextField(
            //         textFieldType: TextFieldType.OTHER,
            //         focus: myFocusNode,
            //         controller: searchCont,
            //         suffix: CloseButton(
            //           onPressed: () {
            //             searchCont.clear();
            //             setState(() {});
            //           },
            //         ).visible(searchCont.text.isNotEmpty),
            //         onFieldSubmitted: (s) {
            //           setState(() {});
            //         },
            //         decoration: InputDecoration(
            //           hintText: "Search Here...",
            //           filled: true,
            //           fillColor: appStore.isDarkMode
            //               ? Colors.black54
            //               : Colors.grey.shade200,
            //           border: OutlineInputBorder(
            //             borderRadius: radius(12),
            //             borderSide: BorderSide.none,
            //           ),
            //           hintStyle: secondaryTextStyle(color: Colors.grey),
            //           prefixIcon: Icon(
            //             Icons.search,
            //             color: appStore.isDarkMode
            //                 ? Colors.white54
            //                 : Colors.black54,
            //           ),
            //         ),
            //       ).expand(),
            //       12.width,
            //       Container(
            //         padding: const EdgeInsets.all(10),
            //         decoration:
            //             boxDecorationDefault(color: context.primaryColor),
            //         child: Image.asset(
            //           filter_image,
            //           height: 24,
            //           width: 24,
            //           color: appStore.isDarkMode ? Colors.white : Colors.black,
            //         ),
            //       ).onTap(() {
            //         toast("Filter clicked");
            //       }),
            //     ],
            //   ),
            // ),

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
                          page = 1;
                          searchCont.clear();
                          filterStore.setSearch('');
                          appStore.setLoading(true);
                          fetchAllServiceData();
                          setState(() {});
                        },
                      ).visible(searchCont.text.isNotEmpty),
                      onFieldSubmitted: (s) {
                        page = 1;
                        filterStore.setSearch(s);
                        appStore.setLoading(true);
                        fetchAllServiceData();
                        setState(() {});
                      },
                      decoration: inputDecoration(context).copyWith(
                        hintText: "${language.lblSearchFor} ${language.allServices}",
                        prefixIcon: ic_search.iconImage(size: 10).paddingAll(14),
                        hintStyle: secondaryTextStyle(),
                      ),
                    ).expand(),
                    16.width,
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: boxDecorationDefault(color: context.primaryColor),
                      child: CachedImageWidget(
                        url: ic_filter,
                        height: 26,
                        width: 26,
                        color: Colors.white,
                      ),
                    ).onTap(() {
                      hideKeyboard(context);
                      FilterScreen(isFromProvider: true, isFromCategory: false).launch(context).then((value) {
                        if (value != null) {
                          page = 1;
                          appStore.setLoading(true);
                          fetchAllServiceData();
                          setState(() {});
                        }
                      });
                    }, borderRadius: radius()),
                  ],
                ),
              ),

            // / Categories
            CategoryComponentInstance(
              categoryList: snap.category.validate(),
              onCategorySelected: (cat) {
                setState(() {
                  selectedCategory = cat;
                });
                loadSubcategories(cat.id.validate());
              },
            ),
            16.height,

            if (selectedCategory != null)
              Expanded(
                child: SnapHelperWidget<List<CategoryData>>(
                  future: futureSubcategories,
                  loadingWidget: Loader(),
                  onSuccess: (subCats) {
                    if (subCats.isEmpty)
                      return Center(child: Text("No Subcategories"));

                    return DefaultTabController(
                      length: subCats.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Models",
                                  style: boldTextStyle(
                                      color: appStore.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      size: 18))
                              .paddingSymmetric(horizontal: 16),
                          12.height,

                          /// 🔹 Dynamic Tabs
                          TabBar(
                            isScrollable: true,
                            indicatorColor: Colors.yellow,
                            indicatorWeight: 4,
                            labelColor: appStore.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            unselectedLabelColor: appStore.isDarkMode
                                ? Colors.white54
                                : Colors.black54,
                            labelStyle: boldTextStyle(size: 16),
                            unselectedLabelStyle: secondaryTextStyle(size: 14),
                            tabs: subCats
                                .map((sub) => Tab(text: sub.name.validate()))
                                .toList(),
                          ),

                          /// 🔹 Dynamic Tab Views
                          Expanded(
                            child: TabBarView(
                              children: subCats.map((sub) {
                                return FutureBuilder<List<ServiceData>>(
                                  future: searchServiceAPI(
                                    categoryId: selectedCategory!.id.toString(),
                                    subCategory: sub.id.toString(),
                                    list: [],
                                  ),
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return Loader();
                                    }
                                    if (snap.hasError) {
                                      return Center(
                                          child: Text("Error: ${snap.error}"));
                                    }
                                    if (snap.data!.isEmpty) {
                                      return Center(
                                          child: Text("No services found"));
                                    }

                                    return ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: snap.data!.length,
                                      itemBuilder: (_, index) {
                                        return ServiceComponent(
                                          serviceData: snap.data![index],
                                          isFromViewAllService: true,
                                          bookingType: "instance",
                                        ).paddingBottom(12);
                                      },
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else

              /// 👇 Show message + image if no category is selected
              Expanded(
                child: Center(
                  child: NoDataWidget(
                    title: "Select a category to book the service",
                    imageWidget: ErrorStateWidget(),
                    retryText: language.reload,
                    onRetry: () {
                      appStore.setLoading(true);
                      init();
                    },
                  ),
                ),
              ),
          ]);
        },
      ),
    );
  }
}

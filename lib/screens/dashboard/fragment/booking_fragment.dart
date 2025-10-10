import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_component_detail_screen.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_component_screen.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_item_component.dart';
import 'package:booking_system_flutter/screens/booking/shimmer/booking_shimmer.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../store/filter_store.dart';
import '../../booking_filter/booking_filter_screen.dart';

// class BookingFragment extends StatefulWidget {
//   @override
//   _BookingFragmentState createState() => _BookingFragmentState();
// }

// class _BookingFragmentState extends State<BookingFragment>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   UniqueKey keyForList = UniqueKey();
//   ScrollController scrollController = ScrollController();

//   Future<List<BookingData>>? future;
//   List<BookingData> bookings = [];

//   int page = 1;
//   bool isLastPage = false;

//   String selectedValue = BOOKING_TYPE_ALL;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);

//     init();
//     filterStore = FilterStore();

//     afterBuildCreated(() {
//       if (appStore.isLoggedIn) {
//         setStatusBarColor(context.primaryColor);
//       }
//     });

//     LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
//       page = 1;
//       appStore.setLoading(true);
//       init();
//       setState(() {});
//     });
//     cachedBookingStatusDropdown.validate().forEach((element) {
//       element.isSelected = false;
//     });
//   }

//   void init({String status = ''}) async {
//     future = getBookingList(
//       page,
//       serviceId: filterStore.serviceId.join(","),
//       dateFrom: filterStore.startDate,
//       dateTo: filterStore.endDate,
//       providerId: filterStore.providerId.join(","),
//       handymanId: filterStore.handymanId.join(","),
//       bookingStatus: filterStore.bookingStatus.join(","),
//       paymentStatus: filterStore.paymentStatus.join(","),
//       paymentType: filterStore.paymentType.join(","),
//       bookings: bookings,
//       lastPageCallback: (b) {
//         isLastPage = b;
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     filterStore.clearFilters();
//     LiveStream().dispose(LIVESTREAM_UPDATE_BOOKING_LIST);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: appBarWidget(
//           language.booking,
//           textColor: white,
//           showBack: false,
//           textSize: APP_BAR_TEXT_SIZE,
//           elevation: 3.0,
//           color: context.primaryColor,
//           actions: [
//             Container(
//   padding: const EdgeInsets.all(10),
//   decoration: boxDecorationDefault(color: context.primaryColor),
//   child: Image.asset(
//     filter_image,
//     height: 44,
//     width: 44,
//     color: appStore.isDarkMode ? Colors.white : Colors.black,
//   ),
// ).onTap(() {
//   // ✅ keep this outside the builder so it persists
//   Set<String> selectedStatuses = {};

//   showModalBottomSheet(
//     context: context,
//     barrierColor: appStore.isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
//     isScrollControlled: true,
//     backgroundColor: appStore.isDarkMode ? Colors.black : Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           List<String> statuses = [
//             "Pending",
//             "Accepted",
//             "Ongoing",
//             "In Progress",
//             "Hold",
//             "Cancelled",
//             "Rejected",
//             "Failed",
//             "Completed",
//             "Pending Approval",
//             "Waiting",
//           ];

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔹 Header Row (Filter by + Close)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                    Text(
//                       "Filter By",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appStore.isDarkMode ? Colors.white : Colors.black),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close, color: context.primaryColor),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // 🔹 Booking Status Title
//                  Text(
//                   "Booking Status",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appStore.isDarkMode ? Colors.white : Colors.black),
//                 ),
//                 const SizedBox(height: 12),

//                 // 🔹 Status Options
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: statuses.map((status) {
//                     final bool isSelected = selectedStatuses.contains(status);

//                     return ChoiceChip(
//                       showCheckmark: false,
//                       label: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (isSelected)
//                             Icon(Icons.check,
//                                 size: 16,
//                                 color: Theme.of(context).primaryColor),
//                           if (isSelected) const SizedBox(width: 4),
//                           Text(
//                             status,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: isSelected
//                                   ? Theme.of(context).primaryColor
//                                   : Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                       selected: isSelected,
//                       onSelected: (selected) {
//                         setState(() {
//                           if (selected) {
//                             selectedStatuses.add(status);
//                           } else {
//                             selectedStatuses.remove(status);
//                           }
//                         });
//                       },
//                       backgroundColor: appStore.isDarkMode ? Colors.black54 : Colors.white54,
//                       selectedColor: appStore.isDarkMode ? Colors.black : Colors.white,
//                       side: BorderSide(color: appStore.isDarkMode ? Colors.black26 : Colors.white24),
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     );
//                   }).toList(),
//                 ),

//                 const SizedBox(height: 24),

//                 // 🔹 Buttons Row
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           setState(() => selectedStatuses.clear());
//                         },
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: Text("Clear Filter", style: TextStyle(fontWeight: FontWeight.bold, color: context.primaryColor),)
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // 👉 Apply logic (return selectedStatuses)
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).primaryColor,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           "Apply",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }),


//           ],
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(kToolbarHeight),
//             child: Container(
//               color: appStore.isDarkMode
//                             ? Colors.black
//                             : Colors.white, // 🔥 TabBar background color
//               child: TabBar(
//                 controller: _tabController,
//                 indicatorColor: Colors.blue, // underline color
//                 labelColor: appStore.isDarkMode ? Colors.white : Colors.black, // selected tab text color
//                 unselectedLabelColor: Colors.grey.shade600, // unselected tab text color
//                 tabs: const [
//                   Tab(text: "Instant Booking"),
//                   Tab(text: "Daily Booking"),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             buildBookingList("instant"), // you can pass filter type
//             buildBookingList("daily"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildBookingList(String type) {
//   return SnapHelperWidget<List<BookingData>>(
//     initialData: cachedBookingList,
//     future: future,
//     errorBuilder: (error) {
//       return NoDataWidget(
//         title: error,
//         imageWidget: ErrorStateWidget(),
//         retryText: language.reload,
//         onRetry: () {
//           page = 1;
//           appStore.setLoading(true);
//           init();
//           setState(() {});
//         },
//       );
//     },
//     loadingWidget: BookingShimmer(),
//     onSuccess: (list) {
//       return AnimatedListView(
//         key: keyForList,
//         controller: scrollController,
//         padding: EdgeInsets.all(16),
//         itemCount: list.length,
//         emptyWidget: NoDataWidget(
//           title: language.lblNoBookingsFound,
//           subTitle: language.noBookingSubTitle,
//           imageWidget: EmptyStateWidget(),
//         ),
//         itemBuilder: (_, index) {
//           BookingData data = list[index];
//           return GestureDetector(
//             onTap: () {
//               DetailedBookingScreen(bookingData: data).launch(context);
//               // BookingDetailScreen(bookingId: data.id.validate())
//               //     .launch(context);
//             },
//             child: BookingComponent(bookingData: data), // simple item
//           );
//         },
//         onNextPage: () {
//           if (!isLastPage) {
//             page++;
//             appStore.setLoading(true);
//             init(status: selectedValue);
//             setState(() {});
//           }
//         },
//         onSwipeRefresh: () async {
//           page = 1;
//           appStore.setLoading(true);
//           init(status: selectedValue);
//           setState(() {});
//           return await 1.seconds.delay;
//         },
//       );
//     },
//   );
// }
// }

// class BookingFragment extends StatefulWidget {
//   @override
//   _BookingFragmentState createState() => _BookingFragmentState();
// }

// class _BookingFragmentState extends State<BookingFragment> {
//   UniqueKey keyForList = UniqueKey();

//   ScrollController scrollController = ScrollController();

//   Future<List<BookingData>>? future;
//   List<BookingData> bookings = [];

//   int page = 1;
//   bool isLastPage = false;

//   String selectedValue = BOOKING_TYPE_ALL;

//   @override
//   void initState() {
//     super.initState();
//     init();
//     filterStore = FilterStore();

//     afterBuildCreated(() {
//       if (appStore.isLoggedIn) {
//         setStatusBarColor(context.primaryColor);
//       }
//     });

//     LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
//       page = 1;
//       appStore.setLoading(true);
//       init();
//       setState(() {});
//     });
//     cachedBookingStatusDropdown.validate().forEach((element) {
//       element.isSelected = false;
//     });
//   }

//   void init({String status = ''}) async {
//     future = getBookingList(
//       page,
//       serviceId: filterStore.serviceId.join(","),
//       dateFrom: filterStore.startDate,
//       dateTo: filterStore.endDate,
//       providerId: filterStore.providerId.join(","),
//       handymanId: filterStore.handymanId.join(","),
//       bookingStatus: filterStore.bookingStatus.join(","),
//       paymentStatus: filterStore.paymentStatus.join(","),
//       paymentType: filterStore.paymentType.join(","),
//       bookings: bookings,
//       lastPageCallback: (b) {
//         isLastPage = b;
//       },
//     );
//   }

//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }

//   @override
//   void dispose() {
//     filterStore.clearFilters();
//     LiveStream().dispose(LIVESTREAM_UPDATE_BOOKING_LIST);
//     //scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarWidget(
//         language.booking,
//         textColor: white,
//         showBack: false,
//         textSize: APP_BAR_TEXT_SIZE,
//         elevation: 3.0,
//         color: context.primaryColor,
//         actions: [
//           Observer(
//             builder: (_) {
//               int filterCount = filterStore.getActiveFilterCount();
//               return Stack(
//                 children: [
//                   IconButton(
//                     icon: ic_filter.iconImage(color: white, size: 20),
//                     onPressed: () async {
//                       BookingFilterScreen(showHandymanFilter: true).launch(context).then((value) {
//                         if (value != null) {
//                           page = 1;
//                           appStore.setLoading(true);
//                           init();
//                           if (bookings.isNotEmpty) {
//                             scrollController.animateTo(0, duration: 1.seconds, curve: Curves.easeOutQuart);
//                           } else {
//                             scrollController = ScrollController();
//                             keyForList = UniqueKey();
//                           }
//                           setState(() {});
//                         }
//                       });
//                     },
//                   ),
//                   if (filterCount > 0)
//                     Positioned(
//                       right: 7,
//                       top: 0,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: FittedBox(
//                           child: Text('$filterCount', style: TextStyle(color: white, fontSize: 10, fontWeight: FontWeight.bold)),
//                         ),
//                         decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//       body: SizedBox(
//         width: context.width(),
//         height: context.height(),
//         child: Stack(
//           children: [
//             SnapHelperWidget<List<BookingData>>(
//               initialData: cachedBookingList,
//               future: future,
//               errorBuilder: (error) {
//                 return NoDataWidget(
//                   title: error,
//                   imageWidget: ErrorStateWidget(),
//                   retryText: language.reload,
//                   onRetry: () {
//                     page = 1;
//                     appStore.setLoading(true);

//                     init();
//                     setState(() {});
//                   },
//                 );
//               },
//               loadingWidget: BookingShimmer(),
//               onSuccess: (list) {
//                 return AnimatedListView(
//                   key: keyForList,
//                   controller: scrollController,
//                   physics: AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: 60, top: 16, right: 16, left: 16),
//                   itemCount: list.length,
//                   shrinkWrap: true,
//                   disposeScrollController: true,
//                   listAnimationType: ListAnimationType.FadeIn,
//                   fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
//                   slideConfiguration: SlideConfiguration(verticalOffset: 400),
//                   emptyWidget: NoDataWidget(
//                     title: language.lblNoBookingsFound,
//                     subTitle: language.noBookingSubTitle,
//                     imageWidget: EmptyStateWidget(),
//                   ),
//                   itemBuilder: (_, index) {
//                     BookingData? data = list[index];

//                     return GestureDetector(
//                       onTap: () {
//                         BookingDetailScreen(bookingId: data.id.validate()).launch(context);
//                       },
//                       child: BookingItemComponent(bookingData: data),
//                     );
//                   },
//                   onNextPage: () {
//                     if (!isLastPage) {
//                       page++;
//                       appStore.setLoading(true);

//                       init(status: selectedValue);
//                       setState(() {});
//                     }
//                   },
//                   onSwipeRefresh: () async {
//                     page = 1;
//                     appStore.setLoading(true);

//                     init(status: selectedValue);
//                     setState(() {});

//                     return await 1.seconds.delay;
//                   },
//                 );
//               },
//             ),
//             Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
//           ],
//         ),
//       ),
//     );
//   }
// }


class BookingFragment extends StatefulWidget {
  @override
  _BookingFragmentState createState() => _BookingFragmentState();
}

class _BookingFragmentState extends State<BookingFragment> with TickerProviderStateMixin {
  UniqueKey keyForList = UniqueKey();
  ScrollController scrollController = ScrollController();

  Future<List<BookingData>>? future;
  List<BookingData> bookings = [];

  int page = 1;
  bool isLastPage = false;

  String selectedValue = BOOKING_TYPE_ALL;

  @override
  void initState() {
    super.initState();
    init();
    filterStore = FilterStore();

    afterBuildCreated(() {
      if (appStore.isLoggedIn) {
        setStatusBarColor(context.primaryColor);
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
      page = 1;
      appStore.setLoading(true);
      init();
      setState(() {});
    });
    cachedBookingStatusDropdown.validate().forEach((element) {
      element.isSelected = false;
    });
  }

  void init({String status = ''}) async {
    future = getBookingList(
      page,
      serviceId: filterStore.serviceId.join(","),
      dateFrom: filterStore.startDate,
      dateTo: filterStore.endDate,
      providerId: filterStore.providerId.join(","),
      handymanId: filterStore.handymanId.join(","),
      bookingStatus: filterStore.bookingStatus.join(","),
      paymentStatus: filterStore.paymentStatus.join(","),
      paymentType: filterStore.paymentType.join(","),
      bookings: bookings,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    filterStore.clearFilters();
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKING_LIST);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // ✅ Two tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.booking, style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE)),
          backgroundColor: context.primaryColor,
          bottom: TabBar(
            indicatorColor: white,
            labelColor: white,
            unselectedLabelColor: white.withOpacity(0.6),
            tabs: [
              Tab(text: "Instant Booking"),
              Tab(text: "Daily Booking"),
            ],
          ),
          actions: [
            Observer(
              builder: (_) {
                int filterCount = filterStore.getActiveFilterCount();
                return Stack(
                  children: [
                    IconButton(
                      icon: ic_filter.iconImage(color: white, size: 20),
                      onPressed: () async {
                        BookingFilterScreen(showHandymanFilter: true).launch(context).then((value) {
                          if (value != null) {
                            page = 1;
                            appStore.setLoading(true);
                            init();
                            if (bookings.isNotEmpty) {
                              scrollController.animateTo(0, duration: 1.seconds, curve: Curves.easeOutQuart);
                            } else {
                              scrollController = ScrollController();
                              keyForList = UniqueKey();
                            }
                            setState(() {});
                          }
                        });
                      },
                    ),
                    if (filterCount > 0)
                      Positioned(
                        right: 7,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                          child: FittedBox(
                            child: Text('$filterCount', style: TextStyle(color: white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // ✅ Instant Booking Tab
            buildBookingList(BOOKING_TYPE_INSTANT),

            // ✅ Daily Booking Tab
            buildBookingList(BOOKING_TYPE_DAILY),
          ],
        ),
      ),
    );
  }

  Widget buildBookingList(String bookingType) {
    return SnapHelperWidget<List<BookingData>>(
      initialData: cachedBookingList,
      future: future,
      errorBuilder: (error) {
        return NoDataWidget(
          title: error,
          imageWidget: ErrorStateWidget(),
          retryText: language.reload,
          onRetry: () {
            page = 1;
            appStore.setLoading(true);
            init();
            setState(() {});
          },
        );
      },
      loadingWidget: BookingShimmer(),
      onSuccess: (list) {
        // ✅ Filter list based on bookingType
        List<BookingData> filteredList = list.where((e) => e.bookingsType == bookingType).toList();

        return AnimatedListView(
          key: keyForList,
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 60, top: 16, right: 16, left: 16),
          itemCount: filteredList.length,
          shrinkWrap: true,
          disposeScrollController: true,
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          slideConfiguration: SlideConfiguration(verticalOffset: 400),
          emptyWidget: NoDataWidget(
            title: language.lblNoBookingsFound,
            subTitle: language.noBookingSubTitle,
            imageWidget: EmptyStateWidget(),
          ),
          itemBuilder: (_, index) {
            BookingData data = filteredList[index];
            return GestureDetector(
              onTap: () {
                // DetailedBookingScreen(bookingData: data).launch(context);
                BookingDetailScreen(bookingId: data.id.validate()).launch(context);
              },
              // child: BookingItemComponent(bookingData: data),
              child: BookingComponent(bookingData: data),
            );
          },
          onNextPage: () {
            if (!isLastPage) {
              page++;
              appStore.setLoading(true);
              init(status: selectedValue);
              setState(() {});
            }
          },
          onSwipeRefresh: () async {
            page = 1;
            appStore.setLoading(true);
            init(status: selectedValue);
            setState(() {});
            return await 1.seconds.delay;
          },
        );
      },
    );
  }
}

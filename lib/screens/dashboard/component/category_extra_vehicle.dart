import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/screens/category/category_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_extra_vehice_widget.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_widget.dart';
import 'package:booking_system_flutter/screens/service/view_all_service_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryExtraVehicle extends StatefulWidget {
  final List<CategoryData>? categoryList;
  final Function(List<CategoryData>)? onCategorySelected; // list for multi-select

  const CategoryExtraVehicle({this.categoryList, this.onCategorySelected, super.key});

  @override
  State<CategoryExtraVehicle> createState() => _CategoryExtraVehicleState();
}

class _CategoryExtraVehicleState extends State<CategoryExtraVehicle> {
  List<int> selectedCategoryIds = [];

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.validate().isEmpty) return Offstage();

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categoryList!.length,
        itemBuilder: (ctx, i) {
          CategoryData data = widget.categoryList![i];
          bool isSelected = selectedCategoryIds.contains(data.id);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedCategoryIds.remove(data.id);
                } else {
                  selectedCategoryIds.add(data.id!);
                }
              });
              // pass list of selected categories
              widget.onCategorySelected?.call(
                widget.categoryList!
                    .where((c) => selectedCategoryIds.contains(c.id))
                    .toList(),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  (data.categoryImage ?? "").endsWith('.svg')
    ? SvgPicture.network(
        data.categoryImage ?? "",
        width: 32,
        height: 32,
        color: appStore.isDarkMode ? Colors.white : null,
      )
    : CachedImageWidget(
        url: data.categoryImage ?? "",
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        circle: true,
      ),
                  const SizedBox(width: 6),
                  Text(
                    data.name ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appStore.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.check, color: Colors.green, size: 18),
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


class SubCategorySelector extends StatefulWidget {
  final List<CategoryData>? subCategoryList;
  final Function(List<CategoryData>)? onSubCategorySelected; // send multiple
  final List<int>? selectedSubCategoryIds;

  const SubCategorySelector({
    this.subCategoryList,
    this.onSubCategorySelected,
    this.selectedSubCategoryIds,
    super.key,
  });

  @override
  State<SubCategorySelector> createState() => _SubCategorySelectorState();
}

class _SubCategorySelectorState extends State<SubCategorySelector> {
  late List<int> selectedIds;

  @override
  void initState() {
    super.initState();
    selectedIds = widget.selectedSubCategoryIds ?? [];
  }

  @override
  void didUpdateWidget(covariant SubCategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedIds = widget.selectedSubCategoryIds ?? selectedIds;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subCategoryList.validate().isEmpty) return Offstage();

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.subCategoryList!.length,
        itemBuilder: (ctx, i) {
          CategoryData data = widget.subCategoryList![i];
          bool isSelected = selectedIds.contains(data.id);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedIds.remove(data.id);
                } else {
                  selectedIds.add(data.id!);
                }
              });

              // Pass back all selected subcategories
              widget.onSubCategorySelected?.call(
                widget.subCategoryList!
                    .where((c) => selectedIds.contains(c.id))
                    .toList(),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  (data.categoryImage ?? "").endsWith('.svg')
    ? SvgPicture.network(
        data.categoryImage ?? "",
        width: 32,
        height: 32,
        color: appStore.isDarkMode ? Colors.white : null,
      )
    : CachedImageWidget(
        url: data.categoryImage ?? "",
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        circle: true,
      ),
                  6.width,
                  Text(
                    data.name ?? "",
                    style: boldTextStyle(
                      color:
                          appStore.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.check, color: Colors.green, size: 18),
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

class ServiceSelector extends StatefulWidget {
  final List<ServiceData> services;
  final Function(List<ServiceData>)? onServiceSelected; // multiple

  const ServiceSelector({required this.services, this.onServiceSelected, super.key});

  @override
  State<ServiceSelector> createState() => _ServiceSelectorState();
}

class _ServiceSelectorState extends State<ServiceSelector> {
  List<int> selectedServiceIds = [];

  @override
  Widget build(BuildContext context) {
    if (widget.services.isEmpty) return Center(child: Text("No Services"));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.services.length,
        itemBuilder: (ctx, i) {
          ServiceData service = widget.services[i];
          bool isSelected = selectedServiceIds.contains(service.id);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedServiceIds.remove(service.id);
                } else {
                  selectedServiceIds.add(service.id!);
                }
              });

              // Send back all selected services
              widget.onServiceSelected?.call(
                widget.services
                    .where((s) => selectedServiceIds.contains(s.id))
                    .toList(),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  service.attachments != null && service.attachments!.isNotEmpty
    ? CachedImageWidget(
        url: service.attachments!.first ?? "",
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        circle: true,
      )
                      : Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.miscellaneous_services, size: 24),
                        ),
                  6.width,
                  Text(
                    service.name ?? "",
                    style: boldTextStyle(
                      color:
                          appStore.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.check, color: Colors.green, size: 18),
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

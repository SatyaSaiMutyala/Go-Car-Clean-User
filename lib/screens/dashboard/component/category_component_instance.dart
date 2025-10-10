import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/screens/category/category_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_widget.dart';
import 'package:booking_system_flutter/screens/service/view_all_service_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryComponentInstance extends StatefulWidget {
  final List<CategoryData>? categoryList;
  final Function(CategoryData)? onCategorySelected; // callback

  CategoryComponentInstance(
      {this.categoryList, this.onCategorySelected, super.key});

  @override
  State<CategoryComponentInstance> createState() =>
      _CategoryComponentInstanceState();
}

class _CategoryComponentInstanceState extends State<CategoryComponentInstance> {
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 👈 Add here
      children: [
        AnimatedWrap(
          alignment: WrapAlignment.start,
          spacing: 16,
          runSpacing: 16,
          itemCount: widget.categoryList.validate().length,
          itemBuilder: (ctx, i) {
            CategoryData data = widget.categoryList![i];
            bool isSelected = selectedCategoryId == data.id;

            return GestureDetector(
              onTap: () {
                setState(() => selectedCategoryId = data.id);
                widget.onCategorySelected?.call(data); // notify parent
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  CategoryWidget(categoryData: data),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.done, size: 14, color: Colors.white),
                    ),
                ],
              ),
            );
          },
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}

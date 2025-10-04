import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_cubit.dart';
import 'package:perfect/cubits/course_selection_cubit/course_selection_cubit.dart';
import 'package:perfect/cubits/course_selection_cubit/course_selection_state.dart';
import 'package:perfect/widgets/dynamic_dropdown/widget/dynamic_dropdown.dart';

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: PColors.backgrndPrimary,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      final size = ResponsiveConfig(context);
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "Filters",
              ),
              const SizedBox(height: 16),
              BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
                builder: (context, state) {
                  return DynamicDropdown(
                    title: 'Category',
                    firestoreField: 'course_categories',
                    currentValue:
                        state.category, // use state.category instead of String?
                    onChanged: (val) {
                      context.read<CourseSelectionCubit>().selectCategory(val);
                      context.read<CourseListCubit>().applyCategory(val);
                    },
                  );
                },
              ),
              SizedBox(height: size.percentHeight(0.02)),
              BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
                builder: (context, state) {
                  if (state.category == null) {
                    // placeholder
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Sub Category'),
                      items: [],
                      onChanged: null,
                      hint: Text('Select Category first'),
                    );
                  }
                  return DynamicDropdown(
                    key: ValueKey(state.category),
                    title: 'Sub Category',
                    firestoreField: 'course_subcategories',
                    nestedKey: state
                        .category, // pass selected category dynamically here
                    currentValue: state.subCategory,
                    onChanged: (val) {
                      context
                          .read<CourseSelectionCubit>()
                          .selectSubCategory(val);
                      context.read<CourseListCubit>().applySubcategory(val);
                    },
                  );
                },
              ),
              SizedBox(height: size.percentHeight(0.02)),
              BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
                builder: (context, state) {
                  if (state.subCategory == null) {
                    return DropdownButtonFormField<String>(
                      decoration:
                          InputDecoration(labelText: 'Sub sub Category'),
                      items: [],
                      onChanged: null,
                      hint: Text('Select Sub Category first'),
                    );
                  }

                  return DynamicDropdown(
                    key: ValueKey(state.subCategory),
                    title: 'Sub sub Category',
                    firestoreField: 'course_sub_subcategories',
                    nestedKey: state.subCategory,
                    currentValue: state.subSubCategory,
                    onChanged: (val) {
                      context
                          .read<CourseSelectionCubit>()
                          .selectSubSubCategory(val);
                      context.read<CourseListCubit>().applySubSubcategory(val);
                    },
                  );
                },
              ),
              SizedBox(height: size.percentHeight(0.02)),
              BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
                builder: (context, state) {
                  return DynamicDropdown(
                    title: 'Language',
                    firestoreField: 'languages',
                    currentValue: state.language,
                    onChanged: (val) {
                      print(val);
                      context.read<CourseSelectionCubit>().selectLanguage(val);
                      context.read<CourseListCubit>().applyLanguage(val);
                    },
                  );
                },
              ),
              SizedBox(height: size.percentHeight(0.02)),
              BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
                builder: (context, state) {
                  return DynamicDropdown(
                    title: 'Course Type',
                    firestoreField: 'course_types',
                    currentValue: state.language,
                    onChanged: (val) {
                      context
                          .read<CourseSelectionCubit>()
                          .selectCourseType(val);
                      context.read<CourseListCubit>().applyCourseType(val);
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.clear),
                      label: Text("Clear Filters"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PColors.error,
                        foregroundColor: PColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<CourseSelectionCubit>().reset();
                        context.read<CourseListCubit>().clearFilters();
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PColors.primary,
                        foregroundColor: PColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        context.read<CourseListCubit>().refreshFilters();
                        Navigator.pop(context);
                      },
                      child: Text("Apply Filters"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

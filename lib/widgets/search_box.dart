import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_cubit.dart';
import 'package:perfect/widgets/filter_bottom_sheet.dart';

class SearchBox extends StatelessWidget {
  final ResponsiveConfig responsive;
  const SearchBox({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(responsive.spacingSmall),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: PColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: PColors.primary, // 👈 primary color here
              width: 2,
            ),
          ),
          focusColor: PColors.containerBackground,
          suffixIcon: IconButton(
            onPressed: () {
              showFilterBottomSheet(context);
            },
            icon: Icon(
              Icons.filter_alt,
              color: PColors.containerBackground,
            ),
          ),
        ),
        onChanged: (value) {
          context.read<CourseListCubit>().searchCourses(value);
        },
      ),
    );
  }
}

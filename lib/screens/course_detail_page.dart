import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/payment/payment_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_cubit.dart';
import 'package:perfect/cubits/user_cubit.dart/user_cubit.dart';
import 'package:perfect/models/course_model.dart';
import 'package:perfect/screens/course_video_player_screen.dart';
import 'package:perfect/widgets/custom_app_bar.dart';
import 'package:perfect/widgets/custom_button.dart';
import 'package:perfect/widgets/custom_snackbar.dart';
import 'package:perfect/widgets/meta_chip.dart';
import 'package:perfect/widgets/tag_chip.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;
  const CourseDetailsPage({
    super.key,
    required this.course,
  });
  @override
  Widget build(BuildContext ctx) {
    final size = ResponsiveConfig(ctx);
    print(ctx.watch<UserCubit>().state?.name);
    return BlocProvider(
      create: (_) => PaymentBloc(ctx.watch<UserCubit>().state?.name ?? ''),
      child: BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              showCustomSnackbar(
                  context: context,
                  message: 'COURSE PURCHASED...',
                  size: size,
                  backgroundColor: PColors.success);
              context.read<CourseListCubit>().loadCourses();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CourseScreenWithVideo(course: course)));
            }
            if (state is PaymentFailure) {
              showCustomSnackbar(
                  context: context,
                  message: 'Payment failed retry..',
                  size: size,
                  backgroundColor: PColors.error);
            }
          },
          child: Scaffold(
              backgroundColor: PColors.containerBackground,
              appBar: CustomAppBar(title: 'Enroll the Course Now!! '),
              body: Column(
                children: [
                  _buildThumbnailSection(course, size),
                  Expanded(
                      child: _buildDescriptionandvideoListSection(
                          size, ctx, course)),
                ],
              ))),
    );
  }
}

Widget _buildThumbnailSection(Course course, ResponsiveConfig size) {
  return SizedBox(
      height: size.percentHeight(0.27),
      width: size.percentWidth(1),
      child: Image.network(
        course.thumbnail,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          color: Colors.black12,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined, size: 40),
        ),
      ));
}

Widget _buildDescriptionandvideoListSection(
    ResponsiveConfig size, BuildContext context, Course course) {
  return Container(
      padding: const EdgeInsets.only(top: 18.0, left: 10.0, right: 10.0),
      height: size.percentHeight(0.67),
      decoration: BoxDecoration(
        color: PColors.backgrndPrimary,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Text(
              course.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.percentWidth(0.05),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: PColors.lightgrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: PColors.containerBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: PColors.white,
                unselectedLabelColor: PColors.grey,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                tabs: const [
                  Tab(text: 'Description'),
                  Tab(text: 'Classes'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDescriptionTab(size, course, context),
                  _buildClassesTab(size, context, course),
                ],
              ),
            ),
          ],
        ),
      ));
}

Widget _buildDescriptionTab(
    ResponsiveConfig size, Course course, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: size.percentHeight(0.03)),
      MetaChips(items: [
        ('Category', course.category),
        ('Sub-category', course.subCategory),
        ('Sub-sub-category', course.subSubCategories),
      ]),
      SizedBox(height: 20),
      Align(
        alignment: Alignment.centerLeft,
        child: TagChip(
          leadingIcon: Icons.language,
          label: course.language,
          tooltip: 'Course language',
          background: PColors.secondary,
          foreground: PColors.backgrndPrimary,
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          "About this course",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.percentWidth(0.055),
          ),
        ),
      ),
      Divider(),
      SizedBox(height: 8),
      Align(
        alignment: Alignment.center,
        child: Text(
          course.description,
          style: TextStyle(
            fontSize: size.percentWidth(0.04),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: size.percentHeight(0.03)),
      Align(child: Builder(builder: (context) {
        return CustomButton(
            onPressed: () {
              context.read<PaymentBloc>().add(StartPayment(context, course));
            },
            text: "Enroll Now ONLY ₹${course.price}");
      }))
    ],
  );
}

/// Classes Tab (Videos List)
Widget _buildClassesTab(
    ResponsiveConfig size, BuildContext context, Course course) {
  final videos = course.videos;
  return ListView.builder(
    padding: const EdgeInsets.all(12.0),
    itemCount: videos.length,
    itemBuilder: (ctx, index) {
      final video = videos[index];
      return Card(
        elevation: 1,
        color: PColors.backgrndPrimary,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: ColoredBox(
              color: PColors.containerBackground,
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              )),
          title: Text(video['title'] ?? "Video ${index + 1}"),
        ),
      );
    },
  );
}

class _HeaderImage extends StatelessWidget {
  final String imageUrl;
  final Object? heroTag;
  _HeaderImage({required this.imageUrl, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    Widget image = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSyncLoaded) {
              return Container(
                color: Colors.black12,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2),
              );
            },
            errorBuilder: (context, error, stack) => Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined, size: 40),
            ),
          ),
        ],
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // subtle gap before content
      child: image,
    );
  }
}

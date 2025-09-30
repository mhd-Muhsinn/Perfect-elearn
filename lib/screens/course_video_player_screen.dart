import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/cubit/course_list_cubit.dart';
import 'package:perfect/cubits/video_player_cubit.dart';
import 'package:perfect/models/course_model.dart';
import 'package:perfect/widgets/custom_app_bar.dart';
import 'package:perfect/widgets/meta_chip.dart';
import 'package:perfect/widgets/tag_chip.dart';
import 'package:perfect/widgets/video_player.dart';
import 'package:video_player/video_player.dart';

class CourseVideoPlayerScreen extends StatelessWidget {
  final Course course;
  const CourseVideoPlayerScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    context.read<CourseListCubit>().loadcourse();
    return BlocProvider(
      create: (context) => VideoPlayerCubit(
        VideoPlayerController.networkUrl(Uri.parse(course.videos.first['video_url'])),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: PColors.containerBackground,
        appBar: CustomAppBar(title: ''),
        body: Column(
          children: [
            _buildvideoplayerSEction(size),
            SizedBox(height: size.percentHeight(0.02)),
            Expanded(
                child: _buildDescriptionandvideoListSection(size, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildvideoplayerSEction(ResponsiveConfig size) {
    return Column(
      children: [
        Container(
          width: size.percentWidth(0.94),
          color: PColors.primary,
          child: CourseVideoPlayer(
            size: size,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionandvideoListSection(
      ResponsiveConfig size, BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 18.0, left: 10.0, right: 10.0),
        height: size.percentHeight(0.67),
        decoration: BoxDecoration(
          color: PColors.backgrndPrimary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  tabs: const [
                    Tab(text: 'Description'),
                    Tab(text: 'Classes'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildDescriptionTab(size),
                    _buildClassesTab(size, context),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildDescriptionTab(ResponsiveConfig size) {
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
      ],
    );
  }

  /// Classes Tab (Videos List)
  Widget _buildClassesTab(ResponsiveConfig size, BuildContext context) {
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
            onTap: () {
              context.read<VideoPlayerCubit>().loadVideo(video['video_url']);
            },
          ),
        );
      },
    );
  }

}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/repositories/course_repository.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool initialized;
  final bool showControls;
  final String courseId;
  final String videoId;

  VideoPlayerState(
      {required this.isPlaying,
      required this.position,
      required this.duration,
      required this.initialized,
      required this.showControls,
      required this.courseId,
      required this.videoId});

  VideoPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? initialized,
    bool? showControls,
    String? courseId,
    String? videoId,
  }) {
    return VideoPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      initialized: initialized ?? this.initialized,
      showControls: showControls ?? this.showControls,
      courseId: courseId ?? this.courseId,
      videoId: videoId ?? this.videoId,
    );
  }
}

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController controller;
  final String courseId;
  final String videoId;
  final CoursesRepository _coursesRepository = CoursesRepository();

  VideoPlayerCubit(this.controller,
      {required this.courseId, required this.videoId})
      : super(VideoPlayerState(
          isPlaying: false,
          position: Duration.zero,
          duration: Duration.zero,
          initialized: false,
          showControls: false,
          courseId: courseId,
          videoId: videoId,
        )) {
    _init();
  }

  Future<void> _init() async {
    await controller.initialize();
    emit(state.copyWith(
      duration: controller.value.duration,
      initialized: true,
    ));
    controller.addListener(_updateState);
  }

  void _updateState() {
    final pos = controller.value.position.inMilliseconds.toDouble();
    final dur = controller.value.duration.inMilliseconds.toDouble();
    print("$pos and $dur  these are in milliseconds ");

    if (dur > 0 && pos >= dur * 0.95) {
      _markVideoComplete(state.courseId, state.videoId);
    }
    emit(state.copyWith(
      isPlaying: controller.value.isPlaying,
      position: controller.value.position,
      duration: controller.value.duration,
    ));
  }

  _markVideoComplete(String courseId, String videoId) async {
    await _coursesRepository.markVideoComplete(courseId, videoId);
  }

  Future<void> loadVideo(String url, String courseId, String videoId) async {
    await controller.pause();
    await controller.dispose();

    controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();

    controller.addListener(_updateState);

    emit(state.copyWith(
        isPlaying: false,
        position: Duration.zero,
        duration: controller.value.duration,
        initialized: true,
        showControls: true,
        courseId: courseId,
        videoId: videoId));
  }

  void toggleControls() {
    emit(state.copyWith(showControls: !state.showControls));
  }

  void play() => controller.play();
  void pause() => controller.pause();

  void seekForward() {
    final target = controller.value.position + const Duration(seconds: 10);
    controller.seekTo(
      target < controller.value.duration ? target : controller.value.duration,
    );
  }

  void seekBackward() {
    final target = controller.value.position - const Duration(seconds: 10);
    controller.seekTo(target > Duration.zero ? target : Duration.zero);
  }

  @override
  Future<void> close() {
    controller.removeListener(_updateState);
    controller.dispose();
    return super.close();
  }
}

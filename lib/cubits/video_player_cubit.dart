import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool initialized;
  final bool showControls;

  VideoPlayerState({
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.initialized,
    required this.showControls,
  });

  VideoPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? initialized,
    bool? showControls
  }) {
    return VideoPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      initialized: initialized ?? this.initialized,
      showControls: showControls ?? this.showControls,
    );
  }
}

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController controller;

  VideoPlayerCubit(this.controller)
      : super(VideoPlayerState(
          isPlaying: false,
          position: Duration.zero,
          duration: Duration.zero,
          initialized: false,
          showControls: false,
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
    emit(state.copyWith(
      isPlaying: controller.value.isPlaying,
      position: controller.value.position,
      duration: controller.value.duration,
    ));
  }

  /// 🔹 Load a new video URL
  Future<void> loadVideo(String url) async {
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
    ));
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

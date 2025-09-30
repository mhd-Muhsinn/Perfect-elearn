import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:video_player/video_player.dart';
import 'package:perfect/cubits/video_player_cubit.dart';

class CourseVideoPlayer extends StatelessWidget {
  final ResponsiveConfig size;
  const CourseVideoPlayer({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
      builder: (context, state) {
        final cubit = context.read<VideoPlayerCubit>();

        if (!state.initialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: size.percentHeight(0.3),
          child: GestureDetector(
            onTap: cubit.toggleControls,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(cubit.controller),

                if (state.showControls)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10,
                              color: Colors.white, size: 34),
                          onPressed: cubit.seekBackward,
                        ),
                        IconButton(
                          icon: Icon(
                            state.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 38,
                          ),
                          onPressed: () {
                            state.isPlaying ? cubit.pause() : cubit.play();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10,
                              color: Colors.white, size: 34),
                          onPressed: cubit.seekForward,
                        ),
                      ],
                    ),
                  ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    cubit.controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.black26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

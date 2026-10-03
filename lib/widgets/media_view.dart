import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

bool isVideo(String? url) => url != null && (url.contains('.mp4') || url.contains('.mov') || url.contains('.webm'));

class MediaView extends StatefulWidget {
  const MediaView({super.key, required this.url, this.play = true});
  final String url;
  final bool play;
  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  VideoPlayerController? c;
  @override
  void initState() {
    super.initState();
    if (isVideo(widget.url)) _open();
  }

  Future<void> _open() async {
    final v = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    c = v;
    await v.initialize();
    v.setLooping(true);
    if (widget.play) await v.play();
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(MediaView old) {
    super.didUpdateWidget(old);
    if (widget.play) {
      c?.play();
    } else {
      c?.pause();
    }
  }

  @override
  void dispose() {
    c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isVideo(widget.url)) {
      return Image.network(widget.url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF111111), child: Center(child: Icon(Icons.broken_image))));
    }
    final v = c;
    if (v == null || !v.value.isInitialized) {
      return const ColoredBox(color: Color(0xFF111111), child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: v.value.size.width, height: v.value.size.height, child: VideoPlayer(v)),
    );
  }
}

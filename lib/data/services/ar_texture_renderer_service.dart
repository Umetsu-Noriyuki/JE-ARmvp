import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import 'package:ar_app/data/models/ar_object/ar_object_content.dart';

/// ARオブジェクトに貼る画像（PNG）とそのピクセルサイズ
class ArTexture {
  const ArTexture({
    required this.pngBytes,
    required this.widthPx,
    required this.heightPx,
  });

  final Uint8List pngBytes;
  final int widthPx;
  final int heightPx;

  /// 高さ / 幅
  double get heightPerWidth => heightPx / widthPx;
}

/// ARオブジェクトの内容を PNG 画像として描画する
///
/// Step 3（技術スパイク）では文字の横書き・中央揃えのみ対応する。
/// 揃え位置・縦書き・図形は Step 4 で対応する。
class ArTextureRendererService {
  const ArTextureRendererService();

  /// AR 上で鮮明に表示するための描画倍率（fontSize に掛ける）
  static const double RENDER_SCALE = 4.0;

  /// 文字の周囲の余白（描画後の文字サイズに対する比率）
  static const double PADDING_RATIO = 0.4;

  Future<ArTexture> renderText(TextContent content) async {
    final painter = _layoutText(content);
    final padding = content.fontSize * RENDER_SCALE * PADDING_RATIO;
    final widthPx = (painter.width + padding * 2).ceil();
    final heightPx = (painter.height + padding * 2).ceil();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    _paintBackground(canvas, content, widthPx, heightPx);
    painter.paint(canvas, Offset(padding, padding));
    painter.dispose();

    final pngBytes = await _encodePng(recorder, widthPx, heightPx);
    return ArTexture(pngBytes: pngBytes, widthPx: widthPx, heightPx: heightPx);
  }

  TextPainter _layoutText(TextContent content) {
    return TextPainter(
      text: TextSpan(
        text: content.text,
        style: TextStyle(
          fontSize: content.fontSize * RENDER_SCALE,
          color: Color(content.textColorArgb),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
  }

  void _paintBackground(
    Canvas canvas,
    TextContent content,
    int widthPx,
    int heightPx,
  ) {
    final radius = Radius.circular(content.fontSize * RENDER_SCALE * 0.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, widthPx.toDouble(), heightPx.toDouble()),
        radius,
      ),
      Paint()..color = Color(content.backgroundColorArgb),
    );
  }

  Future<Uint8List> _encodePng(
    ui.PictureRecorder recorder,
    int widthPx,
    int heightPx,
  ) async {
    final picture = recorder.endRecording();
    final image = await picture.toImage(widthPx, heightPx);
    picture.dispose();
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        throw StateError('Failed to encode texture as PNG');
      }
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }
}

import 'package:ar_app/core/enums/ar_object_type.dart';
import 'package:ar_app/core/enums/shape_type.dart';
import 'package:ar_app/core/enums/text_horizontal_align.dart';
import 'package:ar_app/core/enums/text_vertical_align.dart';
import 'package:ar_app/core/enums/writing_direction.dart';
import 'package:ar_app/core/utils/json_reader.dart';

/// ARオブジェクトの内容（種類ごとの設定値）
sealed class ArObjectContent {
  const ArObjectContent();

  /// JSON からオブジェクト種類に応じた内容を復元する
  factory ArObjectContent.fromJson(Map<String, dynamic> json) {
    final type = JsonReader.readEnum(json, 'type', ArObjectType.values);
    return switch (type) {
      ArObjectType.text => TextContent.fromJson(json),
      ArObjectType.shape => ShapeContent.fromJson(json),
    };
  }

  ArObjectType get type;

  Map<String, dynamic> toJson();
}

/// 文字オブジェクトの内容
final class TextContent extends ArObjectContent {
  const TextContent({
    required this.text,
    required this.fontSize,
    required this.textColorArgb,
    required this.backgroundColorArgb,
    required this.horizontalAlign,
    required this.verticalAlign,
    required this.writingDirection,
  });

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(
      text: JsonReader.readString(json, 'text'),
      fontSize: JsonReader.readDouble(json, 'fontSize'),
      textColorArgb: JsonReader.readInt(json, 'textColorArgb'),
      backgroundColorArgb: JsonReader.readInt(json, 'backgroundColorArgb'),
      horizontalAlign: JsonReader.readEnum(
        json,
        'horizontalAlign',
        TextHorizontalAlign.values,
      ),
      verticalAlign: JsonReader.readEnum(
        json,
        'verticalAlign',
        TextVerticalAlign.values,
      ),
      writingDirection: JsonReader.readEnum(
        json,
        'writingDirection',
        WritingDirection.values,
      ),
    );
  }

  final String text;
  final double fontSize;

  /// 文字色（ARGB 32bit）
  final int textColorArgb;

  /// 背景色（ARGB 32bit）
  final int backgroundColorArgb;
  final TextHorizontalAlign horizontalAlign;
  final TextVerticalAlign verticalAlign;
  final WritingDirection writingDirection;

  @override
  ArObjectType get type => ArObjectType.text;

  @override
  Map<String, dynamic> toJson() => {
    'type': type.name,
    'text': text,
    'fontSize': fontSize,
    'textColorArgb': textColorArgb,
    'backgroundColorArgb': backgroundColorArgb,
    'horizontalAlign': horizontalAlign.name,
    'verticalAlign': verticalAlign.name,
    'writingDirection': writingDirection.name,
  };

  TextContent copyWith({
    String? text,
    double? fontSize,
    int? textColorArgb,
    int? backgroundColorArgb,
    TextHorizontalAlign? horizontalAlign,
    TextVerticalAlign? verticalAlign,
    WritingDirection? writingDirection,
  }) {
    return TextContent(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      textColorArgb: textColorArgb ?? this.textColorArgb,
      backgroundColorArgb: backgroundColorArgb ?? this.backgroundColorArgb,
      horizontalAlign: horizontalAlign ?? this.horizontalAlign,
      verticalAlign: verticalAlign ?? this.verticalAlign,
      writingDirection: writingDirection ?? this.writingDirection,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TextContent &&
      other.text == text &&
      other.fontSize == fontSize &&
      other.textColorArgb == textColorArgb &&
      other.backgroundColorArgb == backgroundColorArgb &&
      other.horizontalAlign == horizontalAlign &&
      other.verticalAlign == verticalAlign &&
      other.writingDirection == writingDirection;

  @override
  int get hashCode => Object.hash(
    text,
    fontSize,
    textColorArgb,
    backgroundColorArgb,
    horizontalAlign,
    verticalAlign,
    writingDirection,
  );
}

/// 図形オブジェクトの内容
final class ShapeContent extends ArObjectContent {
  const ShapeContent({required this.shapeType, required this.colorArgb});

  factory ShapeContent.fromJson(Map<String, dynamic> json) {
    return ShapeContent(
      shapeType: JsonReader.readEnum(json, 'shapeType', ShapeType.values),
      colorArgb: JsonReader.readInt(json, 'colorArgb'),
    );
  }

  final ShapeType shapeType;

  /// 図形の色（ARGB 32bit）
  final int colorArgb;

  @override
  ArObjectType get type => ArObjectType.shape;

  @override
  Map<String, dynamic> toJson() => {
    'type': type.name,
    'shapeType': shapeType.name,
    'colorArgb': colorArgb,
  };

  ShapeContent copyWith({ShapeType? shapeType, int? colorArgb}) {
    return ShapeContent(
      shapeType: shapeType ?? this.shapeType,
      colorArgb: colorArgb ?? this.colorArgb,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ShapeContent &&
      other.shapeType == shapeType &&
      other.colorArgb == colorArgb;

  @override
  int get hashCode => Object.hash(shapeType, colorArgb);
}

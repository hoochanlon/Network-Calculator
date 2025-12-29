import 'package:flutter/material.dart';

class ColorTheme {
  final String id;
  final String name;
  final Color primaryColor;
  final bool isDefault;

  const ColorTheme({
    required this.id,
    required this.name,
    required this.primaryColor,
    this.isDefault = false,
  });

  // 预设颜色
  static const ColorTheme neteaseRed = ColorTheme(
    id: 'netease_red',
    name: 'Netease Red',
    primaryColor: Color(0xFFEC4141),
    isDefault: true,
  );

  static const ColorTheme facebookBlue = ColorTheme(
    id: 'facebook_blue',
    name: 'Facebook Blue',
    primaryColor: Color(0xFF1877F2),
  );

  static const ColorTheme spotifyGreen = ColorTheme(
    id: 'spotify_green',
    name: 'Spotify Green',
    primaryColor: Color(0xFF1DB954),
  );

  static const ColorTheme qqMusicYellow = ColorTheme(
    id: 'qq_music_yellow',
    name: 'QQ Music Yellow',
    primaryColor: Color(0xFFFFD700),
  );

  static const ColorTheme bilibiliPink = ColorTheme(
    id: 'bilibili_pink',
    name: 'BiliBili Pink',
    primaryColor: Color(0xFFFF6699),
  );

  static List<ColorTheme> get presets => [
        neteaseRed,
        facebookBlue,
        spotifyGreen,
        qqMusicYellow,
        bilibiliPink,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryColor': primaryColor.value,
      'isDefault': isDefault,
    };
  }

  factory ColorTheme.fromJson(Map<String, dynamic> json) {
    return ColorTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      primaryColor: Color(json['primaryColor'] as int),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}


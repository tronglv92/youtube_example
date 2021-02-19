import 'dart:core';

class Video {
  Video(
      {this.id,
      this.thumbnail,
      this.video,
      this.title,
      this.username,
      this.avatar,
      this.views,
      this.published});

  final int id;
  final String thumbnail;
  final String video;
  final String title;
  final String username;
  final String avatar;
  final int views;
  final DateTime published;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
      id: json['id'] as int,
      thumbnail: json['thumbnail'] as String,
      video: json['video'] as String,
      title: json['title'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String,
      views: json['views'] as int,
      published: json['published'] as DateTime);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'thumbnail': thumbnail,
        'video': video,
        'title': title,
        'username': username,
        'avatar': avatar,
        'views': views,
        'published': published
      };

  @override
  String toString() {
    // TODO: implement toString
    return 'Video{id :$id,thumbnail $thumbnail,video: $video}';
  }
}

List<Video> videos = [
  Video(
      id: 3,
      thumbnail: 'assets/thumbnails/3.jpg',
      video: 'assets/3.mp4',
      title: 'Sending Firebase Data Messages to Expo: iOS',
      username: 'Expo',
      avatar: 'assets/avatars/1.png',
      views: 189,
      published: DateTime.now().subtract(Duration(days: 5))),
  Video(
      id: 1,
      thumbnail: 'assets/thumbnails/1.jpg',
      video: 'assets/1.mp4',
      title: 'React Native Image Picker Tutorial',
      username: 'Expo',
      avatar: 'assets/avatars/1.png',
      views: 63,
      published: DateTime.now().subtract(Duration(days: 10))),
  Video(
      id: 3,
      thumbnail: 'assets/thumbnails/2.jpg',
      video: 'assets/2.mp4',
      title: 'PIXI.js in React Native for beginners',
      username: 'Expo',
      avatar: 'assets/avatars/1.png',
      views: 189,
      published: DateTime.now().subtract(Duration(days: 5))),
  Video(
      id: 4,
      thumbnail: 'assets/thumbnails/4.jpg',
      video: 'assets/1.mp4',
      title: 'Permissions in React Native for absolute beginners',
      username: 'Expo',
      avatar: 'assets/avatars/1.png',
      views: 273,
      published: DateTime.now().subtract(Duration(days: 31))),
];

class Thumbnail {
  String url;
  int width;
  int height;

  Thumbnail({required this.url,required this.width,required this.height});

  factory Thumbnail.fromJson(Map<String,dynamic> json) {

    return Thumbnail(url: json['url'],width: json['width'],height: json['height']);
  }
}
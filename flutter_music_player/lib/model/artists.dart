class Artist {
  String name;
  String? id;

  Artist({required this.name,required this.id});

  factory Artist.fromJson(Map<String,dynamic> json) {
    return Artist(name: json['name'],id: json['id']);
  }

}
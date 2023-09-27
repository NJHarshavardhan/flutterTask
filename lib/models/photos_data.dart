class PhotosData {
  late final int albumId;
  late final int id;
  late final String title;
  late final String url;
  late final String thumbnailUrl;
  late  int quantity;
  late final int price;

  PhotosData(
      {required this.albumId,
      required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl,
        required this.quantity,
        required this.price,
      });

  PhotosData.fromJson(Map<String, dynamic> json) {
    albumId = json['albumId'];
    id = json['id'];
    title = json['title'];
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
    price = json["price"]??200;
    quantity = json["quantity"]??1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumId'] = albumId;
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}

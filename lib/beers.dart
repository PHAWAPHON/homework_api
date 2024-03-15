class Beer {
  final String price;
  final String name;
  final double averageRating;
  final int reviews;
  final String image;
  final int id;

  Beer({
    required this.price,
    required this.name,
    required this.averageRating,
    required this.reviews,
    required this.image,
    required this.id,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      price: json['price'],
      name: json['name'],
      averageRating: json['rating']['average'],
      reviews: json['rating']['reviews'],
      image: json['image'],
      id: json['id'],
    );
  }
}

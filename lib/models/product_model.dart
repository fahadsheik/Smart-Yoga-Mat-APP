class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> categories;
  final double price;
  final double originalPrice;
  final int discountPercentage;
  final double rating;
  final bool isFavorite;
  final bool isNew;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.categories,
    this.price = 0.0,
    this.originalPrice = 0.0,
    this.discountPercentage = 0,
    this.rating = 0.0,
    this.isFavorite = false,
    this.isNew = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      categories: json['categories'] != null
          ? List<String>.from(json['categories'].map((x) => x))
          : [],
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      originalPrice: json['originalPrice'] != null
          ? double.parse(json['originalPrice'].toString())
          : 0.0,
      discountPercentage: json['discountPercentage'] ?? 0,
      rating: json['rating'] != null
          ? double.parse(json['rating'].toString())
          : 0.0,
      isFavorite: json['isFavorite'] ?? false,
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'categories': categories,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'isFavorite': isFavorite,
      'isNew': isNew,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? categories,
    double? price,
    double? originalPrice,
    int? discountPercentage,
    double? rating,
    bool? isFavorite,
    bool? isNew,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isNew: isNew ?? this.isNew,
    );
  }
}

class HomeResponse {
  final List<Product> products;
  final List<String> categories;
  final List<String> banners;

  HomeResponse({
    required this.products,
    required this.categories,
    required this.banners,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      products: json['products'] != null
          ? List<Product>.from(json['products'].map((x) => Product.fromJson(x)))
          : [],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'].map((x) => x))
          : [],
      banners: json['banners'] != null
          ? List<String>.from(json['banners'].map((x) => x))
          : [],
    );
  }
}
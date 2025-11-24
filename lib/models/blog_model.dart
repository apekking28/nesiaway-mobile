class Blog {
  final String id;
  final String title;
  final String category;
  final String body;
  final String banner;
  final List<String> images;

  Blog({
    required this.id,
    required this.title,
    required this.category,
    required this.body,
    required this.banner,
    required this.images,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      body: json['body'] ?? '',
      banner: json['banner'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'body': body,
      'banner': banner,
      'images': images,
    };
  }

  Blog copyWith({
    String? id,
    String? title,
    String? category,
    String? body,
    String? banner,
    List<String>? images,
  }) {
    return Blog(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      body: body ?? this.body,
      banner: banner ?? this.banner,
      images: images ?? this.images,
    );
  }
}

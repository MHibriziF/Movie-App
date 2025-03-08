class Movie {
  final int id;
  final String title;
  final String backDropPath;

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
  });

  factory Movie.fromJson(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      backDropPath: map['backdrop_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'backDropPath': backDropPath,
    };
  }
}

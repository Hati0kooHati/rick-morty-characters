class Character {
  final String imageUrl;
  final String name;
  final String location;
  final String species;
  final String gender;
  final String status;

  const Character({
    required this.imageUrl,
    required this.location,
    required this.name,
    required this.species,
    required this.gender,
    required this.status,
  });

  factory Character.fromJson(Map json) {
    return Character(
      imageUrl: json["image"],
      location: json["location"]["name"],
      name: json["name"],
      species: json["species"],
      status: json["status"],
      gender: json["gender"],
    );
  }
}

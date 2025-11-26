class Flower {
  Flower({
    this.id,
    required this.name,
    required this.scientificName,
    this.picture,
    required this.price,
    required this.color,
    required this.type,
    this.meaning,
    required this.userId,
  });
  String? id;
  String name;
  String scientificName;
  String? picture;
  double price;
  String color;
  String type;
  String? meaning;
  String userId;

  Flower.fromMap(Map<String, dynamic> data)
    : id = data["id"],
      name = data["name"],
      scientificName = data["data"],
      picture = data["picture"] ? (data['picture']) : "",
      price = data["price"],
      color = data["color"],
      type = data["type"],
      meaning = data["meaningColumn"],
      userId = data['userId'];
  //
}

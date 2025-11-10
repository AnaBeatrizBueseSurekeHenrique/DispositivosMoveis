String idColumn = "idColumn";
String nameColumn = "nameColumn";
String scientificNameColumn = "scientificNameColumn";
String pictureColumn = "pictureColumn";
String priceColumn = "priceColumn";
String colorColumn = "colorColumn";
String typeColumn = "typeColumn"; 
String meaningColumn = "meaningColumn";
String flowerTable = "flowerTable";

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
  });
  int? id;
  String name;
  String scientificName;
  String? picture;
  double price;
  String color;
  String type;
  String? meaning;
  Flower.fromMap(Map<String, dynamic> map)
    : id = map[idColumn],
      name = map[nameColumn],
      scientificName = map[scientificNameColumn],
      picture = map[pictureColumn],
      price = map[priceColumn],
      color = map[colorColumn],
      type = map[typeColumn],
      meaning = map[meaningColumn];
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      scientificNameColumn: scientificName,
      pictureColumn: picture,
      priceColumn: price,
      colorColumn: color,
      typeColumn: type,
      meaningColumn: meaning,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Flower(id: $id, name: $name, scientificName: $scientificName, picture: $picture, price: $price, color: $color, type: $type, meaning: $meaning)";
  }
}

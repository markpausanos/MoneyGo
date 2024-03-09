class Category {
  final int id;
  final DateTime dateCreated;
  String name;
  DateTime? dateUpdated;

  Category({required this.id, required this.name})
      : dateCreated = DateTime.now();
}

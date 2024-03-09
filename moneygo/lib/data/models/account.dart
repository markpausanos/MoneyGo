class Account {
  final int id;
  final DateTime dateCreated;
  String name;
  double balance;
  DateTime? dateUpdated;

  Account({required this.id, required this.name})
      : balance = 0.0,
        dateCreated = DateTime.now();
}

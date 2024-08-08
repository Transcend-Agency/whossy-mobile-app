abstract class CustomType implements Enum {
  String get name; // Abstract getter for name
}

class ExtraPreferences<T extends CustomType> {
  final String header;
  final List<Data<T>> items;

  ExtraPreferences({required this.header, required this.items});

  Type get type => T; // Method to get the type
}

class Data<T extends CustomType> {
  final String text;
  final T value;

  Data({required this.text, required this.value});
}

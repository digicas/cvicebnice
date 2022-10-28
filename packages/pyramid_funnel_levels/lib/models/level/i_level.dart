abstract class ILevel {
  const ILevel({required this.index, required this.xid});

  final String xid;
  final int index;

  void generate();

  void regenerate() => generate();

  @override
  String toString();
}

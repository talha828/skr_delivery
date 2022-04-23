class Town{
  final int id;
  final String name;
   Town({  this.id=1, this.name="abc",});

  @override
  String toString() {
    return name;
  }
}
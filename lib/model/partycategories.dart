class PartyCategories {
  String partyCategoriesCode;
  String partyCategoriesName;
  PartyCategories(
      {this.partyCategoriesCode,
        this.partyCategoriesName,
       });
  PartyCategories.fromJson(Map<String, dynamic> json) {
    try {
      partyCategoriesCode = json['CATEGORY'].toString();
      partyCategoriesName = json['CATEGORY'];
      } catch (e) {
      print(e.toString());
    }
  }

  @override
  String toString() {
    return partyCategoriesCode;
  }
}

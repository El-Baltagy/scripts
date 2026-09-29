class PojectsData{
  final String? name;

  const PojectsData({
    this.name,
  });

  factory PojectsData.fromJson(Map<String, dynamic> json) {
    return PojectsData(
      name: json['name'] as String?,
    );
  }


}
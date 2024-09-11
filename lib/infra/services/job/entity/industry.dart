class IndustryResponse {
  final List<IndustryModel> industries;

  const IndustryResponse({
    required this.industries,
  });

  factory IndustryResponse.fromMap(Map<String, dynamic> map) {
    return IndustryResponse(
      industries: List<IndustryModel>.from(
          map['industries']?.map((x) => IndustryModel.fromMap(x))),
    );
  }
}

class IndustryModel {
  final int id;
  final String text;

  const IndustryModel({
    required this.id,
    required this.text,
  });

  factory IndustryModel.fromMap(Map<String, dynamic> map) {
    return IndustryModel(
      id: map['id'],
      text: map['text'],
    );
  }

  @override
  String toString() {
    return 'Industry{id: $id, text: $text}';
  }
}

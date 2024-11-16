class JournalEntry {
  final String title;
  final String content;
  final DateTime date;
  final String? imageUrl;

  JournalEntry({
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}

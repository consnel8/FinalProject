class JournalEntry {
  final String title;
  final String content;
  final DateTime date;
  final String? imageUrl;
  final String? mood;

  JournalEntry({
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
    this.mood,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      imageUrl: json['imageUrl'],
      mood: json['mood'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'mood': mood,
    };
  }
}

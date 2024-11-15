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
}

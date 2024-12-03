class JournalEntry {
  // Required attributes for the journal entry
  final String title; // The title of the journal entry
  final String content; // The main content or body of the journal entry
  final DateTime date; // The date the journal entry was created or recorded

  // Optional attributes
  final String? imageUrl; // URL to an associated image, if any (nullable)
  final String? mood; // Mood or emotion related to the entry, if any (nullable)

  // Constructor to initialize the journal entry object
  JournalEntry({
    required this.title, // Title is mandatory
    required this.content, // Content is mandatory
    required this.date, // Date is mandatory
    this.imageUrl, // Image URL is optional
    this.mood, // Mood is optional
  });

  // Factory constructor to create a JournalEntry object from JSON data
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      title: json['title'], // Maps the 'title' key from JSON to the title property
      content: json['content'], // Maps the 'content' key from JSON to the content property
      date: DateTime.parse(json['date']), // Parses the 'date' key into a DateTime object
      imageUrl: json['imageUrl'], // Maps the 'imageUrl' key, nullable
      mood: json['mood'], // Maps the 'mood' key, nullable
    );
  }

  // Method to convert a JournalEntry object into JSON format
  Map<String, dynamic> toJson() {
    return {
      'title': title, // Adds the title field to the JSON map
      'content': content, // Adds the content field to the JSON map
      'date': date.toIso8601String(), // Serializes the DateTime object to ISO 8601 format
      'imageUrl': imageUrl, // Adds the imageUrl field to the JSON map, if not null
      'mood': mood, // Adds the mood field to the JSON map, if not null
    };
  }
}

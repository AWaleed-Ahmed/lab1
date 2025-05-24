class Note {
  final String title;
  final String content;
  final DateTime date;

  Note({required this.title, required this.content, required this.date});

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'date': date.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    title: json['title'],
    content: json['content'],
    date: DateTime.parse(json['date']),
  );
}

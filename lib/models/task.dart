class Task {
  String title;
  String description;
  String date;
  String time;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'date': date,
    'time': time,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'],
    date: json['date'],
    time: json['time'],
  );
}

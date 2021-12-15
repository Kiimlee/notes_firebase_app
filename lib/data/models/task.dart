class Task {
  String contentMessage;
  bool isChecked;

  Task(this.contentMessage, this.isChecked);

  factory Task.fromJson(Map<String, dynamic> json) => _taskFromJson(json);

  Map<String, dynamic> toJson() => _taskToJson(this);
}

Task _taskFromJson(Map<String, dynamic> json) {
  return Task(json['contentMessage'] as String, json['isChecked'] as bool);
}

Map<String, dynamic> _taskToJson(Task instance) => <String, dynamic>{
      'contentMessage': instance.contentMessage,
      'isChecked': instance.isChecked,
    };

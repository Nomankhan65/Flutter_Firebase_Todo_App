class TaskModel {
  String nodeId;
  String taskName;
  String? name;
  int dt;

  TaskModel({
    required this.nodeId,
    required this.taskName,
    required this.dt,
    this.name,

  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      nodeId: map['nodeId'],
      taskName: map['taskName'],
      name: map['name'],
      dt: map['dt'],
    );
  }
}
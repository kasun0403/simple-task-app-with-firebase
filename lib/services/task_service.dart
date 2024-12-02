import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/models/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection("tasks");

  Future<void> addTask(String name) async {
    try {
      final task = TaskModel(
        id: "",
        createAt: DateTime.now(),
        isUpdated: false,
        name: name,
        updateAt: DateTime.now(),
      );
      //convert task Object to json format
      final Map<String, dynamic> data = task.toJson();

      ///create doc reference and add data to fireabse
      final docReference = await _taskCollection.add(data);
      // update document id using doc references
      await docReference.update({"id": docReference.id});
      print("task added");
    } catch (e) {
      print("Error adding task $e");
    }
  }

  Stream<List<TaskModel>> getTasks() {
    //get tasks form firebase and convert it to List of Task Objects
    return _taskCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            TaskModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<void> deleteTask(String id) async {
    try {
      //delete task from firebase
      await _taskCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting task $e");
    }
  }
}

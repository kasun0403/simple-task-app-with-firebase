import 'package:flutter/material.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/services/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _taskController.dispose();
    super.dispose();
  }

//open dialog box
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: "Enter the task name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancle"),
            ),
            TextButton(
              onPressed: () async {
                await TaskService().addTask(_taskController.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  //open botttom sheet
  void _showBottomSheet(TaskModel task) {
    _taskController.text = task.name;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: "Enter the task name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.purple)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () async {
                        task.name = _taskController.text;
                        task.updateAt = DateTime.now();
                        task.isUpdated = true;

                        await TaskService().updateTask(task);
                        _taskController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text("Update Task"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: TaskService().getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error Loading Tasks"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("no task available"));
          } else {
            final List<TaskModel> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      task.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${task.createAt}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          "${task.updateAt}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await TaskService().deleteTask(task.id);
                      },
                    ),
                    onTap: () {
                      _showBottomSheet(task);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/db/db_provider.dart';
import 'package:todo_app/model/task_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTodo(),
    );
  }
}

class MyTodo extends StatefulWidget {
  MyTodo({Key? key}) : super(key: key);

  @override
  State<MyTodo> createState() => _MyTodoState();
}

class _MyTodoState extends State<MyTodo> {
//color variables
  Color mainColor = const Color(0xFF0d0952);
  Color secondColor = const Color(0xff212061);
  Color btnColor = const Color(0xFFff955b);
  Color editorColor = const Color(0xFF4044cc);

  //textcontroller
  TextEditingController inputController = TextEditingController();
  String newTaskTxt = "";

  //tasks gettin func
  Future<dynamic> getTasks() async {
    final tasks = await DBProvider.dataBase.getTask();
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainColor,
        title: const Text("My To-Do!"),
      ),
      backgroundColor: mainColor,
      body: Column(
        //bottom editor
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTasks(),
              builder: (_, AsyncSnapshot<dynamic> taskData) {
                switch (taskData.connectionState) {
                  case ConnectionState.done: //we got data
                    {
                      if (taskData.data != null) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: taskData.data.length,
                            itemBuilder: (context, index) {
                              String task =
                                  taskData.data[index]['task'].toString();
                              String day = DateTime.parse(
                                      taskData.data[index]['creationDate'])
                                  .day
                                  .toString();
                              int id = taskData.data[index]["id"];

                              return Card(
                                  color: secondColor,
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 18.0),
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: Text(
                                            day,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              task,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                DBProvider.dataBase.delete(id);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "you have no new task today",
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }
                    }

                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            decoration: BoxDecoration(
                color: editorColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: inputController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type a new Task"),
                )),
                const SizedBox(
                  width: 15.0,
                ),
                FlatButton.icon(
                  onPressed: (() {
                    setState(() {
                      newTaskTxt = inputController.text.toString();
                      inputController.text = "";
                    });
                    Task newTask =
                        Task(task: newTaskTxt, dateTime: DateTime.now());
                    DBProvider.dataBase.addNewTask(newTask);
                  }),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Task"),
                  color: btnColor,
                  shape: const StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

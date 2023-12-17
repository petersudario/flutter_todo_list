import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<String> todoList = [];

  final TextEditingController todoController = TextEditingController();
  DateTime now = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Adicione uma tarefa',
                      hintText: 'Ex: Estudar Flutter',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () {
                      String text = todoController.text;
                      setState(() {
                        todoList.add(text);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (String todo in todoList)
                    ListTile(
                      title: Text(todo, style: TextStyle(color: Colors.black),),
                      subtitle: Text(
                          '${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute}'),
                      leading: Icon(
                        Icons.check,
                        size: 30,
                      ),
                    )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Você Possui 0 tarefas pendentes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      todoList.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff00d7f3),
                      padding: EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  child: Text(
                    'Limpar tudo',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

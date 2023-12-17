import 'package:flutter/material.dart';
import 'package:todo_list/repositories/to_do_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

import '../models/todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoRepository todoRepository = TodoRepository();
  final TextEditingController todoController = TextEditingController();

  List<Todo> todoList = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todoList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
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
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xff00d7f3),
                          )),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'A tarefa não pode ficar vazia.';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo =
                              Todo(title: text, date: DateTime.now());
                          todoList.add(newTodo);
                          errorText = null;
                          todoController.clear();
                          todoRepository.saveTodoList(todoList);
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
                    for (Todo todo in todoList)
                      TodoListItem(
                        todo: todo,
                        delete: onDelete,
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'Você Possui ${todoList.length} tarefas pendentes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteAllDialog();
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
      )),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todoList.indexOf(todo);
    setState(() {
      todoList.remove(todo);
      todoRepository.saveTodoList(todoList);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa removida com sucesso!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.white,
        onPressed: () {
          setState(() {
            todoList.insert(deletedTodoPos!, deletedTodo!);
            todoRepository.saveTodoList(todoList);
          });
        },
      ),
    ));
  }

  void deleteAllDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tudo'),
              content: Text(
                  'Tem certeza que deseja apagar todas as tarefas existentes? Esta ação é irreversivel.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        todoList.clear();
                        todoRepository.saveTodoList(todoList);
                      });
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(primary: Colors.red),
                    child: Text('Limpar tudo')),
              ],
            ));
  }
}

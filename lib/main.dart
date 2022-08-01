import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<TodoEntry> _list = List.empty(growable: true);
  final TextEditingController _titleField = TextEditingController();
  final TextEditingController _descriptionField = TextEditingController();

  void _showToast(BuildContext ctx, String txt) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(txt)));
  }

  /// Add the input into the list
  void addTodo(BuildContext ctx) {
    //first check for the input
    if (_titleField.value.text.isEmpty ||
        _descriptionField.value.text.isEmpty) {
      //fire alert dialog
      showDialog(
          context: ctx,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Both the fields are required"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(ctx)
                        .pop(); //pop off the dialog from the navigation tree
                  },
                )
              ],
            );
          });
    } else if (_descriptionField.text.split("\n").length > 3) {
      //fire alert dialog
      showDialog(
          context: ctx,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Description max 3 lines"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(ctx)
                        .pop(); //pop off the dialog from the navigation tree
                  },
                )
              ],
            );
          });
    } else {
      //build the actual entry
      TodoEntry entry = TodoEntry(_titleField.text, _descriptionField.text);
      //clear out the fields
      _titleField.clear();
      _descriptionField.clear();
      _showToast(ctx, "Added");
      setState(() {
        _list.insert(0,entry);
      });
    }
  }

  /// Clear the TODOs
  void clearTODO(BuildContext ctx) {
    _showToast(ctx, "Cleared");
    _titleField.clear();
    _descriptionField.clear();
    setState(() {
      _list.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Divider divider = Divider(
      color: Theme.of(context).primaryColor,
      thickness: 5,
      height: 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              tooltip: "Clear",
              onPressed: () => clearTODO(context),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: ((value) {
                  return (value == null || value.isEmpty)
                      ? "This fleid must not be empty"
                      : null;
                }),
                key: const Key("Title"),
                controller: _titleField,
                maxLines: 1,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return "The field must not be empty";
                  } else if (value.split("\n").length > 3) {
                    return "Maximum 3 lines";
                  } else {
                    return null;
                  }
                }),
                key: const Key("Descripition"),
                controller: _descriptionField,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "Description"),
              ),
              Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) => divider,
                      padding: const EdgeInsets.only(top: 10),
                      itemBuilder: (context, index) => _TodoEntryWidget(
                          key: Key(index.toString()), entry: _list[index]),
                      itemCount: _list.length))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add entry",
        child: const Icon(
          Icons.add,
        ),
        onPressed: () => addTodo(context),
      ),
    );
  }
}

class _TodoEntryWidget extends StatelessWidget {
  final TodoEntry entry;
  const _TodoEntryWidget({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.pink.shade50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox.fromSize(
              size: const Size.fromHeight(12),
            ),
            Text(entry.description, maxLines: 3),
          ],
        ));
  }
}

class TodoEntry {
  final String title, description;
  TodoEntry(this.title, this.description);
}

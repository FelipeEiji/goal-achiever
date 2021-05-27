import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class NewTask extends StatefulWidget {
  final Function addTransaction;

  NewTask(this.addTransaction);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredDescription = descriptionController.text;
    final enteredDate = _selectedDate;

    if (enteredTitle.isEmpty ||
        enteredDescription.isEmpty ||
        _selectedDate == null) {
      return;
    }

    widget.addTransaction(
      context,
      enteredTitle,
      enteredDescription,
      enteredDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now().add(
          Duration(days: 365),
        )).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              controller: descriptionController,
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen!'
                          : 'Date picked: ${formatDate(_selectedDate!, [
                                  dd,
                                  '/',
                                  mm,
                                  '/',
                                  yyyy
                                ])}',
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    onPressed: _presentDatePicker,
                    child: Text('Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: Text('Add task'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_changing_theme/controllers/task_controller.dart';
import 'package:to_do_app_with_changing_theme/models/task.dart';
import 'package:to_do_app_with_changing_theme/screens/theme.dart';
import 'package:to_do_app_with_changing_theme/widgets/custom_button.dart';

import 'custom_text_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  //for selected date
  DateTime _selectedDate = DateTime.now();
  //for start and end date
  String _endTime = '9:30 PM';
  String _startTime = DateFormat('hh:mm a').format(DateTime.now());
  //for remind
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  //for repeat
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  //for color
  int _selectedColor = 0;

  //for controller and validation
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Tasks',
                style: headingStyle,
              ),
              //title
              CustomTextField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              //note
              CustomTextField(
                title: 'Note',
                hint: 'Enter Node here',
                controller: _noteController,
              ),
              //date
              CustomTextField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              //start and end time
              Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                    title: 'Start Date',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(true);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomTextField(
                    title: 'End Date',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(false);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ))
                ],
              ),
              //remind
              CustomTextField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(),
                  style: subTitleStyle,
                  items: remindList
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                          value: e.toString(),
                          child: Text(
                            e.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              //repeat
              CustomTextField(
                title: 'Remind',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(),
                  style: subTitleStyle,
                  items: repeatList
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                          value: e.toString(),
                          child: Text(
                            e.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                ),
              ),
              //submit
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //palette
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color',
                          style: titleStyle,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _colorPallet(),
                      ],
                    ),
                    MyButton(
                        label: 'Create Task',
                        onTap: () {
                          _validateForm();
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //custom appBar
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: (Get.isDarkMode) ? Colors.white : Colors.black,
          ),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: Get.isDarkMode ? Colors.white : Colors.black),
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  //calender date picker
  void _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //date intervals
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );
    //to redraw hint date with the new picker date
    _pickerDate != null
        ? setState(() => _selectedDate = _pickerDate)
        : log('it is null or something else');
  }

  //get start and end time
  void _getTimeFromUser(bool isStartTime) async {
    var _pickedTime = await _showTimePicker();
    String _formattedTime = _pickedTime!.format(context);

    /*
     conditions to know whether formatted date is start or end date
     */
    (isStartTime)
            ? setState(() => _startTime = _formattedTime)
            : (!isStartTime)
                ? setState(() => _endTime = _formattedTime)
                : log('Error process');
  }

  //show time picker method
  Future<TimeOfDay?> _showTimePicker() async{
    return await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(':')[0]),
            minute: int.parse(_startTime.split(':')[1].split(' ')[0])),
        //to input some data
        initialEntryMode: TimePickerEntryMode.input);
  }

  Widget _colorPallet() => Wrap(
        children: List<Widget>.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : yellowClr,
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      )
                    : Container(),
              ),
            ),
          ),
        ),
      );

  void _validateForm() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All Fields are required',
          backgroundColor: context.theme.backgroundColor,
          icon: const Icon(Icons.warning_amber_outlined),
          colorText: pinkClr);
    }
  }

  void _addTaskToDb() async {
    //passing data to model and model to controller
    int value = await _taskController.addTask(Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      color: _selectedColor,
      endTime: _endTime,
      isCompleted: 0,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
    print('id is '+ value.toString());
  }

}

import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_changing_theme/controllers/task_controller.dart';
import 'package:to_do_app_with_changing_theme/models/task.dart';
import 'package:to_do_app_with_changing_theme/screens/theme.dart';
import 'package:to_do_app_with_changing_theme/services/notification_services.dart';
import 'package:to_do_app_with_changing_theme/services/theme_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_app_with_changing_theme/widgets/add_task_bar.dart';
import 'package:to_do_app_with_changing_theme/widgets/custom_button.dart';

import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  //custom appBar
  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          print('tapped');
          ThemeServices().switchTheme();
          // notifyHelper.displayNotification(
          //   title: 'Theme Changed',
          //   body: (!Get.isDarkMode)
          //       ? 'Activated dark mode'
          //       : 'Activated light mode',
          // );
          //to display message after 5 seconds
          // notifyHelper.scheduledNotification();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(
            (Get.isDarkMode) ? Icons.sunny : Icons.nightlight_round,
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

  //custom taskBar

  //custom date picker bar
  Widget _addDateBar() => Container(
        margin: const EdgeInsets.only(top: 20, left: 20),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectedTextColor: Colors.white,
          selectionColor: primaryClr,
          dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          //to set time picker to view all tasks in the right data
          onDateChange: (date) => setState(() => _selectedDate = date)
        ),
      );
  Widget _addTaskBar() => Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(
                      DateTime.now(),
                    ),
                    style: subHeadingStyle,
                  ),
                  Text(
                    'Today',
                    style: headingStyle,
                  ),
                ],
              ),
            ),
            MyButton(
                label: '+ Add Task',
                onTap: () async {
                  //to wait and refresh to get new data
                  await Get.to(() => const AddTaskPage());
                  _taskController.getTasks();
                }),
          ],
        ),
      );

  Widget _showTasks() => Expanded(
        child: Obx(
          () => ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (context, index) {
              Task task = _taskController.taskList[index];
              //render notification based on start time
              DateTime date = DateFormat.jm().parse(task.startTime!);
              var myTime=DateFormat('HH:mm').format(date);
              // print(myTime);
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]),
                int.parse(myTime.toString().split(":")[1]),
                task
              );
              if(task.repeat=='Daily'){
                //repeat it every day
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              //yMd => date in slash format
              if(task.date==DateFormat.yMd().format(_selectedDate)){
                //view it at certain date
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }else{
                //view empty container
                return Container();
              }
            },
          ),
        ),
      );

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.2
          : MediaQuery.of(context).size.height * 0.3,
      color: Get.isDarkMode?darkGreyClr:Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
            ),
          ),
          const Spacer(),
          task.isCompleted==1
              ?Container()
              :_bottomSheetButton(label: 'Task Completed',
              onTap: (){
                // setState(() => task.isCompleted=1);//that's true
                _taskController.markTaskCompleted(task.id!);
                Get.back();
                },
              color: primaryClr,context: context),
          _bottomSheetButton(label: 'Delete Task', onTap: (){
             _taskController.delete(task);
            Get.back();
            },
              color: pinkClr, context: context),
          SizedBox(height: 20,),
          _bottomSheetButton(label: 'Close', onTap: ()=>Get.back(), color: Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!, context: context,isClosed: true)
        ],
      ),
    ));
  }
}
Widget _bottomSheetButton({required String label, required VoidCallback onTap, required Color color, bool isClosed=false,required BuildContext context})=>
    GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width*0.9,
          decoration: BoxDecoration(
            color: isClosed?Colors.white:color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: isClosed?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:color
            )
          ),
          child: Center(child: Text(label,style: isClosed?titleStyle.copyWith(color: Colors.black,):titleStyle.copyWith(color: Colors.white),)),
        ));

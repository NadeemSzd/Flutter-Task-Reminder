import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder_app/db_Manager.dart';
import 'package:task_reminder_app/screens/home.dart';

class AddAlarm extends StatefulWidget
{

  static TextEditingController reminderController = new TextEditingController();
  static Reminder _reminder;
  static int updateIndex;


  @override
  _AddAlarmState createState() => _AddAlarmState();

  void updateValue(Reminder reminder)
  {
    AddAlarm._reminder = reminder;
  }
}

class _AddAlarmState extends State<AddAlarm>
{

  BoxDecoration myBoxDecoration()
  {
    return BoxDecoration(
      border: Border.all(width: 1,color: Colors.black38),
      borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  DateTime _dateTime;
  TimeOfDay _time;

  // DB
  DataBase_Manager dataBase_Manager = new DataBase_Manager();

  String reminder="";
  String time_AND_date="";
  String times = "";
  String dates = "";

  @override
  Widget build(BuildContext context)
  {

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Alarm'),
      ),

      body: Container(
        margin: EdgeInsets.all(40),
        child: ListView(
          children: <Widget>[

            Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Center(child: Text('Reminder App',
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),))),

            Container(
                child: TextField(
                  controller: AddAlarm.reminderController,
                  decoration: InputDecoration(
                        labelText:'Enter Reminder',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7)
                        )
                  ),
                )
            ),

            Container(
              margin:  EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Text('Time'),
                      width: MediaQuery.of(context).size.width*0.35,
                  ),
                  Container(
                    child: Text('Date'),
                    width: MediaQuery.of(context).size.width*0.35,
                  ),
                ],
              ),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.35,
                  child: RaisedButton(
                    onPressed: ()
                    {
                      showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time)
                      {
                        setState(()
                        {
                          _time = time;
                          times = localizations.formatTimeOfDay(time);
                        });

                      });
                    },
                    child: Text(_time==null ? 'Time' : localizations.formatTimeOfDay(_time)),
                  ),
                ),

                  Container(
                    width: MediaQuery.of(context).size.width*0.35,
                    child: RaisedButton(
                      onPressed: ()
                      {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2025)
                        ).then((date){

                            setState(() {
                              _dateTime = date;
                              dates = DateFormat('yyyy-MM-dd').format(_dateTime);
                            });

                        });
                      },
                      child: Text(_dateTime==null?'Date':DateFormat('yyyy-MM-dd').format(_dateTime)),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  _saveDataInToReminderDataBase(context);
                },
                child: Text('Save'),
              ),
            ),

          ],
        ),
      ),

    );
  }

  void _saveDataInToReminderDataBase(BuildContext context) // remove context parameter if it gives context related error
  {
     if(AddAlarm._reminder == null)
       {
         String reminder = AddAlarm.reminderController.text;
         if(reminder.isNotEmpty)
           {
             //time_AND_date = dates + times;

             AddAlarm._reminder = new Reminder(reminder: reminder,date: dates,time: times);
             dataBase_Manager.insertReminder(AddAlarm._reminder).then((id)
             {
               print("Reminder id -----> $id");
               print(dates);
               print(times);
               print(AddAlarm.reminderController.text);
               AddAlarm.reminderController.clear();
               AddAlarm._reminder = null;
             });

             setState(()
             {
               AllReminders.reminderList.add(AddAlarm._reminder);
             });

           }
       }
     else
       {
         AddAlarm._reminder.reminder = AddAlarm.reminderController.text;

         dataBase_Manager.updateReminder(AddAlarm._reminder).then((id)
         {

           setState(()
           {
             AllReminders.reminderList[AddAlarm.updateIndex].reminder = AddAlarm.reminderController.text;
           });

           AddAlarm.reminderController.clear();
           AddAlarm._reminder = null;
         });
       }
  }
}


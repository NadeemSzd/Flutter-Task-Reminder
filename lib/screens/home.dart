import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder_app/constants.dart';
import 'package:task_reminder_app/db_Manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'add_alarm.dart';

class AllReminders extends StatefulWidget
{

  static List<Reminder> reminderList;

  @override
  _AllRemindersState createState() => _AllRemindersState();
}

class _AllRemindersState extends State<AllReminders>
{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState()
  {
    super.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android  = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,onSelectNotification: SelectNotification );
  }

  Future SelectNotification(String payload)
  {
    showDialog(context: context,builder: (_)=>new AlertDialog(
      title: Text('Congratulation...'),
      content: Column(
        children: <Widget>[
          Text('Notification is shown'),
        ],
      ),
    ));
  }

  DataBase_Manager _dataBase_Manager = new DataBase_Manager();
  String byFaultMessage = 'No Reminders';
  bool isDataPresent = true;

  BoxDecoration myBoxDecoration()
  {
    return BoxDecoration(
      border: Border.all(width: 2,color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  BoxDecoration myCustomBoxDecoration()
  {
    return BoxDecoration(
      border: Border(right: BorderSide(width: 0.5,color: Colors.black),left: BorderSide(width: 0.5,color: Colors.black))
    );
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
     // backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text('Remind Me',style: TextStyle(fontSize: 22),),
            Text('All Reminders',style: TextStyle(fontSize: 17,color: Colors.white70),),
          ],
        ),

        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: selectChoices,
            itemBuilder: (BuildContext context)
            {
              return Constants.choices.map((String choice)
              {
                 return PopupMenuItem<String>(
                   value: choice,
                   child: Text(choice),
                 );
              }).toList();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          //showNotification();
          Navigator.push(context, MaterialPageRoute(builder: (_)=> AddAlarm()));
        },
        child: Icon(Icons.add),
      ),

      body: FutureBuilder(
        future: _dataBase_Manager.getReminderList(),
        builder: (context,snapshot)
        {
          if(snapshot.hasData)
          {
            AllReminders.reminderList = snapshot.data;

            if(AllReminders.reminderList.length==0)
              {
                return Container(child: Center(child: Text('No Reminder',style: TextStyle(fontSize: 20.0,color: Colors.black45),),),);
              }
            else
            return ListView.builder(
                itemCount: AllReminders.reminderList == null ? 0 : AllReminders.reminderList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context,int index)
                {
                  Reminder rem = AllReminders.reminderList[index];

                  //_dateTime = DateTime.parse(rem.dateTime);
                  //_date = DateFormat('yyyy-MM-dd').format(_dateTime);
                  //_time = ;

                  return  Container(
                    margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 2.0),
                    child: Card(
                      color: Colors.blueGrey,
                      child: Row(
                        children: <Widget>[

                          // Alarm Icon
                          Container(

                              margin: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Icon(Icons.alarm,color: Colors.white,)
                          ),

                          Container(
                            decoration: myCustomBoxDecoration(),
                            width: MediaQuery.of(context).size.width*0.572,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(rem.reminder,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                SizedBox(height: 7,),
                                Row(
                                  children: <Widget>[
                                    Text(rem.time,style: TextStyle(color: Colors.white),),
                                    SizedBox(width: 25,),
                                    Text(rem.date,style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: ()
                            {
                               AddAlarm.reminderController.text = rem.reminder;
                               AddAlarm add = new AddAlarm();
                               add.updateValue(rem);
                               AddAlarm.updateIndex = index;

                               Navigator.push(context, MaterialPageRoute(builder: (_)=> AddAlarm()));
                            },
                            icon: Icon(Icons.edit,color: Colors.white,),
                          ),
                          IconButton(
                            onPressed: ()
                            {
                               _dataBase_Manager.deleteReminder(rem.id);
                               print(rem.reminder);
                               setState(() {
                               AllReminders.reminderList.removeAt(index);
                               });
                            },
                            icon: Icon(Icons.delete,color: Colors.white,),
                          ),
                        ],
                      ),
                    ),
                  ) ;
                });
          }
          return Container(
              alignment:Alignment.center,
              child: new CircularProgressIndicator()
          );
        },
      ),

    );
  }

  void selectChoices(String choice)
  {
    if(choice == Constants.setting)
      {
        print('Settings');
      }
    else if(choice == Constants.help)
    {
      print('Help');
    }
    else if(choice == Constants.aboutUs)
    {
      print('About Us');
    }
  }

  void showNotification() async
  {
    var android = new AndroidNotificationDetails('channel id', 'channelName', 'channelDescription');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android,ios);
    await flutterLocalNotificationsPlugin.show(0, 'Alert!', 'do not miss that', platform);
  }

}

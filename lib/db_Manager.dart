import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';


class DataBase_Manager
{
   // create objects of database
  Database _database;
  String database_Name = 'AllReminders';


  // create database
  Future openDataBase() async
  {
    if(_database==null)
      {
         _database = await openDatabase(
           join(await getDatabasesPath(),'AllReminders.db'),
           version: 1,
           onCreate: (Database database,int version) async
           {
             await database.execute("CREATE TABLE AllReminders(id INTEGER PRIMARY KEY AUTOINCREMENT,reminder TEXT,date TEXT,time TEXT)");
           }
         );
      }
  }

  // insert data into SqFLite Database
  Future<int> insertReminder(Reminder reminder) async
  {
    await openDataBase();
    return await _database.insert(database_Name, reminder.toMap());
  }


  Future<List<Reminder>> getReminderList() async
  {
    await openDataBase();

    final List<Map<String,dynamic>> map = await _database.query(database_Name);

    return List.generate(map.length, (index){
      return Reminder(
        id: map[index]['id'],
        reminder: map[index]['reminder'],
        date: map[index]['date'],
        time: map[index]['time']
      );
    });
  }


  Future<int> updateReminder(Reminder reminder) async
  {
    await openDataBase();
    return await _database.update(database_Name, reminder.toMap(),where: 'id=?',whereArgs: [reminder.id]);
  }

  Future<void> deleteReminder(int id) async
  {
    await openDataBase();
    await _database.delete(database_Name,where: 'id=?',whereArgs: [id]);
  }

}

class Reminder
{
  int id;
  String reminder;
  String date;
  String time;

  Reminder({this.id,@required this.reminder,@required this.date,@required this.time});

  Map<String,dynamic> toMap()
  {
    return {'reminder':reminder,'date':date,'time':time};
  }

}


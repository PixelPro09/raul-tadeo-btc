import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'tables.dart';

part 'database.g.dart';

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path,'events.sqlite'));

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Events])
class AppDb extends _$AppDb{
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Event>> getEvents() async{
    return await select(events).get();
  }

  Future<int> insertEvent(EventsCompanion entity) async{
    return await into(events).insert(entity);
  }
}
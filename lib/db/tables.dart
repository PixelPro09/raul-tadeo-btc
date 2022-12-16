import 'package:drift/drift.dart';

class Events extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get desc => text()();
}
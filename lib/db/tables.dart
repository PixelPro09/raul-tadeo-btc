import 'package:drift/drift.dart';

class Events extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get compraoventa => text()();
  TextColumn get datadelaordre => text()();
  IntColumn get cantidad => integer()();
  IntColumn get comisio => integer()();

}
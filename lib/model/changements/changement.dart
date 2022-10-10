import 'package:hive_flutter/hive_flutter.dart';

import 'changement_type.dart';

part 'changement.g.dart';

@HiveType(typeId: 1)
class Changement extends HiveObject {
  @HiveField(0)
  DateTime dateChange;
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime? oldDate;
  @HiveField(3)
  DateTime? newDate;
  @HiveField(4)
  String changementTypeString;
  @HiveField(5)
  bool changeSaw = false;

  Changement(this.name, this.changementTypeString, this.dateChange,
      this.oldDate, this.newDate);

  set changementType(ChangementType value) {
    changementTypeString = value.valueAsString;
  }

  ChangementType get changementType => getChangementType(changementTypeString);
  @override
  String toString() {
    return "$name, $changementType, $oldDate, $newDate";
  }
}

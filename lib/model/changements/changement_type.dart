enum ChangementType {
  add,
  delete,
  move;
}

extension ChangementTypeX on ChangementType {
  String get valueAsString => toString();
}

ChangementType getChangementType(String type) {
  if (type == ChangementType.add.toString()) {
    return ChangementType.add;
  } else if (type == ChangementType.move.toString()) {
    return ChangementType.move;
  }
  return ChangementType.delete;
}

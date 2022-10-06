import 'package:agenda_lyon1/model/calendrier.dart';
import 'package:agenda_lyon1/model/event_calendrier.dart';
import 'package:test/test.dart';

final List<EventCalendrier> oldEvents = [
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 8), const Duration(hours: 5),
      "A", [""], " ", "qsdfgn"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 9), const Duration(hours: 7),
      "B", [""], "", "tgu;hj,sbgqd"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 9), const Duration(hours: 5),
      "C", [""], "", "qsfdqrth"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 11), const Duration(hours: 3),
      "D", [""], " ", "zrtgzreg"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 14), const Duration(hours: 4),
      "E", [""], "", "wxcvdxbrths"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 20), const Duration(hours: 2),
      "F", [""], "", "azaetdycfsqds"),
];

final List<EventCalendrier> newEvents = [
  EventCalendrier.data(DateTime.utc(2000, 9, 18, 9), const Duration(hours: 7),
      "B", [""], "", "tgu;hj,sbgqd"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 9), const Duration(hours: 5),
      "C", [""], "", "qsfdqrth"),
  EventCalendrier.data(DateTime.utc(2022, 9, 20, 11), const Duration(hours: 3),
      "D", [""], " ", "zrtgzreg"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 14), const Duration(hours: 4),
      "E", [""], "", "wxcvdxbrths"),
  EventCalendrier.data(DateTime.utc(2022, 10, 18, 13), const Duration(hours: 2),
      "F", [""], "", "azaetdycqzegzefzfefsqds"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 20), const Duration(hours: 2),
      "G", [""], "", "azaetdycqsfddwdvwvxfsqds"),
];

void main() {
  const calStr = """BEGIN:VCALENDAR
METHOD:REQUEST
PRODID:-//ADE/version 6.0
VERSION:2.0
CALSCALE:GREGORIAN
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220913T120000Z
DTEND:20220913T140000Z
SUMMARY:R3.13 communication professionnelle-TD G1
LOCATION:S21
DESCRIPTION:\n\nG1S3\nDEBOUTE JOCELYNE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d34393631382d302d36
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220914T080000Z
DTEND:20220914T100000Z
SUMMARY:R3.03 Analyse-TD G1
LOCATION:S24
DESCRIPTION:\n\nG1S3\nFACI NOURA\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d35313035372d302d33
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220913T110000Z
DTEND:20220913T120000Z
SUMMARY:0Présentation SAE
LOCATION:Amphi1
DESCRIPTION:\n\nS3\nJOUBERT AUDE\nJALOUX CHRISTOPHE\nDESLANDRES VERONIQUE
 \nNDIAYE SAMBA NDOJH\nLEROUX STEPHANE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d3132303733312d302d30
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220915T060000Z
DTEND:20220915T080000Z
SUMMARY:R3.01-1 Développement Web  : PHP-TD G1
LOCATION:S24
DESCRIPTION:\n\nG1S3\nBELFADEL ABDELHADI\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d31383431382d302d34
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220916T080000Z
DTEND:20220916T100000Z
SUMMARY:R3.06 Archi. Réseaux-TD G1
LOCATION:040
DESCRIPTION:\n\nG1S3\nMERRHEIM XAVIER\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d32343835312d302d31
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220913T060000Z
DTEND:20220913T080000Z
SUMMARY:R3.03 Analyse-TD G1
LOCATION:S03
DESCRIPTION:\n\nG1S3\nFACI NOURA\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d35313035372d312d31
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220913T080000Z
DTEND:20220913T100000Z
SUMMARY:R3.10 Management des SI-TD G1
LOCATION:S10
DESCRIPTION:\n\nG1S3\nDUFOUR KARLINE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d35343235312d312d35
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220912T080000Z
DTEND:20220912T100000Z
SUMMARY:R3.13 communication professionnelle-TD G1
LOCATION:S24
DESCRIPTION:\n\nG1S3\nDEBOUTE JOCELYNE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d34393631382d302d31
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220916T113000Z
DTEND:20220916T133000Z
SUMMARY:R3.08 Probabilités-TD G1
LOCATION:S11
DESCRIPTION:\n\nG1S3\nJOUBERT AUDE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d32393039372d312d31
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220916T133000Z
DTEND:20220916T153000Z
SUMMARY:R3.12 Anglais-TP G1A
LOCATION:028
DESCRIPTION:\n\nG1S3A\nGARACCI DANIEL\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d34363638322d302d34
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220914T120000Z
DTEND:20220914T140000Z
SUMMARY:R3.07 SQL et Programmation-TD G1
LOCATION:S14
DESCRIPTION:\n\nG1S3\nBARON ARIANE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d35323432372d302d38
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220916T060000Z
DTEND:20220916T080000Z
SUMMARY:R3.07 SQL et Programmation-TD G1
LOCATION:S24
DESCRIPTION:\n\nG1S3\nBARON ARIANE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d35323432372d302d39
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220912T060000Z
DTEND:20220912T080000Z
SUMMARY:R3.05 Programmation système-TD G1
LOCATION:S16
DESCRIPTION:\n\nG1S3\nGUERIN ESTHER\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d35313335322d302d31
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220915T080000Z
DTEND:20220915T100000Z
SUMMARY:R3.10 Management des SI-TD G1
LOCATION:S12
DESCRIPTION:\n\nG1S3\nDUFOUR KARLINE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d35343235312d302d36
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220914T060000Z
DTEND:20220914T080000Z
SUMMARY:R3.01-1 Développement Web  : PHP-TD G1
LOCATION:S17
DESCRIPTION:\n\nG1S3\nBELFADEL ABDELHADI\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d31383431382d312d34
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20220912T202731Z
DTSTART:20220912T120000Z
DTEND:20220912T140000Z
SUMMARY:R3.08 Probabilités-TD G1
LOCATION:S11
DESCRIPTION:\n\nG1S3\nJOUBERT AUDE\n(Exported :12/09/2022 22:27)\n
UID:ADE6050726f6a65745f323032322d323032332d32393039372d302d31
CREATED:19700101T000000Z
LAST-MODIFIED:20220912T202731Z
SEQUENCE:-2069386445
END:VEVENT
END:VCALENDAR""";

  final cal = Calendrier.load(calStr);
  test("devrais y avoir 16 events", () {
    expect(cal.size, 16);
  });

  test("détection Changement", () {
    final oldCal = Calendrier(oldEvents);
    final newCal = Calendrier(newEvents);

    final changes = oldCal.getChangementTo(newCal);
    expect(changes.length, 5);
    expect(changes[0].name, "A");
    expect(changes[0].changementType, ChangementType.delete);
    expect(changes[1].name, "G");
    expect(changes[1].changementType, ChangementType.add);
    expect(changes[2].name, "B");
    expect(changes[2].changementType, ChangementType.move);
    expect(changes[3].name, "D");
    expect(changes[3].changementType, ChangementType.move);
    expect(changes[4].name, "F");
    expect(changes[4].changementType, ChangementType.move);
  });
}

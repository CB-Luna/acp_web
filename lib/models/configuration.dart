import 'dart:convert';

class Configuration {
  Configuration({
    required this.light,
    required this.dark,
  });

  Mode light;
  Mode dark;

  factory Configuration.fromJson(String str) =>
      Configuration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Configuration.fromMap(Map<String, dynamic> json) => Configuration(
        light: Mode.fromMap(json["light"]),
        dark: Mode.fromMap(json["dark"]),
      );

  Map<String, dynamic> toMap() => {
        "light": light.toMap(),
        "dark": dark.toMap(),
      };
}

class Mode {
  Mode({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.primaryText,
    required this.primaryBackground,
  });

  int primaryColor;
  int secondaryColor;
  int tertiaryColor;
  int primaryText;
  int primaryBackground;

  factory Mode.fromJson(String str) => Mode.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mode.fromMap(Map<String, dynamic> json) {
    return Mode(
      primaryColor: int.parse(json["primaryColor"]),
      secondaryColor: int.parse(json["secondaryColor"]),
      tertiaryColor: int.parse(json["tertiaryColor"]),
      primaryText: int.parse(json["primaryText"]),
      primaryBackground: int.parse(json["primaryBackground"]),
    );
  }

  Map<String, String> toMap() => {
        "primaryColor": '0x${primaryColor.toRadixString(16).toUpperCase()}',
        "secondaryColor": '0x${secondaryColor.toRadixString(16).toUpperCase()}',
        "tertiaryColor": '0x${tertiaryColor.toRadixString(16).toUpperCase()}',
        "primaryText": '0x${primaryText.toRadixString(16).toUpperCase()}',
        "primaryBackground":
            '0x${primaryBackground.toRadixString(16).toUpperCase()}',
      };
}

class Dashboard {
  Dashboard({
    required this.title,
    required this.ttlGraph1,
    required this.marcGraph1,
    required this.ttlGraph2,
    required this.marcGraph2,
    required this.marcTable,
  });

  String title;
  String ttlGraph1;
  List<MarcGraph> marcGraph1;
  String ttlGraph2;
  List<MarcGraph> marcGraph2;
  List<String> marcTable;

  factory Dashboard.fromJson(String str) => Dashboard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dashboard.fromMap(Map<String, dynamic> json) => Dashboard(
        title: json["Title"],
        ttlGraph1: json["ttlGraph1"],
        marcGraph1: List<MarcGraph>.from(
            json["marcGraph1"].map((x) => MarcGraph.fromMap(x))),
        ttlGraph2: json["ttlGraph2"],
        marcGraph2: List<MarcGraph>.from(
            json["marcGraph2"].map((x) => MarcGraph.fromMap(x))),
        marcTable: List<String>.from(json["marcTable"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "Title": title,
        "ttlGraph1": ttlGraph1,
        "marcGraph1": List<dynamic>.from(marcGraph1.map((x) => x.toMap())),
        "ttlGraph2": ttlGraph2,
        "marcGraph2": List<dynamic>.from(marcGraph2.map((x) => x.toMap())),
        "marcTable": List<dynamic>.from(marcTable.map((x) => x)),
      };
}

class MarcGraph {
  MarcGraph({
    required this.marc1,
    required this.marc2,
    required this.marc3,
    required this.marc4,
    required this.marc5,
  });

  Marc marc1;
  Marc marc2;
  Marc marc3;
  Marc marc4;
  Marc marc5;

  factory MarcGraph.fromJson(String str) => MarcGraph.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MarcGraph.fromMap(Map<String, dynamic> json) => MarcGraph(
        marc1: Marc.fromMap(json["marc1"]),
        marc2: Marc.fromMap(json["marc2"]),
        marc3: Marc.fromMap(json["marc3"]),
        marc4: Marc.fromMap(json["marc4"]),
        marc5: Marc.fromMap(json["marc5"]),
      );

  Map<String, dynamic> toMap() => {
        "marc1": marc1.toMap(),
        "marc2": marc2.toMap(),
        "marc3": marc3.toMap(),
        "marc4": marc4.toMap(),
        "marc5": marc5.toMap(),
      };
}

class Marc {
  Marc({
    required this.txt,
    required this.color,
  });

  String txt;
  String color;

  factory Marc.fromJson(String str) => Marc.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Marc.fromMap(Map<String, dynamic> json) => Marc(
        txt: json["txt"],
        color: json["color"],
      );

  Map<String, dynamic> toMap() => {
        "txt": txt,
        "color": color,
      };
}

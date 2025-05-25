//หน้าที่ของไฟล์นี้คือ
// 1. เอาไว้แพ็คข้อมูล
// 2. เอาไว้แปลงข้อมูลเป็น JSON ชเพื่อส่งไปยัง API
// 3. เอาไว้แปลงข้อมูลจาก JSON ที่ได้จาก API เพื่อใช้งานในแอป
// https://javiercbk.github.io/json_to_dart/

class Run {
  int? runId;
  String? runLocation;
  double? runDistance;
  int? runTime;

  Run({this.runId, this.runLocation, this.runDistance, this.runTime});

  Run.fromJson(Map<String, dynamic> json) {
    runId = json['runId'];
    runLocation = json['runLocation'];
    runDistance = double.parse(json['runDistance'].toString());
    runTime = json['runTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['runId'] = this.runId;
    data['runLocation'] = this.runLocation;
    data['runDistance'] = this.runDistance;
    data['runTime'] = this.runTime;
    return data;
  }
}

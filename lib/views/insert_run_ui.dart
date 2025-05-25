import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_run_record_app/models/run.dart';

class InsertRunUI extends StatefulWidget {
  const InsertRunUI({super.key});

  @override
  State<InsertRunUI> createState() => _InsertRunUIState();
}

class _InsertRunUIState extends State<InsertRunUI> {
  //สร้างตัวควบคุม TexField
  TextEditingController runLocationCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();
  TextEditingController runTimeCtrl = TextEditingController();

  // dialog warning function
  Future<void> _showWarningDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //dialog show Result function

  Future<void> _showResultDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ผลการดำเนินการ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Add My Run',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          //เมื่อแตะที่หน้าจอจะทำให้คีย์บอร์ดหายไป
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 35.0,
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 60.0,
                  ),
                  Image.asset(
                    'assets/images/running.png',
                    width: 180.0,
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'สถานที่วิ่ง',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: runLocationCtrl,
                    decoration: InputDecoration(
                      hintText: 'กรุณากรอกสถานที่วิ่ง',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ระยะทางที่วิ่ง (กิโลเมตร)',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: runDistanceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'กรุณากรอกระยะทางที่วิ่ง',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'เวลาที่ใช้ในการวิ่ง (นาที)',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: runTimeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'กรุณากรอกเวลาที่ใช้ในการวิ่ง',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //ตรวจสอบว่ามีการกรอกข้อมูลครบถ้วนหรือไม่
                      if (runLocationCtrl.text.isEmpty) {
                        //แสดงไดอะล็อกคำเตือน
                        await _showWarningDialog('กรุณากรอกสถานที่ิวิ่งด้วย');
                      } else if (runDistanceCtrl.text.isEmpty) {
                        await _showWarningDialog('กรุณากรอกระยะทางวิ่งด้วย');
                      } else if (runTimeCtrl.text.isEmpty) {
                        await _showWarningDialog('กรุณาระยะเวลาในการวิ่งด้วย');
                      } else {
                        //ส่งข้อมูลไปบันทึกที่ฐานข้อมูล ผ่าน API
                        //แพ็คข้อมูลที่จะส่ง
                        Run run = Run(
                          runLocation: runLocationCtrl.text,
                          runDistance: double.parse(runDistanceCtrl.text),
                          runTime: int.parse(runTimeCtrl.text),
                        );

                        //ส่งข้อมูลโดยเอาข้อมูลที่จะส่งมาให้เป็นJSON
                        final result = await Dio().post(
                            'http://10.1.1.33:6000/api/run',
                            data: run.toJson());
                        //ตรวจสอบผลลัพธ์ที่ได้จากการบันทึก
                        if (result.statusCode == 201) {
                          await _showResultDialog('บันทึกการวิ่งเรียบร้อยแล้ว')
                              .then((value) {
                            //เมื่อบันทึกเสร็จแล้วให้กลับไปที่หน้าหลัก
                            Navigator.pop(context);
                          });
                        } else {
                          await _showResultDialog('บันทึกการวิ่งไม่สำเร็จ');
                        }
                      }
                    },
                    child: Text(
                      'บันทึกการวิ่ง',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        60.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

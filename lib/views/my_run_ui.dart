import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_run_record_app/models/run.dart';
import 'package:flutter_run_record_app/views/insert_run_ui.dart';
import 'package:flutter_run_record_app/views/up_del_run_ui.dart';

class MyRunUI extends StatefulWidget {
  const MyRunUI({super.key});

  @override
  State<MyRunUI> createState() => _MyRunUIState();
}

class _MyRunUIState extends State<MyRunUI> {
  //สร้างตัวแปรเพื่อเก็บข้อมูลการวิ่งที่ดึงมาจากฐานข้อมูลผ่าน API
  late Future<List<Run>> myRuns;

  //Create method to fetch runs from API
  Future<List<Run>> fetchMyRuns() async {
    // code to fetch runs from API
    try {
      final response = await Dio().get('http://10.1.1.33:6000/api/run');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['result'] as List<dynamic>;

        return data.map((json) => Run.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load runs');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load runs: ${e.message}');
    }
  }

  @override
  void initState() {
    // when the widget is initialized, fetch the runs from API
    myRuns = fetchMyRuns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'My Run Record',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/images/running.png',
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<List<Run>>(
              future: myRuns,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Run> runs = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: runs.length,
                      itemBuilder: (context, index) {
                        Run run = runs[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpDelRunUI(
                                  runId: run.runId,
                                  runLocation: run.runLocation,
                                  runDistance: run.runDistance,
                                  runTime: run.runTime,
                                ),
                              ),
                            ).then((value) {
                              // Refresh the runs after updating
                              setState(() {
                                myRuns = fetchMyRuns();
                              });
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.lightBlue,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          title: Text(
                            'สถานที่วิ่ง: ' + run.runLocation!,
                          ),
                          subtitle: Text(
                            'ระยะทางวิ่ง: ' +
                                run.runDistance!.toString() +
                                ' km',
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.lightBlue),
                          tileColor:
                              index % 2 == 0 ? Colors.white : Colors.grey[200],
                        );
                      },
                    ),
                  );
                } else {
                  return const Text('No runs found.');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertRunUI(),
            ),
          ).then((value) {
            // Refresh the runs after adding a new run
            setState(() {
              myRuns = fetchMyRuns();
            });
          });
        },
        label: Text(
          'Add My Run',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

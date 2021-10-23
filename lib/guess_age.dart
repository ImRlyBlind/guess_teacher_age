import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:guess_teacher_age/models_and_service/api.dart';
import 'package:http/http.dart' as http;

class GuessTeacherAge extends StatefulWidget {
  const GuessTeacherAge({Key? key}) : super(key: key);

  @override
  _GuessTeacherAgeState createState() => _GuessTeacherAgeState();
}

class _GuessTeacherAgeState extends State<GuessTeacherAge> {
  var _year = 0.0;
  var _month = 0.0;
  var _isCorrect = false;
  var _loading = false;

  _changeYear(double value) {
    setState(() {
      _year = value;
    });
  }

  _changeMonth(double value) {
    setState(() {
      _month = value;
    });
  }

  Future<void> _sendData() async {
    setState(() {
      _loading = true;
    });
    var data = (await API().submit('guess_teacher_age', {
      'year': _year.toInt(),
      'month': _month.toInt(),
    })) as Map<String, dynamic>;
    if (data['value'] == true) {
      setState(() {
        _isCorrect = true;
      });
    } else if (data['value'] == false) {
      _showDialogMsg('ผลการทาย', data['text']);
    }
    setState(() {
      _loading = false;
    });
  }

  void _showDialogMsg(String title, String body) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(
              body,
              style: TextStyle(fontSize: 35),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // ปิด dialog
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GUESS TEACHER'S AGE"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.redAccent,
              Colors.greenAccent,
            ],
          ),
        ),
        child: Container(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: Text(
                          'อายุอาจารย์',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  if (!_isCorrect)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        color: Colors.amberAccent,
                        elevation: 10,
                        child: Column(
                          children: [
                            SpinBox(
                              decoration: InputDecoration(labelText: 'ปี'),
                              textStyle: TextStyle(fontSize: 35),
                              min: 0,
                              max: 100,
                              value: 0,
                              onChanged: (value) => _changeYear(value),
                            ),
                            SpinBox(
                              decoration: InputDecoration(labelText: 'เดือน'),
                              textStyle: TextStyle(fontSize: 35),
                              min: 0,
                              max: 11,
                              value: 0,
                              onChanged: (value) => _changeMonth(value),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: _sendData,
                                child: const Text(
                                  'ทาย',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "${_year.toInt()} ปี ${_month.toInt()} เดือน",
                                style: TextStyle(fontSize: 35),
                              ),
                              Icon(
                                Icons.check,
                                size: 100,
                                color: Colors.yellowAccent,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                ],
              ),
              if (_loading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

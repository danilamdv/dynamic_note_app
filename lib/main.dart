import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, hintColor: Colors.purple),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String courseName;
  int courseCredit = 1;
  double courseGradeValue = 4;
  late List<Course> allCourses;
  static int counter = 0;

  var formKey = GlobalKey<FormState>();
  double average = 0;

  @override
  void initState() {
    super.initState();
    allCourses = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Calculate Average"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return buildBody();
        } else {
          return buildBodyLandscape();
        }
      }),
    );
  }

  Widget buildBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Container holding the static form
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Course Name",
                      hintText: "Enter the course name",
                      hintStyle: TextStyle(fontSize: 18),
                      labelStyle: TextStyle(fontSize: 22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    validator: (enteredValue) {
                      if (enteredValue!.length > 0) {
                        return null;
                      } else
                        return "Course name cannot be empty";
                    },
                    onSaved: (valueToSave) {
                      courseName = valueToSave!;
                      setState(() {
                        allCourses.add(Course(courseName, courseGradeValue,
                            courseCredit, generateRandomColor()));
                        average = 0;
                        calculateAverage();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: courseCreditItems(),
                            value: courseCredit,
                            onChanged: (selectedCredit) {
                              setState(() {
                                courseCredit = selectedCredit!;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: courseGradeItems(),
                            value: courseGradeValue,
                            onChanged: (selectedGrade) {
                              setState(() {
                                courseGradeValue = selectedGrade!;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
                color: Colors.blue,
                border: BorderDirectional(
                  top: BorderSide(color: Colors.blue, width: 2),
                  bottom: BorderSide(color: Colors.blue, width: 2),
                )),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: allCourses.length == 0
                            ? " Please add a course "
                            : "Average: ",
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                    TextSpan(
                        text: allCourses.length == 0
                            ? ""
                            : "${average.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),

          // Container holding the dynamic list
          Expanded(
              child: Container(
                  child: ListView.builder(
            itemBuilder: _buildListItems,
            itemCount: allCourses.length,
          ))),
        ],
      ),
    );
  }

  Widget buildBodyLandscape() {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Course Name",
                          hintText: "Enter the course name",
                          hintStyle: TextStyle(fontSize: 18),
                          labelStyle: TextStyle(fontSize: 22),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (enteredValue) {
                          if (enteredValue!.length > 0) {
                            return null;
                          } else
                            return "Course name cannot be empty";
                        },
                        onSaved: (valueToSave) {
                          courseName = valueToSave!;
                          setState(() {
                            allCourses.add(Course(courseName, courseGradeValue,
                                courseCredit, generateRandomColor()));
                            average = 0;
                            calculateAverage();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: courseCreditItems(),
                                value: courseCredit,
                                onChanged: (selectedCredit) {
                                  setState(() {
                                    courseCredit = selectedCredit!;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.purple, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                items: courseGradeItems(),
                                value: courseGradeValue,
                                onChanged: (selectedGrade) {
                                  setState(() {
                                    courseGradeValue = selectedGrade!;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.purple, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: BorderDirectional(
                        top: BorderSide(color: Colors.blue, width: 2),
                        bottom: BorderSide(color: Colors.blue, width: 2),
                      )),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: allCourses.length == 0
                                  ? " Please add a course "
                                  : "Average: ",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white)),
                          TextSpan(
                              text: allCourses.length == 0
                                  ? ""
                                  : "${average.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          flex: 1,
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemBuilder: _buildListItems,
              itemCount: allCourses.length,
            ),
          ),
          flex: 1,
        ),
      ],
    ));
  }

  List<DropdownMenuItem<int>> courseCreditItems() {
    List<DropdownMenuItem<int>> credits = [];
    for (int i = 1; i <= 10; i++) {
      credits.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Credit",
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
    return credits;
  }

  List<DropdownMenuItem<double>> courseGradeItems() {
    List<DropdownMenuItem<double>> grades = [];
    grades.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    grades.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 20),
      ),
      value: 3.5,
    ));
    grades.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 20),
      ),
      value: 3,
    ));
    grades.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 20),
      ),
      value: 2.5,
    ));
    grades.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));
    grades.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 20),
      ),
      value: 1.5,
    ));
    grades.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 20),
      ),
      value: 1,
    ));
    grades.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));
    return grades;
  }

  Widget _buildListItems(BuildContext context, int index) {
    counter++;
    return Dismissible(
      key: Key(counter.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allCourses.removeAt(index);
          calculateAverage();
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: allCourses[index].color!, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(Icons.done_outline, size: 36),
          title: Text(allCourses[index].name!),
          trailing: Icon(Icons.keyboard_arrow_right),
          subtitle: Text(allCourses[index].credit.toString() +
              " Credit Grade Value: " +
              allCourses[index].gradeValue.toString()),
        ),
      ),
    );
  }

  void calculateAverage() {
    double totalGrade = 0;
    double totalCredit = 0;

    for (var currentCourse in allCourses) {
      totalGrade =
          totalGrade + (currentCourse.gradeValue! * currentCourse.credit!);
      totalCredit += currentCourse.credit!;
    }

    average = totalGrade / totalCredit;
  }

  Color generateRandomColor() {
    return Color.fromRGBO(
        Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
  }
}

class Course {
  String? name;
  double? gradeValue;
  int? credit;
  Color? color;

  Course(this.name, this.gradeValue, this.credit, this.color);
}

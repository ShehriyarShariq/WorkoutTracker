import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Workout {
  String type;
  double percen;

  Workout({this.type, this.percen});
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ScrollController scrollController;
  List<Workout> workouts = [
    Workout(type: "walk", percen: 0.04),
    Workout(type: "jog", percen: 0.29),
    Workout(type: "swim", percen: 0.09),
    Workout(type: "run", percen: 0.05),
    Workout(type: "sport", percen: 0.15)
  ];
  Map<String, IconData> typeIcon = {
    "walk": Icons.directions_walk,
    "jog": Icons.directions_walk,
    "swim": Icons.pool,
    "run": Icons.directions_walk,
    "sport": Icons.directions_walk
  };
  bool newNotif = true;
  int currentIndex = 1;
  List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double get appBarTextTop {
    double res = MediaQuery.of(context).size.height * 0.12;
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      if (offset < (res - kToolbarHeight)) {
        res -= offset;
      } else {
        res = kToolbarHeight + 40;
      }
    }
    return res;
  }

  double get statsBoxTop {
    double res = MediaQuery.of(context).size.height * 0.28;
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      if (offset > 0) {
        if ((res - offset) >= (kToolbarHeight + 40)) {
          res -= offset;
        } else {
          res = kToolbarHeight + 40;
        }
      }
    }
    return res;
  }

  double get workoutStatsBoxTop {
    double res = ((MediaQuery.of(context).size.height * 0.1));
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      double maxPos = (MediaQuery.of(context).size.height * 0.35) +
          (MediaQuery.of(context).size.height * 0.1);
      double minPos =
          (kToolbarHeight + 40) + (MediaQuery.of(context).size.height * 0.2);
      double maxOffsetPos = maxPos - minPos;

      if (offset >= maxOffsetPos) {
        res = offset - maxOffsetPos + kToolbarHeight + 15;
      } else {
        res = ((MediaQuery.of(context).size.height * 0.1));
      }
    }

    return res;
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    tabs = [
      _buildPlaceHolderPage(context, Colors.red),
      _buildHomePage(context),
      _buildPlaceHolderPage(context, Colors.blue)
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(238, 242, 245, 1),
        body: tabs[currentIndex],
        bottomNavigationBar: _getNavBar(context),
      )
    );
  }

  Widget _buildHomePage(BuildContext context){
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),         
      child: Stack(
        children: <Widget>[
          NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (BuildContext context, value) {
                return [
                  SliverAppBar(
                    expandedHeight:
                        MediaQuery.of(context).size.height * 0.35,
                    pinned: true,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: _buildExpandedAppBar(context),
                    elevation: 0.0,
                  ),
                ];
              },
              body: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    margin:
                        EdgeInsets.only(top: workoutStatsBoxTop, bottom: 5),
                    child: _buildWorkoutStatsArea(context),
                  )),
                ],
              )),
          Positioned(
            top: statsBoxTop,
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildStepCounterBox(context),
                ],
              ),
            ),
          ),
        ],
      ),        
    );
  }

  Widget _buildPlaceHolderPage(BuildContext context, Color color){
    return Container(
      child: Center(
        child: Icon(
          Icons.home,
          color: color,
          size: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }

  Widget _buildExpandedAppBar(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30.0)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(30.0)),
                ),
              ),
            ],
          ),
          new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                margin: EdgeInsets.only(
                    top: constraints.maxHeight * 0.3,
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Workouts",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900)),
                    ),
                    Container(
                      width: 3,
                      height: 3,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: newNotif ? Colors.red : Colors.transparent
                      ),
                    ),
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepCounterBox(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1),
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white),
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20.0, bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.directions_walk,
                        color: Colors.red,
                      ),
                      Container(
                        width: 5,
                      ),
                      Text(
                        "Steps",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "1930",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: _buildSendBtn(context),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildWorkoutStatsArea(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: workouts
                  .map((workout) => _buildWorkoutStatsListItem(workout))
                  .toList(),
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildSendBtn(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth / 2,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Color.fromRGBO(255, 239, 239, 1),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  "Send",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w900,
                      fontSize: 14),
                ),
              ),
            ),
            Container(
              width: constraints.maxHeight,
              height: constraints.maxHeight,
              child: Material(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                    child: Transform.rotate(
                  angle: -45 * (22 / 7) / 180,
                  child: InkWell(
                      onTap: () {},
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 17,
                        ),
                      )),
                )),
              ),
            )
          ]),
        );
      },
    );
  }

  Widget _buildWorkoutStatsListItem(Workout workout) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2 * 0.58,
      margin: EdgeInsets.only(
          left: 10, right: 10.0, bottom: workout.percen * 100 * 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
              (MediaQuery.of(context).size.height * 0.2 * 0.58) / 4)),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: ((MediaQuery.of(context).size.height * 0.2 * 0.58) -
                            (MediaQuery.of(context).size.height *
                                0.2 *
                                0.58 *
                                0.74)) /
                        2,
                    left: ((MediaQuery.of(context).size.height * 0.2 * 0.58) -
                            (MediaQuery.of(context).size.height *
                                0.2 *
                                0.58 *
                                0.74)) /
                        2,
                    right: ((MediaQuery.of(context).size.height * 0.2 * 0.58) -
                            (MediaQuery.of(context).size.height *
                                0.2 *
                                0.58 *
                                0.74)) /
                        2,
                  ),
                  width: MediaQuery.of(context).size.height * 0.2 * 0.58 * 0.74,
                  height:
                      MediaQuery.of(context).size.height * 0.2 * 0.58 * 0.74,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                          (MediaQuery.of(context).size.height * 0.2 * 0.58) /
                              5)),
                      color: workout.type == "walk"
                          ? Colors.red
                          : Color.fromRGBO(181, 190, 208, 1)),
                  child: Icon(
                    typeIcon[workout.type],
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "${(workout.percen * 100).toStringAsFixed(0)} %",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  )))
        ],
      ),
    );
  }

  Widget _getNavBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildNavItem(Icons.home, 0),
          SizedBox(width: 1),
          _buildNavItem(Icons.home, 1),
          SizedBox(width: 1),
          _buildNavItem(Icons.home, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Container(
      width: 60.0,
      height: 60.0,      
      child: FlatButton(
        color: currentIndex == index ? Colors.black : Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        onPressed: () => onTabTapped(index),
        child: Icon(
          icon,
          color: currentIndex == index ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

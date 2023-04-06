import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/*void main() {
  runApp(MyApp());
}*/

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class BackgroundImage extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    ui.Image image;
    // Load the image from the assets
    // Make sure to adjust the path according to your assets directory structure
    AssetImage('assets/images/background_image.jpg')
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      // When the image is loaded, paint it onto the canvas
      image = info.image;
      canvas.drawImageRect(
          image,
          Rect.fromLTRB(
              0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTRB(0, 0, size.width, size.height),
          Paint());
    }));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
class MyState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RockPaperScissors",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),

          ),

        ),
      ),
    );
  }
}

class MyKNB extends StatefulWidget {
  const MyKNB({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyStateKNB();
  }
}

class MyStateKNB extends State<MyKNB> {
  List<String> images = const [
    'assets/images/paper.jpg', //0
    'assets/images/rock.jpg', //1
    'assets/images/scissors.jpg', //2
    'assets/images/winner.jpg',
  ];
  late String image1;
  late String image2;
  late bool stopper;
  late double oc1;
  late double oc2;
  late int index1;
  late int index2;

  late double _angle1 = -2;
  late double _angle2 = -2;


  String getImage1() {
    setState(() {
      index1 = Random().nextInt(3);
    });
    return images[index1];
  }

  String getImage2() {
    setState(() {
      index2 = Random().nextInt(3);
    });
    return images[index2];
  }

  @override
  void initState() {
    super.initState();
    image1 = getImage1();
    image2 = getImage2();
    stopper = false;
    oc1 = 0;
    oc2 = 0;
  }

  void winner() {
    if (index1 == 0 && index2 == 1 ||
        index1 == 1 && index2 == 2 ||
        index1 == 2 && index2 == 0) {
      setState(() {
        oc1 = 1;
        oc2 = 0;
      });
    } else if (index2 == 0 && index1 == 1 ||
        index2 == 1 && index1 == 2 ||
        index2 == 2 && index1 == 0) {
      setState(() {
        oc1 = 0;
        oc2 = 1;
      });
    } else {
      setState(() {
        oc1 = 0;
        oc2 = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30,),
        const Padding(padding: EdgeInsets.all(20)),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 3),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 3),
                      builder: (BuildContext context, double opacity, Widget? child) {
                        return Opacity(
                          opacity: opacity,
                          child: child,
                        );
                      },
                      child: child,
                    );
                  },
                  child: Transform.rotate(
                    angle: _angle1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.asset(
                        oc1 == 1 ? "assets/images/winner.jpg" : image1,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  key: ValueKey<int>(oc1.toInt()),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(20)),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 3),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 3),
                      builder: (BuildContext context, double opacity, Widget? child) {
                        return Opacity(
                          opacity: opacity,
                          child: child,
                        );
                      },
                      child: child,
                    );
                  },
                  child: Transform.rotate(
                    angle: _angle2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.asset(
                        oc2 == 1 ? "assets/images/winner.jpg" : image2,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  key: ValueKey<int>(oc2.toInt()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20, height: 150,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(20)),

            ElevatedButton(
              onPressed: () {
                //Vibration.vibrate(duration: 2000);
                setState(() {
                  stopper = false;
                  oc1 = 0;
                  oc2 = 0;
                  _angle1 = -1;
                  _angle2 = -1;
                });
                Timer.periodic(const Duration(milliseconds: 100), (timer) async {
                  setState(() {
                    image1 = getImage1();
                    image2 = getImage2();
                    _angle1 += 2; // rotate image 1 faster
                    _angle2 += 2; // rotate image 2 even faster
                  });
                  if (stopper) {
                    timer.cancel();
                    winner();
                  }
                });
              },
              child: const Text("Start Game"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                //Vibration.vibrate(duration: 2000);
                setState(() {
                  stopper = true;
                  _angle1 = 4.27;
                  _angle2 = 4.27;
                });
              },
              child: const Text("Stop Game"),
            ),
            const SizedBox(width: 45),
          ],
        ),
      ],
    );
  }

}
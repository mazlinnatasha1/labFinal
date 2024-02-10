import 'dart:async';
import 'package:bookbytes/views/screens/mainpage.dart';
import 'package:bookbytes/views/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'main.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State <SplashScreen>createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splashscreen.png'),
              fit: BoxFit.cover
              )
          ),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 20),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "BookBytes",
              style: TextStyle(
                fontSize:40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            CircularProgressIndicator(),
            Text(
              "Version 0.1",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white
              ),
            ),
          ],
         ),
         )
      ],
    ),
  );
 }
  void initState(){
    super.initState();
    var user;
    Timer(
      const Duration(seconds:2),
      () => Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (content) =>  ProfilePage()))
    );
  }
}
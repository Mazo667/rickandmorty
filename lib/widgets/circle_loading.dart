import 'package:flutter/material.dart';

Widget circleLoading(){
  return const Center(child:
       CircleAvatar(
            radius: 100,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/portal-rick-and-morty.gif'))
  );
}
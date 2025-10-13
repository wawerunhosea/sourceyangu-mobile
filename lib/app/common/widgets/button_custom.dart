import 'package:flutter/material.dart';

// Reusable Button

class ButtonClass {
  
  static circularButton (onTapFunction)
  {
    return ElevatedButton(
              onPressed: onTapFunction,

              style: ElevatedButton.styleFrom(

                shape: const CircleBorder(),

                padding: const EdgeInsets.all(15),

                backgroundColor: Colors.black,

              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            );
  }
  
}
import 'package:flutter/material.dart';

class SizeConfig
{
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal=0;
  static double blockSizeVertical=0;

  static double textMultiplier=1;
  static double imageSizeMultiplier;
  static double heightMultiplier;

  void init(BoxConstraints constraints,Orientation orientation)
  {
    if(orientation==Orientation.portrait)
    {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
    }
    else
    {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
    }

    blockSizeHorizontal = screenWidth/100;
    blockSizeVertical = screenHeight/100;

    textMultiplier = blockSizeVertical;
    imageSizeMultiplier = blockSizeHorizontal;
    heightMultiplier = blockSizeVertical;

    print('Block Size Horizontal $blockSizeHorizontal');
    print('Block Size Vertical $blockSizeVertical');
  }


}

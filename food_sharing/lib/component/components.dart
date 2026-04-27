import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/theme/app_theme.dart';

class AppComponents{

static Widget autoSizedColumn({required List<Widget> children}) {
  return CustomScrollView(
    physics: const ClampingScrollPhysics(), 
    slivers: [
      SliverFillRemaining(
        hasScrollBody: false, // This is the magic property
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    ],
  );
}

  static Widget centeredColumn({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget mainButton(VoidCallback onPressed, String text, String style){

    Color backgroundColor;
    Color foregroundColor;

    if(style=="red"){
      backgroundColor = BrandColors.red;
      foregroundColor = BrandColors.white;
    }else{
      backgroundColor = BrandColors.gray;
      foregroundColor = BrandColors.black;
    }

    return ElevatedButton(onPressed: onPressed,
      
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,            
        elevation: 0,                                         
        minimumSize: const Size(200, 50),                   
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),        
        ),
      ), 

      child: 
      Text(text, style:TextStyleTheme.button),
      
    );
    
  }

  static Widget sectionCard({required BuildContext context, required List<Widget> children}){
    return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: BrandColors.cream,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children
      ),
    ),
  );
  }
  

}



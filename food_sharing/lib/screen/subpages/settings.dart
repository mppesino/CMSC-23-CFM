import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/layouts.dart';
import 'package:food_sharing/screen/component/sections.dart';
import 'package:food_sharing/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  bool _enableDiscovery = false;
  bool _enableRequests = false;
  bool _enablePickups = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Settings", style: TextStyleTheme.subtitle_bold,)),
      body: FullHeightColumn(children: [
        Padding(padding: EdgeInsets.all(10), child:SectionCard(color: BrandColors.white, children: [
          Text("Notifications", style: TextStyleTheme.subtitle_bold,),


          SwitchListTile(
                title: Text('Discovery and Location Proximity' ,style: TextStyleTheme.body,),
                subtitle: Text('Alerts when an item matching your preferences is posted near your area', style: TextStyleTheme.body_sub),
                value: _enableDiscovery,
                onChanged: (bool value) {
                  setState(() {
                    _enableDiscovery = value;
                  });

                
                },
                trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return BrandColors.green; 
                      }
                      return BrandColors.white;
                    }),
              ),


          SwitchListTile(
                title: Text('Item Requests' ,style: TextStyleTheme.body,),
                subtitle: Text('Alerts when someone requests an item you posted', style: TextStyleTheme.body_sub),
                value: _enableRequests,
                onChanged: (bool value) {
                  setState(() {
                    _enableRequests = value;
                  });
                },
                trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return BrandColors.green; 
                }
                return BrandColors.white;
              }),
              ),

          SwitchListTile(
                title: Text('Pick-up Reminders' ,style: TextStyleTheme.body,),
                subtitle: Text('Alerts an hour before scheduled item pick-ups', style: TextStyleTheme.body_sub),
                value: _enablePickups,
                onChanged: (bool value) {
                  setState(() {
                    _enablePickups = value;
                  });
                },
                trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return BrandColors.green; 
                }
                return BrandColors.white;
              }),
              ),


        ]))
      ])
      );
  }



}
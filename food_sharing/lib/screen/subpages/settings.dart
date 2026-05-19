import 'package:flutter/material.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/component/layouts.dart';
import 'package:food_sharing/screen/component/sections.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  bool _enableDiscovery = false;
  bool _enableRequests = false;
  bool _enablePickups = false;

  double _discoveryRadius = 5.0;

  @override
  void initState(){ //current user profile settings
    super.initState();
    
    final currentUser = context.read<UsersProvider>().currentUser;
    if(currentUser != null){
      _discoveryRadius = currentUser.discoveryRadius;
      _enableDiscovery = currentUser.enableDiscovery;
      _enableRequests = currentUser.enableRequests;
      _enablePickups = currentUser.enablePickups;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.watch<UsersProvider>();

    return Scaffold(
      
      appBar: AppBar(title: Text("Settings", style: TextStyleTheme.subtitle_bold,),elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: BrandColors.green, size: 28),
            onPressed: () async{
              final uid = usersProvider.currentUser?.userId;
              if(uid != null){
                //save configurations directly to user profile via provider map payload:
                await usersProvider.editUser(uid, { 
                  'enableDiscovery': _enableDiscovery,
                  'enableRequests': _enableRequests,
                  'enablePickups': _enablePickups,
                  'discoveryRadius': _discoveryRadius,
                });

                if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preferences saved successfully!'), backgroundColor: BrandColors.green,)
                  );
                }
                
                Navigator.pop(context);
              }

            }, 
          ),

          const SizedBox(width: 8,),

        ],
      ),
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
                      if (states.contains(WidgetState.selected)) return BrandColors.green; 
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
                  if (states.contains(WidgetState.selected))  return BrandColors.green;
                  return BrandColors.white;
                }),
          ),

          //SLIDER FOR DISCOVERY RADIUS:
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Divider(),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Discovery Radius", style: TextStyleTheme.subtitle_bold),

                const SizedBox(height: 4),

                Text('Search for available items within ${_discoveryRadius.toStringAsFixed(1)} km', style: TextStyleTheme.body_sub,),

                Slider(
                  value: _discoveryRadius, 
                  min:1.0, 
                  max:30.0, 
                  divisions: 29, 
                  activeColor: 
                  BrandColors.green, 
                  inactiveColor: Colors.grey,
                  onChanged: (double value){
                    setState(() { _discoveryRadius = value;});
                  },

                )
              ],
            ),
          )


        ]))
      ])
      );
  }



}
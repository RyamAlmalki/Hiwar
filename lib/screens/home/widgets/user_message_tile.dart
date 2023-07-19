import 'package:flutter/material.dart';

import '../../../const.dart';

class UserMessageTile extends StatelessWidget {
  const UserMessageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTile(
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text('Online', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),),
        ), 
        tileColor: background,
        leading: SizedBox(
          width: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('homeScreen');
                },
              ),
              const CircleAvatar(
                radius: 27,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ],
          ),
        ),
        title: Text('Ryam malki', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),),
      ),
    );
  }
}
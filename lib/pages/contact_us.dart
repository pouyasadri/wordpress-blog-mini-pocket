import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_service.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                  letterSpacing: -0.7,
                  wordSpacing: 1,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Email : info@theminipocket.com',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Mobile : +918872440000',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Website : https://theminipocket.com',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Address : Point 2 Point Media Private Limited\n vill Gazipur, Sultanpur Lodhi,\n Distt Kapurthala,Punjab,144626 (IN)',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    launch("tel://+918872440000");
                  },
                  icon: Icon(Icons.phone),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      AppService().openEmailSupport(context);
                    },
                    icon: Icon(Icons.email)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

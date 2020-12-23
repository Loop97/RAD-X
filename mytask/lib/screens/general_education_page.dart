import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mytask/config/config.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralEducationPage extends StatefulWidget {
  static const String id = 'general_education_page';
  @override
  _GeneralEducationPageState createState() => _GeneralEducationPageState();
}

class _GeneralEducationPageState extends State<GeneralEducationPage> {
  Widget _buildListWidget(String text, String content, double size) {
    return ExpansionTile(
      trailing: Container(width: 0.01),
      title: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              color: Color(0xFFB2EBF2)),
          height: 65,
          width: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                text,
                style: TextStyle(fontSize: size, color: Colors.black),
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 15,
              ),
            ],
          ),
        ),
      ),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          decoration:
              BoxDecoration(border: Border.all(), color: Color(0xFFE1F5FE)),
          child: AutoSizeText(
            content,
            style: TextStyle(fontSize: 15, color: Colors.black),
            textAlign: TextAlign.left,
            minFontSize: 10,
          ),
        )
      ],
    );
  }

  Widget _buildListwithImageWidget(String text, String content, double size) {
    return ExpansionTile(
      trailing: new Container(width: 0.01),
      title: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              color: Color(0xFFB2EBF2)),
          height: 65,
          width: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                text,
                style: TextStyle(fontSize: size, color: Colors.black),
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 15,
              )
            ],
          ),
        ),
      ),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          decoration:
              BoxDecoration(border: Border.all(), color: Color(0xFFE1F5FE)),
          child: Column(
            children: <Widget>[
              AutoSizeText(
                content,
                style: TextStyle(fontSize: 15, color: Colors.black),
                textAlign: TextAlign.left,
                minFontSize: 10,
              ),
              Image.asset('assets/dosechart.png'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildListwithURLWidget(
      String text,
      String content_1,
      String content_2,
      String content_3,
      String content_4,
      String content_5,
      String content_6,
      String content_7,
      String content_8,
      String content_9,
      String content_10,
      String content_11,
      String content_12,
      String content_13,
      String content_14,
      String content_15,
      String content_16,
      String content_17,
      String content_18,
      String content_19,
      String content_20,
      double size) {
    return ExpansionTile(
      trailing: Container(width: 0.01),
      title: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              color: Color(0xFFB2EBF2)),
          height: 65,
          width: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                text,
                style: TextStyle(fontSize: size, color: Colors.black),
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 15,
              ),
            ],
          ),
        ),
      ),
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(15),
            decoration:
                BoxDecoration(border: Border.all(), color: Color(0xFFE1F5FE)),
            child: Center(
                child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: content_1,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_2,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_3,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  //new portion
                  TextSpan(
                    text: content_4,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  TextSpan(
                    text: content_5,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_6,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_7,
                    style: TextStyle(
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_8,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_9,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_10,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: content_11,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_12,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: content_13,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: content_14,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                      text: content_15,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(_emailLaunchUri_1.toString());
                        }),
                  TextSpan(
                      text: content_16,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(_emailLaunchUri_2.toString());
                        }),
                  //function to link the url to website and email
                  TextSpan(
                    text: content_17,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                      text: content_18,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(content_18);
                        }),
                  TextSpan(
                    text: content_19,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text: content_20,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(_emailLaunchUri_3.toString());
                        }),
                ],
              ),
            ))),
      ],
    );
  }

  final Uri _emailLaunchUri_1 =
      Uri(scheme: 'mailto', path: 'Marcus_FA@science.edu.sg');
  final Uri _emailLaunchUri_2 =
      Uri(scheme: 'mailto', path: 'Kel_LEE@science.edu.sg');
  final Uri _emailLaunchUri_3 =
      Uri(scheme: 'mailto', path: 'snrv11@nus.edu.sg');

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('General Education'),
          centerTitle: true,
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                width: 100.0,
                height: 40,
              ),
              _buildListWidget(
                  "About Project Rad-X",
                  "Project Rad-X first began in 2019 as a proposed project in Engineering Innovation Challenge (EIC) 2019. In EIC 2019, participants in categories 3 and 4 were tasked to design and build an ionising radiation detector prototype that is capable of measuring the background gamma radiation accurately within a reasonable amount of time. Project Rad-X managed to clinch the top prize in category 4.\n\nThe project did not stop there as the team behind the project was approached by Singapore Nuclear Research and Safety Initiative (SNRSI) to further this project for the purpose of education and outreach. Project Rad-X continued to improve their ionizing radiation detector to meet the requirements of portability, effectiveness for mass production.\n\nRad-X is a portable ionizing radiation detector meant to measure background ionising radiation, and is in essence a Geiger Müller counter. A Geiger Müller counter derives its name from its measurement component, the Geiger-Müller tube that is used to detect radiation. A Geiger-Müller tube generally comprises of a tube that is filled with inert gas kept at low pressure and with a high voltage applied across the tube. When ionizing radiation ionize the gas in the tube, an electric charge is sent through the tube and this ionization will be amplified to create an electric pulse. This electrical pulse is then recorded and processed into meaningful data.\n\nThe new and improved ionizing radiation detector from Project Rad-X will be utilized in EIC 2020. The ionizing radiation detector will be distributed to the participants from category 1 to 3 of the competition. The participants will utilize the device to map out radiation dose around Singapore based on the provided theme.",
                  25),
              SizedBox(
                width: 100.0,
                height: 40,
              ),
              _buildListWidget(
                  "What is ionizing \nradiation?",
                  "Ionising radiation is radiation with enough energy so that during an interaction with an atom, it can remove tightly bound electrons from the orbit of an atom, causing the atom to become charged or ionised. \n\nContrary to popular belief, ionising radiation is everywhere similar to the non-ionising counterparts. The human body has no sensor for it unlike non-ionising radiation such as visible light and thus would not be privy of it. \n\nSome sources of ionizing radiation in our environment are natural radioactive elements in the ground, radon gas that seep out from concrete building, cosmic rays from the Sun and even trace amounts of radioactive elements in our food.\n\nHence exposure to radiation from natural sources is an inescapable feature of everyday life in both working and public environments. This exposure is in most cases of little or no concern to society.",
                  25),
              SizedBox(
                width: 100.0,
                height: 40,
              ),
              _buildListWidget(
                  "Measurements \n of radiation dose",
                  "Radiation dose is measured in Sieverts.\nThis unit represents the stochastic health risk due to ionising radiation. At low radiation dose, the effects of such radiation are random thus impact of a radiation dose has to be represented by a probability of radiation induced damage.\n\nThe unit Sieverts(Sv) represents the probability of radiation induced cancer and genetic damage to the human body.\n\nAnother measurement visible in the Rad-X application is Counts and Counts per minute. Counts refer to the number of ionizing events recorded by the detector. This will be summed up and displayed as counts per minute (CPM).",
                  25),
              SizedBox(
                width: 100.0,
                height: 40,
              ),
              _buildListwithImageWidget(
                  "Health effects",
                  "As mentioned before, exposure to ionising radiation is inevitable and of little concern to everyday life. For a sense of the impact of exposure, compare your measurements of your Rad-X detector to the radiation dose chart below! A radiation dose chart displays a variety of expected radiation dose from certain activities and the possible impact at higher radiation dose.\n",
                  25),
              SizedBox(
                width: 100.0,
                height: 40,
              ),
              _buildListwithURLWidget(
                  "FAQs",
                  "Troubleshooting Guide: \n\n",
                  //Q1
                  "1. The device does not turn on \n\n",
                  "Solution: ",
                  "Turn off the device and charge it\n\n\n",
                  //Q2
                  "2. Application stuck at the loading screen \n\n",
                  "Solution: ",
                  "Turn on Bluetooth / Location.\n\n\n",
                  //Q3
                  "3. Device emits a long continuous beep.\n\n",
                  "Solution: ",
                  "Turn off the device for a few minutes and turn it on again \n\n\n",
                  //Q4
                  "4. Device always shows zero counts.\n\n",
                  "Solution: ",
                  "Leave the Measurements page, reconnect the device, and enter the Measurements page again.\n\n\n",
                  "**If the problem persist, please contact Singapore Science Center for a replacement:\n",
                  "Marcus_FA@science.edu.sg\n",
                  "Kel_LEE@science.edu.sg\n\n",
                  "For any enquires about Rad-X detector or Engineering Innovation Challenge 2020 Phase B, please visit our website: \n",
                  "http://snrsi.nus.edu.sg/outreach/eic2020.html ",
                  "or email us at ",
                  "snrv11@nus.edu.sg",
                  25)
            ]),
          )
        ]));
  }
}

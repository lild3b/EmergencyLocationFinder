import 'package:flutter/material.dart';
import 'package:locationfinder/util/currentlocation_util.dart';
import 'package:locationfinder/util/database_util.dart';
import 'package:locationfinder/util/sendSMS.dart';

class FloodEmergency extends StatelessWidget {
  const FloodEmergency({super.key});

  @override
  Widget build(BuildContext context) {
    LocalDatabase db = new LocalDatabase();
    String type = 'Disaster';
    String location = LocationUtil.stationAddress;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    db.loadInfoData();
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SendSMS(
                emergencyType: type,
              );
            });
      },
      child: FittedBox(
        alignment: Alignment.centerRight,
        child: Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.shade700,
                    spreadRadius: 5,
                    blurRadius: 1,
                    offset: const Offset(3, 0), // changes position of shadow
                  ),
                ]),
            width: screenWidth * 1,
            height: screenHeight * 0.20,
            child: Row(
              children: [
                FittedBox(
                  alignment: Alignment.centerRight,
                  fit: BoxFit.cover,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: screenWidth * 0.6,
                            child: Text(
                              type,
                              maxLines: 1,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Spotify'),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.6,
                            child: Text(
                              'Hotline: ${db.info[4]}',
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Spotify'),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.6,
                            child: Text(
                              'Location: $location',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Spotify'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: screenWidth * 0.40,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(10, 5, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        "assets/flood.png",
                        height: 170,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

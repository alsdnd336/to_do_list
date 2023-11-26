import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({required this.contentsTime, super.key});
  final Timestamp contentsTime;


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    DateTime postsTime = contentsTime.toDate();
    Duration difference = now.difference(postsTime);

    int days = difference.inDays;
    int hours = difference.inHours % 24; // 나머지 출력
    int minutes = difference.inMinutes % 60;


    String timeWidget(){
        if(days == 0){
          if(hours == 0){
            String minuteString = minutes.toString();
            return '${minuteString}분';
          }else{
            String hourString = hours.toString();
            return '${hourString}시간';
          }
        }else {
          String dayString = days.toString();
          return '${dayString}일';
        }
      
      
    }
    if(days < 7){
      return Text('${timeWidget()} 전', style: TextStyle(color: Colors.grey[800]),);
    } else {
      int month = postsTime.month;
      int days = postsTime.day;
      return Text('$month월 $days일', style: TextStyle(color: Colors.grey[800]),);
    }
    
  }
}
import 'package:flutter/material.dart';
import 'package:fe/pages/group/models/participant_model.dart';
import 'package:fe/pages/group/enum/role_participant.dart';

class ParticipantCard extends StatelessWidget {
  final Participant participant;

  const ParticipantCard({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(participant.imagePath ?? 'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg'),
        ),
        const SizedBox(height: 8),
        Text(
          participant.role.label, 
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 50,
          child: Text(
            participant.name,
            textAlign: TextAlign.center,  
            maxLines: 2,                   
            overflow: TextOverflow.ellipsis, 
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ],
    );
  }
}
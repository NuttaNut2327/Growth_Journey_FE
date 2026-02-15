import 'package:flutter/material.dart';

class UserLevelCard extends StatelessWidget {
  const UserLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x33D8A7D9),
              Color(0x33C8E5D8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: Offset(0, 6),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage('https://i.pinimg.com/736x/46/6a/9a/466a9a907e24511cebea9893109c0344.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFEED7ED),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('Level 5',
                          style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.w500
                          )
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Kwantip Kanjanamas', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.w700
                        )
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress to Level 6', 
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B7A99)
                    )
                  ),
                  Text('1250 / 1500 XP', 
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500
                    )
                  )
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: 1250 / 1500,
                  minHeight: 12,
                  backgroundColor: Color(0x33D8A7D9),
                  valueColor: AlwaysStoppedAnimation(Color(0xFFD8A7D9)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
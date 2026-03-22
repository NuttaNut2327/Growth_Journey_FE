import 'package:fe/interface/auth/user.dart';
import 'package:flutter/material.dart';

class UserLevelCard extends StatelessWidget {
  final User user;
  final Widget? actionIcon;          
  final VoidCallback? onIconTap;    

  const UserLevelCard({
    super.key,
    required this.user,
    this.actionIcon,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = (user.imageUrl == null || user.imageUrl!.isEmpty)
        ? 'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg'
        : user.imageUrl!;

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0x80D8A7D9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Level ${user.level}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(user.username,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700))
                    ],
                  ),
                  const Spacer(),
                  if (actionIcon != null)
                    IconButton(
                      onPressed: onIconTap,
                      icon: actionIcon!,
                    )
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress to Level ${user.level + 1}',
                      style:
                          TextStyle(fontSize: 14, color: Color(0xFF8B7A99))),
                  Text('${user.points} / 100 XP',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: user.points / 100,
                  minHeight: 12,
                  backgroundColor: Color(0x33D8A7D9),
                  valueColor:
                      AlwaysStoppedAnimation(Color(0xFFD8A7D9)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
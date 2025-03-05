import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
 
  final Color iconColor;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

          shape: BoxShape.circle,
          color: Colors.grey[200],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor), 
        onPressed: onTap,
      ),
    );
  }
}

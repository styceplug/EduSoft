import 'package:flutter/material.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/dimensions.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.height30, horizontal: Dimensions.width20),
        margin: EdgeInsets.symmetric(
            vertical: Dimensions.height10, horizontal: Dimensions.width20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.accentColor.withOpacity(0.05),
              offset: Offset(2, 2),
              blurRadius: Dimensions.radius5
            )
          ],
            color: AppColors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius10)),
        child: Row(
          children: [
            //icon
            Icon(Icons.person,size: Dimensions.iconSize24),
            SizedBox(width: Dimensions.width20),
            //userName
            Text(text),
          ],
        ),
      ),
    );
  }
}

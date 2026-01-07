import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/presentation/widget/app_bottom_sheet.dart';

class AppFloatingButton extends StatelessWidget {

  final VoidCallback onNoteClick;
  const AppFloatingButton({required this.onNoteClick, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () async {
      final result = await showAppBottomSheet(context, null);
      if(result == true) {
        onNoteClick();
      }
    }, style: IconButton.styleFrom(
      backgroundColor: AppColors.golderYellow,
      foregroundColor: AppColors.white,
      shape: const CircleBorder(),
      elevation: 6,
      minimumSize: Size(56, 56),
    ), icon: Icon(Icons.add, size: 28,));
  }
}

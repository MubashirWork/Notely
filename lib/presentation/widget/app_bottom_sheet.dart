import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/data/database/dao/note_dao/note_dao.dart';
import 'package:notely/core/data/shared_preference/shared_pref_service.dart';
import 'package:notely/presentation/widget/app_button.dart';
import 'package:notely/presentation/widget/app_text.dart';
import 'package:notely/presentation/widget/app_text_field.dart';

class AppBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? note;

  const AppBottomSheet({this.note, super.key});

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  var username = '';
  late final String date;

  String? errorMessage;
  bool isEdit = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    final getUsername = await SharedPrefService.getUsername();
    if (getUsername != null) {
      setState(() {
        username = getUsername;
      });
    }

    date = DateFormat('dd MMM yyyy').format(DateTime.now());
    if (widget.note != null) {
      isEdit = true;
      titleController.text = widget.note!['title'] ?? '';
      descController.text = widget.note!['description'] ?? '';
    }
  }

  Future operation() async {
    if (titleController.text.trim().isEmpty &&
        descController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter title or description';
      });
      return;
    }

    if (isEdit) {
      final editNote = await NoteDao.instance.updateNote(
        id: widget.note!['id'],
        title: titleController.text.trim(),
        description: descController.text.trim(),
        date: date.toString(),
      );

      if (editNote) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(data: 'Note updated', color: AppColors.white),
          ),
        );
      }
    } else {
      if (username.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(
              data: 'Username not loaded yet',
              color: AppColors.white,
            ),
          ),
        );
        return;
      } else {
        // Add Note part
        final noteAdded = await NoteDao.instance.addNote(
          username: username,
          title: titleController.text.trim(),
          description: descController.text.trim(),
          date: date.toString(),
        );

        if (noteAdded) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(data: 'Note added', color: AppColors.white),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.keyboard_arrow_down_outlined),
              ),
              const SizedBox(height: 8),
              AppText(
                data: isEdit ? 'Edit Note' : 'Add Note',
                size: 18,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: titleController,
                hint: 'Enter Title',
                filledColor: AppColors.lightGrey,
                borderColor: AppColors.black,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: descController,
                hint: 'Description',
                maxLines: 5,
                filledColor: AppColors.lightGrey,
                borderColor: AppColors.black,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.none,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.topLeft,
                  child: AppText(data: errorMessage!, size: 12),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    backgroundColor: AppColors.white,
                    borderColor: Colors.black54,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    minWidth: MediaQuery.of(context).size.width * 0.30,
                    child: AppText(
                      data: 'Cancel',
                      weight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 24),
                  AppButton(
                    backgroundColor: AppColors.white,
                    borderColor: Colors.black54,
                    onPressed: operation,
                    minWidth: MediaQuery.of(context).size.width * 0.30,
                    child: AppText(
                      data: isEdit ? 'Update' : 'Save',
                      weight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showAppBottomSheet(
  BuildContext context,
  Map<String, dynamic>? note,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => AppBottomSheet(note: note),
  );
}

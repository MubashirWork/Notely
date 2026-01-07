import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/data/database/dao/note_dao/note_dao.dart';
import 'package:notely/core/data/database/dao/user_dao/user_dao.dart';
import 'package:notely/core/service/snack_bar_service.dart';
import 'package:notely/presentation/widget/app_bar.dart';
import 'package:notely/presentation/widget/app_bottom_sheet.dart';
import 'package:notely/presentation/widget/end_drawer/app_end_drawer.dart';
import 'package:notely/presentation/widget/app_floating_button.dart';
import 'package:notely/presentation/widget/app_text.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({required this.username, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allNotes = [];
  var fullName = '';

  @override
  void initState() {
    super.initState();
    fetchNotes();
    getName();
  }

  Future getName() async {
    final getFullName = await UserDao.instance.getFullName(
      username: widget.username,
    );
    if (getFullName != null) {
      setState(() {
        fullName = getFullName;
      });
    }
  }

  Future fetchNotes() async {
    final result = await NoteDao.instance.getUsernameNote(
      username: widget.username,
    );
    setState(() {
      allNotes = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppEndDrawer(),
      floatingActionButton: AppFloatingButton(onNoteClick: fetchNotes),
      backgroundColor: AppColors.lightBluishGrey,
      appBar: Appbar(
        titleText: 'My Notes',
        widgets: [
          AppText(
            data: fullName.isEmpty
                ? 'No user'
                : fullName.length > 15
                ? '${fullName.substring(0, 15)}...'
                : fullName,
            color: AppColors.white,
          ),

          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(Icons.menu, color: AppColors.white),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: allNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_note_outlined,
                        color: AppColors.darkBlueGrey,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        data: "No notes yet",
                        align: TextAlign.center,
                        color: AppColors.darkBlueGrey,
                        weight: FontWeight.w500,
                      ),
                      AppText(
                        data: "add one using the + button",
                        align: TextAlign.center,
                        color: AppColors.darkBlueGrey,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    final note = allNotes[index];
                    final title =
                        note['title'] != null &&
                            note['title'].toString().trim().isNotEmpty
                        ? note['title']
                        : 'Untitled';
                    final desc =
                        note['description'] != null &&
                            note['description'].toString().trim().isNotEmpty
                        ? note['description']
                        : 'No Description';
                    final date =
                        note['date'] != null &&
                            note['date'].toString().trim().isNotEmpty
                        ? note['date']
                        : 'No date';
                    return GestureDetector(
                      onTap: () async {
                        final result = await showAppBottomSheet(context, note);
                        if (result == true) {
                          fetchNotes();
                        }
                      },
                      child: Dismissible(
                        direction: DismissDirection.horizontal,
                        key: Key(note['id'].toString()),
                        onDismissed: (_) async {
                          final deleteNote = await NoteDao.instance.deleteNote(
                            id: note['id'],
                          );
                          if (deleteNote) {
                            fetchNotes();
                            SnackBarService.show('Note deleted');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 16,
                              right: 16,
                              bottom: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: AppText(
                                    data: title,
                                    size: 16,
                                    weight: FontWeight.w500,
                                  ),
                                  subtitle: AppText(data: desc, size: 14),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: AppText(data: date, size: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                ),
        ),
      ),
    );
  }
}

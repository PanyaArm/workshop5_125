import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../repository/note_repository.dart';

// ข้อ 16, 18-20, 28, 33, 34: หน้าเพิ่ม / แก้ไข / ลบ ข้อมูล
class AddNoteScreen extends StatefulWidget {
  final Note? note; // null = เพิ่มใหม่, มีค่า = แก้ไข
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  // ข้อ 20: ตัวแปรรับค่าจาก TextField
  final _title = TextEditingController();
  final _description = TextEditingController();

  // ข้อ 33: ถ้าเป็นการแก้ไข ให้ใส่ข้อมูลเดิมลงในฟอร์ม
  @override
  void initState() {
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        actions: [
          // ข้อ 34: ปุ่มลบ แสดงเฉพาะตอนแก้ไขข้อมูล
          widget.note != null
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text("คุณต้องการจะลบข้อมูลใช่หรือไม่"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteNote();
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline),
                )
              : const SizedBox(),
          // ข้อ 19, 28, 33: ปุ่ม Done (ไม่มีข้อมูลเดิม = เพิ่มใหม่, มีข้อมูลเดิม = อัปเดต)
          IconButton(
            onPressed: widget.note == null ? _insertNote : _updateNote,
            icon: const Icon(Icons.done_outline_rounded),
          ),
        ],
      ),
      // ข้อ 18: ช่องกรอก Title และ Description
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: "Start typing here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ข้อ 28: บันทึกข้อมูลใหม่
  _insertNote() async {
    final note = Note(
      title: _title.text,
      description: _description.text,
      createdAt: DateTime.now(),
    );
    await NoteRepository.insert(note: note);
    if (mounted) Navigator.pop(context); // บันทึกเสร็จกลับหน้าแรก
  }

  // ข้อ 33: อัปเดตข้อมูลเดิม
  _updateNote() async {
    final note = Note(
      id: widget.note!.id!,
      title: _title.text,
      description: _description.text,
      createdAt: widget.note!.createdAt,
    );
    await NoteRepository.update(note: note);
    if (mounted) Navigator.pop(context);
  }

  // ข้อ 34: ลบข้อมูล
  _deleteNote() async {
    await NoteRepository.delete(note: widget.note!);
    if (mounted) Navigator.pop(context);
  }
}
import 'package:flutter/material.dart';
import '../../repository/note_repository.dart';
import '../add_note/add_note_screen.dart';
import 'widgets/item_note.dart';

// ข้อ 1-3, 6, 8, 17, 30, 32: หน้าแรก
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Diary"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        // ข้อ 32: ปุ่มรีเฟรส ดึงข้อมูลใหม่จากฐานข้อมูล
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      // ข้อ 30: ดึงข้อมูลจากฐานข้อมูลด้วย FutureBuilder
      body: FutureBuilder(
        future: NoteRepository.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Empty"),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                for (var note in snapshot.data!)
                  ItemNote(
                    note: note,
                  ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      // ข้อ 6, 17: ปุ่ม + ไปหน้าเพิ่มข้อมูล
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          ).then((_) => setState(() {})); // กลับมาแล้วโหลดข้อมูลใหม่อัตโนมัติ
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
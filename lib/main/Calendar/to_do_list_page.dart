import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/provider/to_do_list_Provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({required this.date, required this.event, super.key});
  final DateTime date;
  final Object? event;

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  late int month;
  late int days;
  bool keyPadVisible = false;

  quill.QuillController _quillController = quill.QuillController.basic();

  bool isChecked = false;

  @override
  void initState() {
    month = widget.date.month;
    days = widget.date.day;

    super.initState();
  }

  Widget keyPadToolbar() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:  Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: quill.QuillToolbar.basic(
                
                controller: _quillController, 
                showFontFamily: false,
                showCodeBlock: false,
                showUndo: false,
                showRedo: false,
                showLink: false,
                showSearchButton: false,
                showFontSize: false,
                showInlineCode: false,
                showSubscript: false,
                showSuperscript: false,
              ),
            ),
          )),
          IconButton(
              onPressed: () => FocusScope.of(context).unfocus(),
              icon: Icon(Icons.keyboard_double_arrow_down)),
        ],
      ),
    );
  }

  void toolList() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height / 3,
              child: quill.QuillToolbar.basic(controller: _quillController, )
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$month.$days',
          style: TextStyle(color: Colors.black),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.sd_storage))],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: quill.QuillEditor(
                controller: _quillController,
                readOnly: false,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                scrollable: true,
                padding: const EdgeInsets.all(5),
                autoFocus: false,
                expands: false,
                placeholder: '할 일을 기록하세요.',
              ),
            ),
          ),
          if (isKeyboard) keyPadToolbar(),
        ],
      ),
    );
  }
}

class Toolitem extends StatelessWidget {
  const Toolitem({
    required this.icon,
    required this.text,
    required this.onTap,
    super.key,
  });

  final Icon icon;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 15,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

List<String> contentsList = ['checkField'];

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

  TextEditingController _controller = TextEditingController();
  FocusNode _nodeText1 = FocusNode();

  Widget addTextFormField() {
    return TextFormField(
      maxLines: null,
      onFieldSubmitted: (value) => addTextFormField(),
      cursorColor: Colors.blue,
      controller: _controller,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: '내용을 입력하시오..',
      ),
    );
  }

  Widget addFeedBack() {
    return Container();
  }
  

    bool isChecked = false;
  
  @override
  void initState() {
    month = widget.date.month;
    days = widget.date.day;
    
    super.initState();
  }

  Widget keyPadToolbar () {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200]
      ),
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: toolList, icon: Icon(Icons.add)),
          IconButton(onPressed: () => FocusScope.of(context).unfocus(), icon: Icon(Icons.keyboard_double_arrow_down)),
        ],
      ),
    );
  }

  void toolList() {
    showDialog(context: context, builder: (context) {
      return Dialog(
        child:  Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width -30,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Toolitem(icon: Icon(Icons.check_box, color: Colors.blue, ), text: '할 일 목록', onTap: (){}),
              const SizedBox(height: 10,),
              Toolitem(icon: Icon(Icons.text_fields_outlined, color: Colors.black,), text: '텍스트', onTap: (){},),
              const SizedBox(height: 10,),
              Toolitem(icon: Icon(Icons.feedback, color: Colors.black,), text: '피드백', onTap: (){},),
            ],
          ),
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
              child: ListView.builder(
                itemCount: contentsList.length,
                itemBuilder: (context, index) {
                  if(contentsList[index] == 'checkField'){
                    return CheckField();
                  }else if(contentsList[index] == 'feedBack'){
                    return addFeedBack();
                  } else {
                    return addTextFormField();
                  }
                }
              )
            ),
            if(isKeyboard)
            keyPadToolbar(),
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
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1
          )
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 15,),
            Text(text, style: TextStyle(fontSize: 18),),
          ],
        ),
      ),
    );
  }
}


class CheckField extends StatefulWidget {
  const CheckField({super.key});

  @override
  State<CheckField> createState() => _CheckFieldState();
}

class _CheckFieldState extends State<CheckField> {
  final _controller = TextEditingController();
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: null,
        onFieldSubmitted: (value) => {
          print('실행중'),
          contentsList.add('checkField'),
          setState(() {})
        },
        cursorColor: Colors.blue,
        controller: _controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: '내용을 입력하시오..',
          prefixIcon: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  isSelected = value!;
                });
              },
            ),
        ),
      );
  }
}
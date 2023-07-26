import 'package:flutter/material.dart';
import 'package:untitled/functions/user_info.dart';
import 'package:untitled/functions/api_functions.dart';

class AddCategoryPage extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('카테고리 추가하기'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: '카테고리를 입력해주세요'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // 책칸 추가 완료 처리
            String title = titleController.text;
            
            // TODO: 책칸 추가 처리 로직 구현

            addCategory(title, userInfo!.userid);

            // 추가 완료 후 다이얼로그 닫기
            Navigator.pop(context);
          },
          child: Text('추가 완료'),
        ),
        TextButton(
          onPressed: () {
            // 다이얼로그 닫기
            Navigator.pop(context);
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}

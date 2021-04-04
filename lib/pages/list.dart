import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/routes.dart';
import 'package:dnew/widgets/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var records = useProvider(diaryRecordListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("dnew"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => DiaryRecordCard(
          record: records[index],
        ),
        itemCount: records.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, Routes.form),
      ),
    );
  }
}

import 'package:cats/src/system/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScreenHistoryView extends StatelessWidget {
  const ScreenHistoryView({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Історія фактів'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: listFacts.length,
            itemBuilder: (context, index) {

              final fact = listFacts[index];

              return Card(
                child: ListTile(
                  title: Text(fact.text),
                  subtitle: Row(
                    children: [
                      const Divider(),
                      Text(fullDateToString(fact.period)),
                    ],
                  ),
                ),
              );

            }),
      ),
    );
  }

  fullDateToString(DateTime date) {
    // Проверка на пустую дату
    if (date == DateTime(1900, 1, 1)) {
      return '';
    }
    // Отформатируем дату
    var f = DateFormat('dd.MM.yyyy HH:mm:ss');
    return (f.format(date).toString());
  }

}

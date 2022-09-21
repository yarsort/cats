import 'package:cats/src/system/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScreenHistoryView extends StatefulWidget {
  const ScreenHistoryView({super.key});

  static const routeName = '/history';

  @override
  State<ScreenHistoryView> createState() => _ScreenHistoryViewState();
}

class _ScreenHistoryViewState extends State<ScreenHistoryView> {
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
                  subtitle: Column(
                    children: [
                      const Divider(),
                      Row(
                        children: [
                          Text(fullDateToString(fact.period)),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                fact.delete();
                                listFacts.remove(fact);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20,))
                        ],
                      ),
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

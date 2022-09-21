import 'dart:io';

import 'package:cats/src/bloc/fact/fact_bloc.dart';
import 'package:cats/src/views/history_view.dart';
import 'package:cats/src/system/constants.dart';
import 'package:cats/src/models/fact.dart';
import 'package:cats/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});

  static const routeName = '/';

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  @override
  void initState() {
    retrieveFacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('КотоФакти'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<FactBloc, FactState>(
          builder: (context, state) {
            if (state is FactInitial) {
              return bodyProgress();
            }
            if (state is FactLoaded) {
              return infoFact(state.fact);
            } else {
              return const Text('Ой лишенько, трапилась якась помилка!');
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    saveFacts();
    Hive.box('facts').close();
    super.dispose();
  }

  void retrieveFacts() async {
    var box = Fact.getHiveBoxFacts();
    listFacts.addAll(box.values.toList().cast<Fact>());
  }

  void saveFacts() {
    for (Fact fact in listFacts) {
      fact.save();
    }
  }

  Widget bodyProgress() {
    return const Center(
        child: CircularProgressIndicator(
      value: null,
      strokeWidth: 4.0,
    ));
  }

  Widget noFacts() {
    return ListView(
      shrinkWrap: true,
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.car_rental,
                color: Colors.grey,
                size: 60.0,
              ),
              Text('Список фактів порожній',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget infoFact(Fact fact) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          photoCat(fact),
          descriptionCat(fact),
          operationCat(fact),
        ],
      ),
    );
  }

  Widget photoCat(fact) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1, color: Colors.black12)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 250,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Image.file(File(fact.imagePath),
                  fit: BoxFit.cover),
                ))),
      ),
    );
  }

  Widget descriptionCat(fact) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1, color: Colors.black12)),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 519,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Цікавий факт про котів',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(fact.text,textAlign: TextAlign.justify,),
                  ],
                ))),
      ),
    );
  }

  Widget operationCat(fact){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1, color: Colors.black12)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
            child: SizedBox(
                width: double.infinity,
                //height: MediaQuery.of(context).size.height - 565,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buttonScreen(
                            action: () {
                              var indexItem = listFacts
                                  .indexWhere((element) => element.text == fact.text);
                              if (indexItem < 0) {
                                // Set adding time
                                fact.period = DateTime.now();

                                // Add to history
                                listFacts.add(fact);

                                // Update cashed image for updating on the screen
                                imageCache.clear();

                                // Store to Hive
                                final box = Fact.getHiveBoxFacts();
                                box.add(fact);

                                // Show message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.teal.shade500,
                                    content: const Text('Юхху, новий факт додано в історію!'),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.orange.shade300,
                                    content: const Text('Такий факт вже є в історії!'),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            textButton: 'Додати в замітки'),
                        buttonScreen(
                            action: () {
                              Navigator.restorablePushNamed(
                                  context, ScreenHistoryView.routeName);
                            },
                            textButton: 'Історія фактів'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buttonScreenNext(
                            action: () {
                              context.read<FactBloc>().add(NextFact());
                            },
                            textButton: 'Наступний факт про котів'),
                      ],
                    )
                  ],
                ))),
      ),
    );
  }

  Widget buttonScreen({action, textButton}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 24,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal.shade300)),
            onPressed: action,
            child: Text(textButton)));
  }

  Widget buttonScreenNext({action, textButton}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 38,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.teal)),
            onPressed: action,
            child: Text(textButton)));
  }
}

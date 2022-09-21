import 'package:cats/src/system/constants.dart';
import 'package:cats/src/http/fact_service.dart';
import 'package:cats/src/models/fact.dart';
import 'package:dio/dio.dart' as dio;
import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'fact_event.dart';
part 'fact_state.dart';

class FactBloc extends Bloc<FactEvent, FactState> {
  FactBloc() : super(FactInitial()) {
    on<LoadFact>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 1));

      FactService factService = FactService(dio.Dio());

      final response = await factService.getFact();
      final translatedText = await Fact.translateFact(response.fact);
      final imagePath =  await Fact.getFactImage();

      Fact fact = Fact(
          id: listFacts.length,
          text: translatedText,
          imagePath: imagePath,
          period: DateTime.now());

      emit(FactLoaded(fact));
    });
    on<NextFact>((event, emit) async {
      if (state is FactLoaded) {

        // Update cashed image for updating on the screen
        imageCache.clear();

        FactService factService = FactService(dio.Dio());

        final response = await factService.getFact();
        final translatedText = await Fact.translateFact(response.fact);
        final imagePath =  await Fact.getFactImage();

        Fact fact = Fact(
            id: listFacts.length,
            text: translatedText,
            imagePath: imagePath,
            period: DateTime.now());

        emit(FactLoaded(fact));
      }
    });
  }
}

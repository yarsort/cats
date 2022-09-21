
import 'package:cats/src/http/fact_response.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'fact_service.g.dart';

@RestApi(baseUrl: 'https://catfact.ninja')
abstract class FactService{

  factory FactService(Dio dio, {String? baseUrl}){
    dio.options = BaseOptions(
      receiveTimeout: 6000,
      connectTimeout: 6000,
      contentType: 'application/json',
      headers: {
        'Content-Type': 'application/json'
      }
    );

    return _FactService(dio, baseUrl: baseUrl);
  }

  @GET('/fact')
  Future<FactResponse> getFact();

}
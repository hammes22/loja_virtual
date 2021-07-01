import 'dart:io';
import 'package:dio/dio.dart';
import 'package:loja_virtual/models/cepaberto_address.dart';

const token = 'aa983956848f8f3f4db000ad3a5f3747';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);
      return address;
      // ignore: unused_catch_clause
    } on DioError catch (e) {
      return Future.error('Error ao buscar CEP');
    }
  }
}

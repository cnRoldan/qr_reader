import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

enum _Tipos { http, geo }

class ScanModel {
  int? id;
  String? tipo;
  String valor;

  LatLng getLatLng() {
    valor = valor.replaceFirst('?', ',');
    final latLng = valor.substring(4).split(',');
    final lat = double.parse(latLng[0]);
    final long = double.parse(latLng[1]);
    return LatLng(lat, long);
  }

  ScanModel({
    this.id,
    this.tipo,
    required this.valor,
  }) {
    if (valor.contains(_Tipos.http.name)) {
      tipo = 'http';
    } else if (valor.contains(_Tipos.geo.name)) {
      tipo = 'geo';
    }

  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
      };
}

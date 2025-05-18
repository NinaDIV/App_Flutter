
import 'dart:convert';

class Producto {
  int id;
  String nombre;
  double precio;
  int cantidad;
  
  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.cantidad,
  }); 

  factory Producto.fromJson(Map<String, dynamic> json) { 
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio'],
      cantidad: json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
    };
  }

  static String encode(List<Producto> productos) => json.encode(
    productos.map<Map<String, dynamic>>((p) => p.toJson()).toList(),
  ); // Fixed syntax error ): -> );

  static List<Producto> decode(String productos) =>
      (json.decode(productos) as List<dynamic>)
          .map<Producto>((item) => Producto.fromJson(item))
          .toList();
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GestionProductosSupabase extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<GestionProductosSupabase> {
  final supabase = Supabase.instance.client;
  List<dynamic> productos = [];

  final nombreCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController();

  int? productoEditando;
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    precioCtrl.dispose();
    cantidadCtrl.dispose();
    super.dispose();
  }

  Future<void> cargarProductos() async {
    try {
      final response = await supabase.from('productos').select();
      setState(() {
        productos = response;
      });
    } catch (e) {
      mostrarMensaje('Error al cargar productos');
    }
  }

  Future<void> agregarProducto() async {
    if (!_validarCampos()) return;

    try {
      setState(() => cargando = true);
      await supabase.from('productos').insert({
        'nombre': nombreCtrl.text.trim(),
        'precio': double.parse(precioCtrl.text),
        'cantidad': int.parse(cantidadCtrl.text),
      });
      mostrarMensaje('Producto agregado');
      limpiarCampos();
      cargarProductos();
    } catch (e) {
      mostrarMensaje('Error al agregar producto');
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<void> actualizarProducto(int id) async {
    if (!_validarCampos()) return;

    try {
      setState(() => cargando = true);
      await supabase.from('productos').update({
        'nombre': nombreCtrl.text.trim(),
        'precio': double.parse(precioCtrl.text),
        'cantidad': int.parse(cantidadCtrl.text),
      }).eq('id', id);
      mostrarMensaje('Producto actualizado');
      limpiarCampos();
      setState(() => productoEditando = null);
      cargarProductos();
    } catch (e) {
      mostrarMensaje('Error al actualizar producto');
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<void> eliminarProducto(int id) async {
    try {
      await supabase.from('productos').delete().eq('id', id);
      mostrarMensaje('Producto eliminado');
      cargarProductos();
    } catch (e) {
      mostrarMensaje('Error al eliminar producto');
    }
  }

  void limpiarCampos() {
    nombreCtrl.clear();
    precioCtrl.clear();
    cantidadCtrl.clear();
  }

  void cargarEnFormulario(Map prod) {
    setState(() {
      nombreCtrl.text = prod['nombre'];
      precioCtrl.text = prod['precio'].toString();
      cantidadCtrl.text = prod['cantidad'].toString();
      productoEditando = prod['id'];
    });
  }

  bool _validarCampos() {
    if (nombreCtrl.text.isEmpty || precioCtrl.text.isEmpty || cantidadCtrl.text.isEmpty) {
      mostrarMensaje('Todos los campos son obligatorios');
      return false;
    }

    try {
      double.parse(precioCtrl.text);
      int.parse(cantidadCtrl.text);
    } catch (_) {
      mostrarMensaje('Precio o cantidad inválidos');
      return false;
    }

    return true;
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Productos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: precioCtrl,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: cantidadCtrl,
              decoration: InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: cargando
                  ? null
                  : () {
                      if (productoEditando != null) {
                        actualizarProducto(productoEditando!);
                      } else {
                        agregarProducto();
                      }
                    },
              child: Text(productoEditando != null ? 'Actualizar' : 'Agregar'),
            ),
            Divider(),
            Expanded(
              child: productos.isEmpty
                  ? Center(child: Text('No hay productos'))
                  : ListView.builder(
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final p = productos[index];
                        return ListTile(
                          title: Text(p['nombre']),
                          subtitle:
                              Text('Precio: \$${p['precio']} - Cantidad: ${p['cantidad']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => cargarEnFormulario(p),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => eliminarProducto(p['id']),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

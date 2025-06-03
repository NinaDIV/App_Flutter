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
      setState(() => productos = response);
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
      mostrarMensaje('✅ Producto agregado');
      limpiarCampos();
      await cargarProductos();
    } catch (e) {
      mostrarMensaje('❌ Error al agregar producto');
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
      mostrarMensaje('🔄 Producto actualizado');
      limpiarCampos();
      setState(() => productoEditando = null);
      await cargarProductos();
    } catch (e) {
      mostrarMensaje('❌ Error al actualizar producto');
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<void> eliminarProducto(int id) async {
    try {
      await supabase.from('productos').delete().eq('id', id);
      mostrarMensaje('🗑️ Producto eliminado');
      await cargarProductos();
    } catch (e) {
      mostrarMensaje('❌ Error al eliminar producto');
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
      mostrarMensaje('⚠️ Todos los campos son obligatorios');
      return false;
    }

    try {
      double.parse(precioCtrl.text);
      int.parse(cantidadCtrl.text);
    } catch (_) {
      mostrarMensaje('⚠️ Precio o cantidad inválidos');
      return false;
    }

    return true;
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          if (productoEditando != null)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                limpiarCampos();
                setState(() => productoEditando = null);
              },
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Formulario
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        productoEditando != null ? 'Editar Producto' : 'Nuevo Producto',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: nombreCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: precioCtrl,
                        decoration: InputDecoration(
                          labelText: 'Precio',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: cantidadCtrl,
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                          prefixIcon: Icon(Icons.format_list_numbered),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: cargando
                              ? null
                              : () {
                                  if (productoEditando != null) {
                                    actualizarProducto(productoEditando!);
                                  } else {
                                    agregarProducto();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: productoEditando != null 
                                ? Colors.orange[700] 
                                : Colors.teal[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: cargando
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  productoEditando != null ? 'ACTUALIZAR' : 'AGREGAR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Lista de productos
              Expanded(
                child: productos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory, size: 60, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              'No hay productos registrados',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          final p = productos[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.teal[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${p['cantidad']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[800],
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                p['nombre'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                '\$${p['precio'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 15,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => cargarEnFormulario(p),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => eliminarProducto(p['id']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
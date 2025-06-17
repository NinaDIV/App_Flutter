 import 'package:flutter/material.dart';
import 'package:laboratorio04/app/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Producto> productos = [];
  int nextId = 0;
  
  // Definir colores más claros para la aplicación
  final Color primaryColor = const Color.fromARGB(255, 83, 112, 255);
  final Color secondaryColor = const Color.fromARGB(255, 240, 187, 14);
  final Color backgroundColor = Colors.grey.shade50;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('productos');
    if (data != null) {
      setState(() {
        productos = Producto.decode(data);
        nextId = productos.isNotEmpty
            ? productos.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1
            : 0;
      });
    }
  }

  Future<void> _saveProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Producto.encode(productos);
    await prefs.setString('productos', encodedData);
  }

  // Calcula el subtotal en función del precio y la cantidad
  double _calcularSubtotal(double precio, int cantidad) {
    return precio * cantidad;
  }

  void _addOrEditProducto({Producto? producto}) {
    final nameController = TextEditingController(text: producto?.nombre ?? "");
    final priceController = TextEditingController(
        text: producto?.precio.toString() ?? "");
    final qtyController = TextEditingController(
        text: producto?.cantidad.toString() ?? "");
        
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          producto == null ? 'Agregar Producto' : 'Editar Producto',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Producto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                prefixIcon: Icon(Icons.shopping_cart, color: primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                prefixIcon: Icon(Icons.attach_money, color: primaryColor),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: qtyController,
              decoration: InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                prefixIcon: Icon(Icons.format_list_numbered, color: primaryColor),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final nombre = nameController.text;
              final precio = double.tryParse(priceController.text) ?? 0;
              final cantidad = int.tryParse(qtyController.text) ?? 0;

              if (producto == null) {
                final newProducto = Producto(
                  id: nextId++,
                  nombre: nombre,
                  precio: precio,
                  cantidad: cantidad,
                );
                setState(() => productos.add(newProducto));
              } else {
                final index = productos.indexWhere((p) => p.id == producto.id);
                if (index != -1) {
                  setState(() {
                    productos[index] = Producto(
                      id: producto.id,
                      nombre: nombre,
                      precio: precio,
                      cantidad: cantidad,
                    );
                  });
                }
              }
              _saveProductos();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.black87,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteProducto(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          '¿Eliminar producto?',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('¿Estás seguro que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                productos.removeWhere((p) => p.id == id);
              });
              _saveProductos();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade300,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
  
  // Calcula el gran total de todos los productos
  double _calcularGranTotal() {
    double total = 0;
    for (var producto in productos) {
      total += producto.precio * producto.cantidad;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // Calcula el total general
    final double granTotal = _calcularGranTotal();
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 2,
        title: const Text(
          'Mis Productos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        children: [
          // Lista de productos (contenido principal)
          Expanded(
            child: productos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Presiona el botón + para agregar uno nuevo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        final subtotal = _calcularSubtotal(producto.precio, producto.cantidad);
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        producto.nombre,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: primaryColor),
                                          onPressed: () => _addOrEditProducto(producto: producto),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red.shade300),
                                          onPressed: () => _deleteProducto(producto.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoItem(Icons.attach_money, 'Precio', producto.precio.toStringAsFixed(2)),
                                    _buildInfoItem(Icons.format_list_numbered, 'Cantidad', '${producto.cantidad}'),
                                    _buildInfoItem(Icons.shopping_cart_checkout, 'Subtotal', subtotal.toStringAsFixed(2)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          
          // Panel de total en la parte inferior
          if (productos.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calculate,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Total General:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            granTotal.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Productos: ${productos.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          'Última actualización: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditProducto(),
        backgroundColor: secondaryColor,
        elevation: 1,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: secondaryColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
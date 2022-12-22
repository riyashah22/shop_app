import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/order_screen.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItemList = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(
                          context,
                          listen: false,
                        ).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clearCart();
                        Navigator.of(context).pushNamed(OrderScreen.routeName);
                      },
                      child: const Text(
                        'ORDER NOW',
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, i) => CartItem(
                id: cartItemList[i].id as String,
                productId: cart.items.keys.toList()[i],
                title: cartItemList[i].title,
                quantity: cartItemList[i].quantity,
                price: cartItemList[i].price,
              ),
            ),
          )
        ],
      ),
    );
  }
}

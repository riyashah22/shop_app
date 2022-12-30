import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    //Future.delayed(Duration.zero).then((_) async {

    //   _isLoading = true;

    //   Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    //   // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //...
                return const Center(
                  child: Text('An Error Ocurred!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      orderData.orders[i],
                    ),
                  ),
                );
              }
            }
          },
        )

        // To use this use stateful widget
        //     _isLoading
        //     ? CircularProgressIndicator()
        //     : ListView.builder(
        //         itemCount: orderData.orders.length,
        //         itemBuilder: (ctx, i) => OrderItem(
        //           orderData.orders[i],
        //         ),
        //       ),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_form_screen.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const ProductListScreen()),
    GoRoute(path: '/form', builder: (_, __) => const ProductFormScreen()),
    GoRoute(
      path: '/form/:uuid',
      builder: (context, state) => ProductFormScreen(uuid: state.pathParameters['uuid']),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gestion Produits',
      routerConfig: _router,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

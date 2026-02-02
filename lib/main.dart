import 'package:flutter/material.dart';
import 'package:pet_app/view/bottomnav.dart';
import 'package:pet_app/view_model/pet_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => PetViewModel())],
      child: MaterialApp(
        title: 'Pet Adoption App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const BottomNavvv(),
      ),
    );
  }
}

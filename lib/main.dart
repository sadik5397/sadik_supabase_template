import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/home.dart';

const supabaseUrl = 'https://dtvftekgbnvryzazlldu.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0dmZ0ZWtnYm52cnl6YXpsbGR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ1MDU1MzQsImV4cCI6MjA1MDA4MTUzNH0.r3OimbvMw1kPgFj-NVqC4SAbGvQSr0Jm9JEze2JpYik';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Flutter Test',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent), useMaterial3: true),
      home: const Home(),
    );
  }
}
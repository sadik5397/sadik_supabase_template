import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    readUsers();
    super.initState();
  }

  List<String> terminal = ["-----Initialized-----"];
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  late SupabaseStreamFilterBuilder userStream;

  Future<void> readUsers() async {
    setState(() => terminal.add("-----Data Loading-----"));
    userStream = Supabase.instance.client.from("users").stream(primaryKey: ["id"]);
    setState(() => terminal.add("-----Loaded-----"));
  }

  void addNewUser() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                decoration: const InputDecoration(hintText: "Name"),
                autofocus: true,
                focusNode: nameFocusNode,
                controller: nameController,
                onSubmitted: (value) async => FocusScope.of(context).requestFocus(emailFocusNode)),
            TextField(
                decoration: const InputDecoration(hintText: "Email"),
                controller: emailController,
                focusNode: emailFocusNode,
                onSubmitted: (value) async {
                  final newUser = {'name': nameController.text, 'email': emailController.text};
                  try {
                    await Supabase.instance.client.from("users").insert(newUser);
                    Navigator.pop(context);
                    nameController.clear();
                    emailController.clear();
                    setState(() => terminal.add("New user added: ${newUser["name"]}"));
                  } catch (e) {
                    setState(() => terminal.add("Error adding user: $e"));
                  }
                  FocusScope.of(context).unfocus();
                })
          ])));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Supabase Flutter Test")),
        floatingActionButton: FloatingActionButton(onPressed: addNewUser, child: const Icon(Icons.add)),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: terminal.length,
                itemBuilder: (context, index) => SelectableText(terminal[index], style: const TextStyle(fontSize: 18))),
          ),
          Expanded(
              flex: 5,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: userStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final users = snapshot.data!.reversed.toList();
                    return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(child: Text(users[index]["id"].toString())),
                              title: Text(users[index]["name"]),
                              subtitle: Text(users[index]["email"]),
                            ));
                  }))
        ]));
  }
}

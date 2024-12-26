import 'package:flutter/material.dart';
import '../database/member_database.dart';
import '../model/member.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  Future<void> createMember(String value) async {
    await MemberDatabase.createMember(newMember: Member(name: nameController.text, email: emailController.text));
    Navigator.pop(context);
    nameController.clear();
    emailController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> deleteMember(Member user) async {
    await MemberDatabase.deleteMember(deletableMember: user);
  }

  Future<void> updateMember(Member oldUser) async {
    await MemberDatabase.updateMember(oldMember: oldUser, newName: nameController.text, newEmail: emailController.text);
    Navigator.pop(context);
    nameController.clear();
    emailController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Supabase Flutter Test")),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                nameController.clear();
                emailController.clear();
              });
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          content: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextField(
                            decoration: const InputDecoration(hintText: "Name"),
                            autofocus: true,
                            controller: nameController,
                            onSubmitted: (value) async => FocusScope.of(context).requestFocus(emailFocusNode)),
                        TextField(decoration: const InputDecoration(hintText: "Email"), controller: emailController, focusNode: emailFocusNode, onSubmitted: createMember)
                      ])));
            },
            child: const Icon(Icons.add)),
        body: StreamBuilder<List<Member>>(
            stream: MemberDatabase.getMembers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<Member> members = snapshot.data!;
              return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    Member member = members[index];
                    return ListTile(
                        isThreeLine: true,
                        leading: CircleAvatar(backgroundImage: NetworkImage("https://avatar.iran.liara.run/public?username=${member.id}")),
                        title: Text(member.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Email: ${member.email ?? ''}'), Text('Member Since: ${member.createdAt.toString().split(" ").first}')]),
                        trailing: IconButton(onPressed: () async => await deleteMember(member), icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent)),
                        onTap: () {
                          setState(() {
                            nameController.text = member.name.toString();
                            emailController.text = member.email.toString();
                          });
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      content: Column(mainAxisSize: MainAxisSize.min, children: [
                                    TextField(
                                        decoration: const InputDecoration(hintText: "Name"),
                                        autofocus: true,
                                        controller: nameController,
                                        onSubmitted: (value) async => FocusScope.of(context).requestFocus(emailFocusNode)),
                                    TextField(
                                        decoration: const InputDecoration(hintText: "Email"),
                                        controller: emailController,
                                        focusNode: emailFocusNode,
                                        onSubmitted: (value) async => await updateMember(member))
                                  ])));
                        });
                  });
            }));
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/member.dart';

class MemberDatabase {
  static SupabaseQueryBuilder database = Supabase.instance.client.from("members");

  static Stream<List<Member>> getMembers() {
    SupabaseStreamBuilder memberStream = database.stream(primaryKey: ["id"]).order("created_at");
    Stream<List<Member>> members = memberStream.map((data) => data.map((memberMap) => Member.fromJson(memberMap)).toList());
    return members;
  }

  static Future<void> createMember({required Member newMember}) async {
    final memberJson = newMember.toJson();
    final insertData = Map<String, dynamic>.from(memberJson)..removeWhere((key, value) => value == null);
    await database.insert(insertData);
  }

  static Future<void> readMemberByEmail({required String email}) async {
    // Get user from database
  }

  static Future<void> updateMember({required Member oldMember, String? newName, newEmail}) async {
    final updatedMember = {'name': newName, 'email': newEmail};
    await database.update(updatedMember).eq('id', oldMember.id as int);
  }

  static Future<void> deleteMember({required Member deletableMember}) async {
    await database.delete().eq('id', deletableMember.id as int);
  }
}
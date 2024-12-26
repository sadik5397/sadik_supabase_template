class Member {
  int? id;
  String? name, email;
  DateTime? createdAt;

  Member({this.id, this.name, this.email, this.createdAt});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        id: json['id'] as int?, name: json['name'] as String?, email: json['email'] as String?, createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'created_at': createdAt?.toIso8601String()};
  }
}

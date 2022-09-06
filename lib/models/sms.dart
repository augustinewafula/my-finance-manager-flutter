class Sms {
  final int id;
  final String body;
  int synced;

  Sms({required this.id, required this.body, required this.synced});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'synced': synced,
    };
  }

  set setSynced(int synced) {
    this.synced = synced;
  }

  @override
  String toString() {
    return 'Sms{id: $id, body: $body, synced: $synced}';
  }
}

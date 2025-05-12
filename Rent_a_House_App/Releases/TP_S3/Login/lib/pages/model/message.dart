class Message{
  int? id;
  String? senderMessage;
  String? receiverMessage;
  String? bodyMessage;
  DateTime? dateMessage;
}
class MessageDBHelper {
  final MessageDBHelper _dbHelper = MessageDBHelper.instance;

  Future<int> insert(Message message) async {
    return _dbHelper.insert(toMap(message));
  }

  Future<Message> queryById(int id) async {
    return fromMap(await _dbHelper.queryById(id));
  }

  Future<List<Message>> queryAll() async {
    List<Map<String, dynamic>> messageMapList = await _dbHelper.queryAll();
    return messageMapList.map((e) => fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    return _dbHelper.delete(id);
  }

  Future<int> update(Message message) async {
    return _dbHelper.update(toMap(Message));
  }

  Map<String, dynamic> toMap(Message message) {
    return {
      MessageDBHelper.columnId: message.id,
      MessageDBHelper.columnSenderMessage: message.senderMessage,
      MessageDBHelper.columnReceiverMessage: message.receiverMessage,
      MessageDBHelper.columnBodyMessage: message.bodyMessage,
      MessageDBHelper.columnDateMessage:
          message.dateMessage?.millisecondsSinceEpoch,
    };
  }

  Report fromMap(Map<String, dynamic> map) {
    return Report()
      ..id = map[MessageDBHelper.columnId] as int
      ..senderMessage = map[MessageDBHelper.columnSenderMessage] as String
      ..receiverMessage = map[MessageDBHelper.columnReceiverMessage] as String
      ..bodyMessage = map[MessageDBHelper.columnBodyMessage] as String
      ..dateMessage = DateTime.fromMillisecondsSinceEpoch(
          map[MessageDBHelper.columnDateMessage] as int);
  }

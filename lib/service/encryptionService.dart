class EncryptionService {
  var encryptionKey = '!#&*(FKDSjfkdafjkafdk!@!#2131241';
  String encrypt(String data) {
    int charCount = data.length;
    List encrypted = [];
    int kp = 0;
    int kl = encryptionKey.length - 1;
    for (var i = 0; i < charCount; i++) {
      int other = data[i].codeUnits[0] ^ encryptionKey[kp].codeUnitAt(0);
      print(other);
      encrypted.insert(i, other);
      kp = (kp < kl) ? (++kp) : (0);
    }
    return dataToString(encrypted);
  }

  String decrypt(data) {
    return encrypt(data);
  }

  static String dataToString(data) {
    String s = "";
    for (var i = 0; i < data.length; i++) {
      s += String.fromCharCode(data[i]);
    }
    return s;
  }
}

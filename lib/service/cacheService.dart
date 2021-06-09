import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:parking/model/tokenModel/token.dart';
import 'package:parking/service/encryptionService.dart';
import 'package:path_provider/path_provider.dart' as path;

class CacheService {
  factory CacheService() => _sharedInstance();
  static CacheService? _instance;
  CacheService._() {
    //
  }
  static CacheService _sharedInstance() {
    if (_instance == null) {
      _instance = CacheService._();
    }
    return _instance!;
  }

  Future<Directory> getLocalDirectory() async {
    Directory tempDir = await path.getTemporaryDirectory();
    return tempDir;
  }

  Future<void> deleteDirectory(
    String directoryName,
  ) async {
    Directory tempDir = await getLocalDirectory();
    Directory directory = new Directory('${tempDir.path}/$directoryName');
    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();
      if (files.length > 0) {
        files.forEach((file) {
          file.deleteSync();
          print('=== Delete file : ${file.path}');
        });
      }
    } else {
      throw Exception('Directory not find');
    }
    directory.deleteSync();
  }

  Future<void> deleteFile(
    String path,
  ) async {
    File file = File(path);
    if (file.existsSync()) {
      List<FileSystemEntity> files = file.parent.listSync();
      if (files.length > 0) {
        files.forEach((f) {
          if (f.path == file.path) {
            f.deleteSync();
            print('== delete success  ${file.path} ===>>>>');
          }
        });
      }
    } else {
      throw Exception('fail to delete ${file.path} ===>>>>');
    }
  }

  Future<bool> checkFileExits(String fullpath) async {
    return File(fullpath).exists();
  }

  Future<bool> checkDirectoryExits(String dirPath) async {
    Directory directory = Directory(dirPath);
    return directory.exists();
  }

  Future<void> saveDataToFile(Map<String, dynamic> data, File file) async {
    try {
      file.writeAsStringSync(convert.json.encode(data));
      print('== write data success ${convert.json.encode(data)} ===>>>>');
    } catch (e) {
      print(e);
    }
  }

  Future<File> createFile(String fullPath) async {
    File file = File(fullPath);
    bool fileExits = await checkFileExits(fullPath);
    if (fileExits) {
      deleteFile(fullPath);
      file.createSync();
    } else {
      await checkDirectoryExits(file.parent.path).then((exits) {
        print(exits);
        if (exits) {
          file.createSync();
        } else {
          try {
            file.createSync(recursive: true);
          } catch (e) {
            print(e);
          }
        }
      });
    }
    print('== create file success === $fullPath>>>>');
    return file;
  }

  Future<Directory> createDirectory(String dirName) async {
    Directory temDir = await getLocalDirectory();
    Directory directory = Directory('${temDir.path}/$dirName');
    bool exits = await checkDirectoryExits(directory.path);
    if (exits) {
      return directory;
    } else {
      return await directory.create().catchError((e) {
        print(e);
      });
    }
  }

  Future<Null> deleteAll(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteAll(child);
      }
    }
    await file.delete();
  }

// ---------------------  token ----------------------

  Future<String> getTokenPath() async {
    String tokenFileName = 'token.json';
    String dirName = 'token';
    Directory tempDir = await getLocalDirectory();
    String tokenPath = '${tempDir.path}/$dirName/$tokenFileName';
    return tokenPath;
  }

  Future<Token> getToken() async {
    File file = File(await getTokenPath());
    if (await file.exists()) {
      Token temp =
          Token.fromJson(convert.jsonDecode(await file.readAsString()));
      Token token = Token();
      token.token = EncryptionService().decrypt(temp.token);
      return token;
    } else {
      return Token();
    }
  }

  Future<Null> setToken({required Token token}) async {
    String encryptionToken = EncryptionService().encrypt(token.token!);

    Token temp = Token();

    temp.token = encryptionToken;

    await saveDataToFile(temp.toJson(), await createFile(await getTokenPath()));
  }

  Future<void> deleteToken() async {
    await deleteDirectory('token');
  }

  // ------------------ parking -------------------------
  Future<String> getParkingPath() async {
    String tokenFileName = 'parking.json';
    String dirName = 'parking';
    Directory tempDir = await getLocalDirectory();
    String tokenPath = '${tempDir.path}/$dirName/$tokenFileName';
    return tokenPath;
  }

  Future<Token> getParking() async {
    File file = File(await getParkingPath());
    if (await file.exists()) {
      Token temp =
          Token.fromJson(convert.jsonDecode(await file.readAsString()));
      Token token = Token();
      token.token = EncryptionService().decrypt(temp.token);
      return token;
    } else {
      return Token();
    }
  }
}

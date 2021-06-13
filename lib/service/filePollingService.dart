import 'dart:io';

import 'package:watcher/watcher.dart';

class FilePollingService {
  // -------start singleton -----------
  factory FilePollingService() => _sharedInstance();
  static FilePollingService? _instance;
  FilePollingService._() {
    //
  }
  static FilePollingService _sharedInstance() {
    if (_instance == null) {
      _instance = FilePollingService._();
    }
    return _instance!;
  }

//  ---------end singleton -------------
  watchDir(String dirPath) async {
    var watcher = DirectoryWatcher(dirPath, pollingDelay: Duration(days: 1));
    watcher.events.listen((event) async {
      print(event);
      File file = File(event.path);
      if (file is File) {
        print('file');
      }
      if (file is Directory) {
        print('directory');
      }
    });
  }
}

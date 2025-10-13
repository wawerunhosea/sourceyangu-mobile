import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sourceyangu/app/utils/device_utils/permission_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Read, write, delete files
class FileSystemService {
  Future<FilePickerResult?> pickFile() async {
    final granted = await PermissionManager.ensure(
      Permission.storage,
      'storage_permission',
    );
    if (!granted) return null;
    return await FilePicker.platform.pickFiles();
  }
}

// Read and Write caches

class StorageService {
  Future<File> writeCache(String filename, String content) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    return file.writeAsString(content);
  }

  Future<String?> readCache(String filename) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    if (await file.exists()) return await file.readAsString();
    return null;
  }
}

// Access secure device storage

class SecureStorageService {
  final _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}

// Clip board

class ClipboardService {
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  Future<String?> pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    return data?.text;
  }
}

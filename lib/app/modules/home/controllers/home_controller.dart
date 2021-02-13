import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:encrypt/encrypt.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  static final to = Get.find<HomeController>();
  static final key = Key.fromUtf8('ThisIsATopSecretKeyOfLength32bit');
  final iv = IV.fromUtf8("InitialVector16b");
  final encrypter = Encrypter(AES(key));
  RxBool permissionGranted = false.obs;
  RxString _externalDocumentsDirectory = ''.obs;

  Future<Directory> get getExternalDir async {
    _externalDocumentsDirectory.value = '/storage/emulated/0';
    if (await Directory('${_externalDocumentsDirectory.value}/CryptFlutter')
        .exists()) {
      final externalDir =
          Directory('${_externalDocumentsDirectory.value}/CryptFlutter');
      return externalDir;
    } else {
      await Directory('${_externalDocumentsDirectory.value}/CryptFlutter')
          .create(recursive: true);
      final externalDir =
          Directory('${_externalDocumentsDirectory.value}/CryptFlutter');
      return externalDir;
    }
  }

  Future<void> requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      permissionGranted.value = result.isGranted;
    }
  }

  Future<void> getDecryptedFile() async {
    final d = await getExternalDir;
    FilePickerResult result = await FilePicker.platform.pickFiles();
    String fileName = result.files.single.name.split('.').first;
    String ext = result.files.single.name.split('.')[1];
    Uint8List encData = await _readData(result.files.single.path);
    var plainData = decryptData(encData);
    String p = await _writeData(plainData, d.path + '/$fileName.$ext');
    print("file decrypted successfully: $p");
    Get.rawSnackbar(
        title: 'Decrypted File successfully! (Tap to Open)',
        message: 'location: $p',
        onTap: (_) async {
          await OpenFile.open(p);
        });
  }

  Future<void> getEncryptedFile() async {
    final d = await getExternalDir;
    FilePickerResult result = await FilePicker.platform.pickFiles();
    final fileName = result.files.single.name;
    Uint8List data = await _readData(result.files.single.path);
    var encResult = encryptData(data);
    String p = await _writeData(encResult, d.path + '/$fileName.aes');
    print("file encrypted successfully: $p");
    Get.rawSnackbar(
        title: 'Encrypted File successfully! (Tap to share)',
        message: 'location: $p',
        duration: Duration(seconds: 5),
        onTap: (_) {
          Share.shareFiles([p]);
        });
  }

  List<int> encryptData(List<int> input) {
    print("Encrypting File...");
    final encrypted = encrypter.encryptBytes(input, iv: iv);
    return encrypted.bytes;
  }

  List<int> encryptString(String string) {
    print("Encrypting String...");
    final encrypted = encrypter.encrypt(string, iv: iv);
    return encrypted.bytes;
  }

  List<int> decryptData(List<int> encData) {
    print("File decryption in progress...");
    Encrypted en = new Encrypted(encData);
    return encrypter.decryptBytes(en, iv: iv);
  }

  String decryptString(List<int> encData) {
    print("String decryption in progress...");
    Encrypted en = new Encrypted(encData);
    return encrypter.decrypt(en, iv: iv);
  }

  Future<Uint8List> _readData(String fileNameWithPath) async {
    print("Reading data...");
    File f = File(fileNameWithPath);
    return await f.readAsBytes();
  }

  Future<String> _writeData(
      List<int> dataToWrite, String fileNameWithPath) async {
    print("Writing Data...");
    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataToWrite);
    return f.absolute.path.toString();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    requestStoragePermission();
    super.onReady();
  }

  @override
  void onClose() {}
}

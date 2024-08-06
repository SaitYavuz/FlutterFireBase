import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newfirebase/core/color/color.dart';
import 'package:newfirebase/core/const/string.dart';
import 'package:newfirebase/screen/sing_out_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoListScreen extends StatefulWidget {
  const PhotoListScreen({super.key});

  @override
  State<PhotoListScreen> createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _uploadImage(_image!);
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fotoğraf seçilmedi"),
          ),
        );
      }
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final ref = _storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(imageFile);

    try {
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('images').add({
          'url': downloadUrl,
          'time': FieldValue.serverTimestamp(),
          'user': user.uid,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.photoUp),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Kullanıcı oturum açmamış"),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Yükleme hatası"),
          ),
        );
      }
    }
  }

  Future<void> _downloadImage(String imageUrl) async {
    try {
      // İzinleri talep etme
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Depolama izni verilmedi'),
            ),
          );
        }
        return;
      }

      final ref = _storage.refFromURL(imageUrl);
      final data = await ref.getData();
      if (data != null) {
        final tempDir = await getTemporaryDirectory();
        final file = File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(data);

        // Fotoğrafı galeriye kaydetme
        final result = await GallerySaver.saveImage(file.path);
        if (result != null && result) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Resim indirildi ve galeriye kaydedildi'),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Resim galeriye kaydedilemedi'),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Download error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("İndirme hatası"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.photoGaleri),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SingOutScreen(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app_sharp),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection('images')
            .where('user', isEqualTo: _auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint("Hata: ${snapshot.error}");
            return const Center(child: Text(AppStrings.hata));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Fotoğraf yok"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final imageData = snapshot.data!.docs[index].data();
              final imageUrl = imageData['url'] as String;
              final user = imageData['user'] as String;

              return ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: imageUrl.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _downloadImage(imageUrl),
                          child: Image.network(imageUrl),
                        )
                      : const Icon(Icons.image_not_supported),
                ),
                title: Text('Kullanıcı: $user'),
                trailing: IconButton(
                  onPressed: () => _downloadImage(imageUrl),
                  icon: const Icon(Icons.download_for_offline_outlined),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.grey,
        onPressed: () {
          _getImage();
        },
        child: const Icon(
          Icons.add_a_photo,
          color: AppColor.white,
        ),
      ),
    );
  }
}

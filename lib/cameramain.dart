import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  //String x = "XXX";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "my-app-key",
      appId: "my-app-id",
      messagingSenderId: "my-messaging-sender-id",
      projectId: "my-project-id",
      storageBucket: "myapp.appspot.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<XFile>? imageFileList = [];
  var imagePicker;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }
  Future<void> _getImages() async {
    // Open the device's image picker
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    // Set the selected images to the state
    setState(() {});
  }

  Future<void> _uploadImages() async {
    // Iterate over the list of images
    //_imageFileList.forEach
    //int i = 0;
    Fluttertoast.showToast(
        msg: "Upload is successful.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromRGBO(219, 226, 239, 1),
        textColor: const Color.fromRGBO(17, 45, 78, 1),
        fontSize: 16.0
    );
    final List<File> selectedPostImages = imageFileList!.map<File>((XFile) => File(XFile.path)).toList();
    for (var imageFile in selectedPostImages!) {
      // Generate a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Create a reference to the file in Firebase Storage
      Reference reference = _storage.ref().child(fileName.toString());
      //Reference reference = _storage.ref().child(fileName+i.toString());
      //i++;
      // Upload the file to Firebase Storage
      // UploadTask uploadTask = reference.putFile(imageFile).whenComplete(() => geturl(reference));
      UploadTask uploadTask = reference.putFile(imageFile);
      String url = await reference.getDownloadURL();

      // Do something with the URL (e.g. save it to a database)
      print('File uploaded: $url');
      // Get the URL for the uploaded file
      //await uploadTask.onComplete;

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(219, 226, 239, 1),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          selectedItemColor: const Color.fromRGBO(63, 114, 175, 1),
        ),
        appBar: AppBar(
          title: const Text('Upload Image'),
          backgroundColor: const Color.fromRGBO(17, 45, 78, 1),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: imageFileList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          File(imageFileList![index].path),
                          height: 200,
                          width: 200,
                        );
                      }),
                ),
              ),
              Text('Selected images: ${imageFileList!.length}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: const Color.fromRGBO(17, 45, 78, 1),
                    onPressed: _getImages,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.add_a_photo,
                                color: const Color.fromRGBO(219, 226, 239, 1),
                                size: 24.0,
                                semanticLabel: "",
                              ),
                            ),
                          ),
                          TextSpan(text: 'Add Photos'),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: const Color.fromRGBO(17, 45, 78, 1),
                    onPressed: _uploadImages,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.upload,
                                color: const Color.fromRGBO(219, 226, 239, 1),
                                size: 24.0,
                                semanticLabel:
                                'Text to announce in accessibility modes',
                              ),
                            ),
                          ),
                          TextSpan(text: 'Upload'),
                        ],
                      ),
                    ),
                    //Text('CAMERA'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

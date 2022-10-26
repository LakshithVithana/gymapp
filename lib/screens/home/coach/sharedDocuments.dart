import 'dart:io';
import 'dart:typed_data';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:gymapp/shared/loading.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({Key? key, this.club}) : super(key: key);
  final String? club;

  @override
  _UploadDocumentsState createState() => _UploadDocumentsState();
}

final CollectionReference clubsCollection =
    FirebaseFirestore.instance.collection('clubs');

class _UploadDocumentsState extends State<UploadDocuments> {
  bool isLoading = false;
  bool isProgressBarLoading = false;
  bool pageLoading = false;

  Future getPdfAndUpload() async {
    setState(() {
      isLoading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);

      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      // Upload file
      await FirebaseStorage.instance
          .ref()
          .child('${widget.club}/$fileName')
          .putData(fileBytes)
          .whenComplete(() => null)
          .then((value) {
        print('Upload Completed');
        value.ref.getDownloadURL().then((value) {
          updateUrlToFirestore(value, widget.club, file.name, file.extension);
        });
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        print(error);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      // User canceled the picker
    }
  }

  bool downloading = true;
  String downloadingStr = "No data";
  double download = 0.0;
  late File f;

  Future updateUrlToFirestore(String fileValue, String? club, String fileName,
      String? fileExtension) async {
    return await clubsCollection
        .where("name", isEqualTo: club)
        .get()
        .then((value) async {
      clubsCollection.doc(value.docs[0].id).update({
        'assets': FieldValue.arrayUnion([
          {
            'url': fileValue,
            'name': fileName,
            'type': fileExtension,
          }
        ]),
      });
      // clubsCollection.doc(value.docs[0].id).update({
      //   'assets': FieldValue.arrayRemove([
      //     {
      //       'url': '',
      //       'name': '',
      //       'type': '',
      //     }
      //   ]),
      // });
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    });
  }

  Future downloadFile({String? url}) async {
    var docUrl = url!;
    try {
      setState(() {
        isProgressBarLoading = true;
      });
      Dio dio = Dio();
      var dir = await getApplicationDocumentsDirectory();
      f = File("${dir.path}/docs/abc.docx");
      String fileName = docUrl.substring(docUrl.lastIndexOf("/") + 1);
      dio.download(docUrl, "${dir.path}/$fileName",
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          download = (rec / total) * 100;
          print('$fileName downloaded');
          downloadingStr =
              "Downloading Image : ${(download).toStringAsFixed(0)}";
        });
        setState(() {
          downloading = false;
          downloadingStr = "Completed";
          isProgressBarLoading = false;
        });
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return pageLoading == true
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color(0xff154c79),
            appBar: AppBar(
              backgroundColor: const Color(0xff133957),
              title: const Text('Upload Docs'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffD90429),
                    ),
                    onPressed: () {
                      getPdfAndUpload();
                    },
                    child: isLoading == false
                        ? const Text(
                            '+ Docs',
                            style: TextStyle(color: Colors.white),
                          )
                        : const CircularProgressIndicator(
                            backgroundColor: Color(0xffD90429),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<QuerySnapshot>(
                future:
                    clubsCollection.where("name", isEqualTo: widget.club).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final assetUrls = snapshot.data!.docs[0]["assets"];
                    return ListView.builder(
                      itemCount: assetUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: assetUrls[index]['type'] != ''
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      onTap: assetUrls[index]['type'] == "pdf"
                                          ? () async {
                                              PDFDocument doc =
                                                  await PDFDocument.fromURL(
                                                      assetUrls[index]['url']);

                                              Get.to(() =>
                                                  PDFViewer(document: doc));
                                            }
                                          : assetUrls[index]['type'] == "jpg" ||
                                                  assetUrls[index]['type'] ==
                                                      "jpeg"
                                              ? () {
                                                  Get.to(
                                                    () => PhotoView(
                                                      imageProvider:
                                                          NetworkImage(
                                                              assetUrls[index]
                                                                  ['url']),
                                                    ),
                                                  );
                                                }
                                              : () {
                                                  downloadFile(
                                                      url: assetUrls[index]
                                                          ['url']);
                                                },
                                      leading: assetUrls[index]['type'] ==
                                                  "jpg" ||
                                              assetUrls[index]['type'] == "jpeg"
                                          ? CircleAvatar(
                                              child: Image.network(
                                                  assetUrls[index]["url"]))
                                          : assetUrls[index]['type'] == "pdf"
                                              ? const Icon(Icons.picture_as_pdf)
                                              : const Icon(Icons.description),
                                      title: Text(assetUrls[index]['name']),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 30.0,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            pageLoading = true;
                                          });
                                          await FirebaseStorage.instance
                                              .ref()
                                              .child(
                                                  '${widget.club}/${assetUrls[index]['name']}')
                                              .delete();

                                          await clubsCollection
                                              .where("name",
                                                  isEqualTo: widget.club)
                                              .get()
                                              .then((value) async {
                                            clubsCollection
                                                .doc(value.docs[0].id)
                                                .update({
                                              'assets': FieldValue.arrayRemove([
                                                {
                                                  "name": assetUrls[index]
                                                      ['name'],
                                                  "type": assetUrls[index]
                                                      ['type'],
                                                  "url": assetUrls[index]
                                                      ['url'],
                                                }
                                              ]),
                                            });
                                          });
                                          setState(() {
                                            pageLoading = false;
                                          });
                                        },
                                      ),
                                    ),
                                    assetUrls[index]['type'] == "docx"
                                        ? Container(
                                            height: 4.0,
                                            width: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        16.0) /
                                                    100) *
                                                download,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(4),
                                                bottomRight: Radius.circular(4),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              : const SizedBox(),
                        );
                      },
                    );
                  } else {
                    return const Loading();
                  }
                },
              ),
            ),
          );
  }
}

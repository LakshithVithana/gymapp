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

class ViewDocuments extends StatefulWidget {
  const ViewDocuments({Key? key, this.club}) : super(key: key);
  final String? club;

  @override
  _ViewDocumentsState createState() => _ViewDocumentsState();
}

final CollectionReference clubsCollection =
    FirebaseFirestore.instance.collection('clubs');

class _ViewDocumentsState extends State<ViewDocuments> {
  bool isLoading = false;
  bool isProgressBarLoading = false;
  bool pageLoading = false;

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
              title: const Text('Shared Docs'),
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
                        if (assetUrls![index]['name'] != "") {
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  onTap: assetUrls[index]['type'] == "pdf"
                                      ? () async {
                                          PDFDocument doc =
                                              await PDFDocument.fromURL(
                                                  assetUrls[index]['url']);

                                          Get.to(
                                              () => PDFViewer(document: doc));
                                        }
                                      : assetUrls[index]['type'] == "jpg" ||
                                              assetUrls[index]['type'] == "jpeg"
                                          ? () {
                                              Get.to(
                                                () => PhotoView(
                                                  imageProvider: NetworkImage(
                                                      assetUrls[index]['url']),
                                                ),
                                              );
                                            }
                                          : () {
                                              downloadFile(
                                                  url: assetUrls[index]['url']);
                                            },
                                  leading: assetUrls[index]['type'] == "jpg" ||
                                          assetUrls[index]['type'] == "jpeg"
                                      ? CircleAvatar(
                                          child: Image.network(
                                              assetUrls[index]["url"]))
                                      : assetUrls[index]['type'] == "pdf"
                                          ? const Icon(Icons.picture_as_pdf)
                                          : const Icon(Icons.description),
                                  title: Text(assetUrls[index]['name']),
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
                            ),
                          );
                        } else {
                          return Container();
                        }
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

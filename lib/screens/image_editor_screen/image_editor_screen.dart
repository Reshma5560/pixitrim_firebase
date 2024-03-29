import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:pixytrim/screens/image_editor_screen/_paint_over_image.dart';

import '../../common/custom_color.dart';
import '../../common/helper/ad_helper.dart';

class ImageEditorScreen extends StatefulWidget {
  File file;
  int newIndex;
  ImageEditorScreen({required this.file, required this.newIndex});

  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final GlobalKey repaintKey = GlobalKey();
  final csController = Get.find<CameraScreenController>();

  late AdWidget? adWidget;

  late BannerAdListener listener;

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    sizes: [
      AdSize.banner,
    ],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
      },

      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.

        ad.dispose();
        print('Ad failed to load: $error');
      },

      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    adWidget = AdWidget(
      ad: myBanner,
    );
    myBanner.load();
  }

  @override
  void dispose() {
    super.dispose();
    if (!mounted) return;
    myBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              MainBackgroundWidget(),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    appBar(),
                    SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              child: ImagePainter.file(
                                widget.file,
                                repaintKey: repaintKey,
                                key: _imageKey,
                                // scalable: true,
                                initialStrokeWidth: 2,
                                initialColor: Colors.green,
                                initialPaintMode: PaintMode.freeStyle,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: 48,
                            child: adWidget,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 50,
        width: Get.width,
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    //Get.back();
                    showAlertDialog();
                  },
                  child: Container(
                      child: Image.asset(
                    Images.ic_left_arrow,
                    scale: 2.5,
                  )),
                ),
                Container(
                  child: Text(
                    "Image Edit",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showTopNotification(
                      displayText: "Please Wait...",
                      leadingIcon: Icon(
                        Icons.image,
                        color: AppColor.kBlackColor,
                      ),
                      displayTime: 2,
                    );
                    // Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 1,);
                    await renameAndSaveImage().then((value) {
                      csController.interstitialAd?.show();
                      Get.back();
                    });
                  },
                  child: Container(child: Icon(Icons.check_rounded)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageEditingIcon() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 8),
                decoration: borderGradientDecoration(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Image.asset(
                      Images.ic_edit,
                      scale: 2.5,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(2),
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 8),
                  decoration: borderGradientDecoration(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    //margin: EdgeInsets.only(left: 10, right: 10),

                    child: Center(
                        child: Image.asset(
                      Images.ic_color_palate,
                      scale: 2.5,
                    )),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 8),
                decoration: borderGradientDecoration(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Image.asset(
                    Images.ic_paint_brush,
                    scale: 2.5,
                  )),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 8),
                decoration: borderGradientDecoration(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Image.asset(
                    Images.ic_text,
                    scale: 2.5,
                  )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Center(
                  child: Icon(
                Icons.undo_outlined,
                size: 30,
              )),
              SizedBox(
                width: 10,
              ),
              Center(child: Icon(Icons.close, size: 30)),
            ],
          )
        ],
      ),
    );
  }

  // Rename & Save Capture Image
  Future renameAndSaveImage() async {
    DateTime time = DateTime.now();
    final imgName =
        "${time.day}_${time.month}_${time.year}_${time.hour}_${time.minute}_${time.second}";
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/$imgName.jpg';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytesSync(image!);
    csController.addImageFromCameraList[widget.newIndex] = imgFile;
    // await GallerySaver.saveImage(imgFile.path, albumName: "OTWPhotoEditingDemo");
    renameImage();
  }

  renameImage() async {
    String orgPath = csController.addImageFromCameraList[widget.newIndex].path;
    String frontPath =
        orgPath.split('app_flutter')[0]; // Getting Front Path of file Path
    print('frontPath: $frontPath');
    List<String> ogPathList = orgPath.split('/');
    print('ogPathList: $ogPathList');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    print('ogExt: $ogExt');
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.day}-${today.month}-${today.year}_${today.hour}:${today.minute}:${today.second}";
    print('Date: $dateSlug');
    csController.addImageFromCameraList[widget.newIndex] = await csController
        .addImageFromCameraList[widget.newIndex]
        .rename("${frontPath}cache/pixytrim_$dateSlug.$ogExt");

    print(
        'Final FIle Name : ${csController.addImageFromCameraList[widget.newIndex].path}');
  }

  // Future _capturePng() async {
  //   try {
  //     print('inside');
  //     DateTime time = DateTime.now();
  //     final imgName = "${time.day}_${time.month}_${time.year}_${time.hour}_${time.minute}_${time.second}";
  //     RenderRepaintBoundary boundary =
  //     repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     print(boundary);
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     print("image:===$image");
  //     final directory = (await getApplicationDocumentsDirectory()).path;
  //     ByteData? byteData =
  //     await image.toByteData(format: ui.ImageByteFormat.png);
  //     print("byte data:===$byteData");
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //     File imgFile = new File('$directory/$imgName.png');
  //     await imgFile.writeAsBytes(pngBytes);
  //     setState(() {
  //       csController.addImageFromCameraList[csController.selectedImage.value] = imgFile;
  //     });
  //     //print("File path====:${blur!.path}");
  //     //collageScreenController.imageFileList = pngBytes;
  //     //bs64 = base64Encode(pngBytes);
  //     print("png Bytes:====$pngBytes");
  //     //print("bs64:====$bs64");
  //     //setState(() {});
  //     //await saveImage();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  showAlertDialog() {
    Widget cancelButton = IconsButton(
      onPressed: () {
        Get.back();
      },
      text: 'No',
      color: AppColor.kBorderGradientColor3,
      textStyle: TextStyle(color: Colors.white),
    );

    Widget continueButton = IconsButton(
      onPressed: () async {
        csController.interstitialAd?.show();
        Get.back();
        Get.back();
      },
      text: 'yes',
      color: AppColor.kBorderGradientColor1,
      textStyle: TextStyle(color: Colors.white),
    );

    Dialogs.materialDialog(
      lottieBuilder: LottieBuilder.asset(
        "assets/lotties/9511-loading.json",
      ),
      color: Colors.white,
      msg: "Do you want to exit?",
      msgStyle: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      context: context,
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}

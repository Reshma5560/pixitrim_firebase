import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../common/helper/ad_helper.dart';

class PhotoBlendController extends GetxController {
  RxDouble borderWidthValue = 0.0.obs;
  Rx<String> selectedBlendModeText = "clear".obs;

  Rx<Color> selectedColor = Colors.white.obs;
  Rx<BlendMode> blendMode = BlendMode.saturation.obs;

  Rx<BlendMode> selectedBlendMode = BlendMode.clear.obs;

  late AdWidget? adWidget;

  late BannerAdListener listener;

  TextEditingController blendTextController = TextEditingController();

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    sizes: [
      AdSize.banner,
    ],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  @override
  void onInit() {
    // TODO: implement initState
    super.onInit();

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
    myBanner.dispose();
  }

  List<String> BlendingList = [
    "clear",
    "color",
    "colorBurn",
    "colorDodge",
    "darken",
    "difference",
    "dst",
    "dstATop",
    "dstIn",
    "dstOut",
    "dstOver",
    "exclusion",
    "hardLight",
    "hue",
    "lighten",
    "luminosity",
    "modulate",
    "multiply",
    "overlay",
    "plus",
    "saturation",
    "screen",
    "softLight",
    "src",
    "srcATop",
    "srcIn",
    "srcOut",
    "srcOver",
    "xor",
  ];

  List<DropdownMenuItem<String>> get blendingItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Text("clear"),
        value: "clear",
        onTap: () {
          blendMode.value = BlendMode.clear;
        },
      ),
      DropdownMenuItem(
        child: Text("color"),
        value: "color",
        onTap: () {
          blendMode.value = BlendMode.color;
        },
      ),
      DropdownMenuItem(
        child: Text("colorBurn"),
        value: "colorBurn",
        onTap: () {
          blendMode.value = BlendMode.colorBurn;
        },
      ),
      DropdownMenuItem(
        child: Text("colorDodge"),
        value: "colorDodge",
        onTap: () {
          blendMode.value = BlendMode.colorDodge;
        },
      ),
      DropdownMenuItem(
        child: Text("darken"),
        value: "darken",
        onTap: () {
          blendMode.value = BlendMode.darken;
        },
      ),
      DropdownMenuItem(
        child: Text("difference"),
        value: "difference",
        onTap: () {
          blendMode.value = BlendMode.difference;
        },
      ),
      DropdownMenuItem(
        child: Text("dst"),
        value: "dst",
        onTap: () {
          blendMode.value = BlendMode.dst;
        },
      ),
      DropdownMenuItem(
        child: Text("dstATop"),
        value: "dstATop",
        onTap: () {
          blendMode.value = BlendMode.dstATop;
        },
      ),
      DropdownMenuItem(
        child: Text("dstIn"),
        value: "dstIn",
        onTap: () {
          blendMode.value = BlendMode.dstIn;
        },
      ),
      DropdownMenuItem(
        child: Text("dstOut"),
        value: "dstOut",
        onTap: () {
          blendMode.value = BlendMode.color;
        },
      ),
      DropdownMenuItem(
        child: Text("dstOver"),
        value: "dstOver",
        onTap: () {
          blendMode.value = BlendMode.dstOver;
        },
      ),
      DropdownMenuItem(
        child: Text("exclusion"),
        value: "exclusion",
        onTap: () {
          blendMode.value = BlendMode.exclusion;
        },
      ),
      DropdownMenuItem(
        child: Text("hardLight"),
        value: "hardLight",
        onTap: () {
          blendMode.value = BlendMode.hardLight;
        },
      ),
      DropdownMenuItem(
        child: Text("hue"),
        value: "hue",
        onTap: () {
          blendMode.value = BlendMode.hue;
        },
      ),
      DropdownMenuItem(
        child: Text("lighten"),
        value: "lighten",
        onTap: () {
          blendMode.value = BlendMode.lighten;
        },
      ),
      DropdownMenuItem(
        child: Text("luminosity"),
        value: "luminosity",
        onTap: () {
          blendMode.value = BlendMode.luminosity;
        },
      ),
      DropdownMenuItem(
        child: Text("modulate"),
        value: "modulate",
        onTap: () {
          blendMode.value = BlendMode.modulate;
        },
      ),
      DropdownMenuItem(
        child: Text("multiply"),
        value: "multiply",
        onTap: () {
          blendMode.value = BlendMode.multiply;
        },
      ),
      DropdownMenuItem(
        child: Text("overlay"),
        value: "overlay",
        onTap: () {
          blendMode.value = BlendMode.overlay;
        },
      ),
      DropdownMenuItem(
        child: Text("plus"),
        value: "plus",
        onTap: () {
          blendMode.value = BlendMode.plus;
        },
      ),
      DropdownMenuItem(
        child: Text("saturation"),
        value: "saturation",
        onTap: () {
          blendMode.value = BlendMode.saturation;

          print("saturation selected");
        },
      ),
      DropdownMenuItem(
        child: Text("screen"),
        value: "screen",
        onTap: () {
          blendMode.value = BlendMode.screen;
        },
      ),
      DropdownMenuItem(
        child: Text("softLight"),
        value: "softLight",
        onTap: () {
          blendMode.value = BlendMode.softLight;
        },
      ),
      DropdownMenuItem(
        child: Text("src"),
        value: "src",
        onTap: () {
          blendMode.value = BlendMode.src;
        },
      ),
      DropdownMenuItem(
        child: Text("srcATop"),
        value: "srcATop",
        onTap: () {
          blendMode.value = BlendMode.srcATop;
        },
      ),
      DropdownMenuItem(
        child: Text("srcIn"),
        value: "srcIn",
        onTap: () {
          blendMode.value = BlendMode.srcIn;
        },
      ),
      DropdownMenuItem(
        child: Text("srcOut"),
        value: "srcOut",
        onTap: () {
          blendMode.value = BlendMode.srcOut;
        },
      ),
      DropdownMenuItem(
        child: Text("srcOver"),
        value: "srcOver",
        onTap: () {
          blendMode.value = BlendMode.srcOver;
        },
      ),
      DropdownMenuItem(
        child: Text("xor"),
        value: "xor",
        onTap: () {
          blendMode.value = BlendMode.xor;
        },
      ),
    ];
    return menuItems;
  }
}

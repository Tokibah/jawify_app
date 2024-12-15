import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/features/shop/data/shop_service.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<BannerAd> _banner = [];
  bool hasLoad = false;
  List<Shop> shopList = [];

  void createBannerAd(int count) {
    _banner.clear();
    for (int i = 0; i < count; i++) {
      BannerAd tempbanner = BannerAd(
          size: AdSize.banner,
          adUnitId: "ca-app-pub-3940256099942544/6300978111",
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              hasLoad = true;
              if (mounted) {
                setState(() {});
              }
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
          request: const AdRequest());
      tempbanner.load();
      _banner.add(tempbanner);
    }
  }

  void getItem() async {
    shopList = await Shop.getShop();
    createBannerAd(shopList.length ~/ 2);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getItem();
  }

  @override
  void dispose() {
    for (var ads in _banner) {
      ads.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor =
        Provider.of<ThemeProvider>(context).themeData.colorScheme.secondary;

    return shopList.isNotEmpty
        ? Scaffold(
            body: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 75),
                Image.asset(
                  "assets/images/shop.png",
                  height: 180,
                ),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                ),
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 250),
                      itemCount: shopList.length + (shopList.length ~/ 2),
                      itemBuilder: (context, index) {
                        if ((index + 1) % 3 == 0) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Center(
                              child: (hasLoad
                                  ? AdWidget(ad: _banner[index ~/ 3])
                                  : const CircularProgressIndicator()),
                            ),
                          );
                        } else {
                          int shopIndex = index - (index ~/ 3);
                          Shop shop = shopList[shopIndex];
                          return SizedBox(
                            height: 200,
                            child: Column(children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                      mainColor,
                                      mainColor.withGreen(100)
                                    ])),
                                child: Center(
                                    child: Text(
                                  shop.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                )),
                              ),
                              Row(children: [
                                Expanded(
                                  child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Image.network(shop.image,
                                          fit: BoxFit.cover, loadingBuilder:
                                              (context, child,
                                                  loadingProgress) {
                                        return loadingProgress == null
                                            ? child
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                      })),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                          shop.detail,
                                          textAlign: TextAlign.center,
                                        )),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "RM${shop.price}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ]),
                                )
                              ])
                            ]),
                          );
                        }
                      }),
                )
              ]),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

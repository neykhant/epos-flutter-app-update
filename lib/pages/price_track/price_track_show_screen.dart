import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/progress_hud.dart';
import '../../datetime_util.dart';
import '../../models/price_track_model.dart';
import '../../providers/price_track_provider.dart';
import '../../utility_methods.dart';

class PriceTrackShowScreen extends StatefulWidget {
  const PriceTrackShowScreen({Key? key}) : super(key: key);

  @override
  _PriceTrackShowScreenState createState() => _PriceTrackShowScreenState();
}

class _PriceTrackShowScreenState extends State<PriceTrackShowScreen> {
  bool _isLoading = false;
  PriceTrackModel? priceTrackObject;
  List<PriceTrackModel> _priceTrackList = [];
  List<String> itemNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final PriceTrackProvider priceTrackProvider =
        Provider.of<PriceTrackProvider>(context, listen: false);
    await priceTrackProvider.loadPriceTracks();

    _priceTrackList = priceTrackProvider.priceTracks;

    itemNames.clear();
    for (var i = 0; i < _priceTrackList.length; i++) {
      itemNames.add(_priceTrackList[i].itemModel.itemName);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<PriceTrackModel> _usedPriceTrackList = priceTrackObject == null
        ? _priceTrackList
        : _priceTrackList
            .where((e) =>
                e.itemModel.itemName == priceTrackObject!.itemModel.itemName)
            .toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.price_track,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      drawer: const MyDrawer(),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ProgressHUD(
          inAsyncCall: _isLoading,
          child: Padding(
            padding: kPadding,
            child: Column(
              children: [
                DropdownSearch<String>(
                  // ignore: deprecated_member_use
                  hint: localizations.select_item,
                  mode: Mode.MENU,
                  items: itemNames.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _priceTrackList.length; i++) {
                        if (_priceTrackList[i].itemModel.itemName == data) {
                          setState(() {
                            priceTrackObject = _priceTrackList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        priceTrackObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedPriceTrackList.length,
                    itemBuilder: (context, index) {
                      PriceTrackModel priceTrack = _usedPriceTrackList[index];

                      return Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, //8
                            vertical: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                convertDateToLocal(priceTrack.createdAt),
                                style: kTextStyle(size: 16.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.item_name,
                                    style: kTextStyle(size: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    '=',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    priceTrack.itemModel.itemName,
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.sale_price,
                                    style: kTextStyle(size: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    '=',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    '${priceTrack.salePrice} Ks',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.buy_price,
                                    style: kTextStyle(size: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    '=',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    '${priceTrack.buyPrice} Ks',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

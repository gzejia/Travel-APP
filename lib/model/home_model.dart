import 'package:go_together/model/sales_box_model.dart';

import 'common_model.dart';
import 'config_model.dart';
import 'grid_nav_model.dart';

class HomeModel {
  ConfigModel config;
  GridNavModel gridNav;
  SalesBoxModel salesBox;
  List<CommonModel> bannerList;
  List<CommonModel> localNavList;
  List<CommonModel> subNavList;

  HomeModel(
      {this.config,
      this.gridNav,
      this.bannerList,
      this.localNavList,
      this.subNavList,
      this.salesBox});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList =
        bannerListJson.map((i) => CommonModel.fromJson(i)).toList();

    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList =
        localNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList =
        subNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    return HomeModel(
        config: ConfigModel.fromJson(json['config']),
        gridNav: GridNavModel.fromJson(json['gridNav']),
        salesBox: SalesBoxModel.fromJson(json['salesBox']),
        bannerList: bannerList,
        localNavList: localNavList,
        subNavList: subNavList);
  }
}

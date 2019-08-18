import 'common_model.dart';

/// 首页卡片数据分组
class GridNavModel {
  GridNavChildModel hotel;
  GridNavChildModel flight;
  GridNavChildModel travel;

  GridNavModel({this.hotel, this.flight, this.travel});

  factory GridNavModel.fromJson(Map<String, dynamic> json) {
    return GridNavModel(
      hotel: GridNavChildModel.fromJson(json['hotel']),
      flight: GridNavChildModel.fromJson(json['flight']),
      travel: GridNavChildModel.fromJson(json['travel']),
    );
  }
}

/// 首页卡片书内容
class GridNavChildModel {
  String startColor;
  String endColor;
  CommonModel mainItem;
  CommonModel item1;
  CommonModel item2;
  CommonModel item3;
  CommonModel item4;

  GridNavChildModel(
      {this.startColor,
      this.endColor,
      this.mainItem,
      this.item1,
      this.item2,
      this.item3,
      this.item4});

  factory GridNavChildModel.fromJson(Map<String, dynamic> json) {
    return GridNavChildModel(
      startColor: json['startColor'],
      endColor: json['endColor'],
      mainItem: CommonModel.fromJson(json['mainItem']),
      item1: CommonModel.fromJson(json['item1']),
      item2: CommonModel.fromJson(json['item2']),
      item3: CommonModel.fromJson(json['item3']),
      item4: CommonModel.fromJson(json['item4']),
    );
  }
}

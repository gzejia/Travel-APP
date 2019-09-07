/// 搜索结果对象
class SearchModel {
  String keyword;
  Head head;
  List<ItemModel> data;

  SearchModel({this.head, this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    if (json['data'] != null) {
      data = new List<ItemModel>();
      json['data'].forEach((v) {
        data.add(new ItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Head {
  Null auth;
  int errcode;

  Head({this.auth, this.errcode});

  Head.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    errcode = json['errcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth;
    data['errcode'] = this.errcode;
    return data;
  }
}

class ItemModel {
  String word;
  String type;
  String price;
  String star;
  String zonename;
  String districtname;
  String url;

  ItemModel(
      {this.word,
      this.type,
      this.price,
      this.star,
      this.zonename,
      this.districtname,
      this.url});

  ItemModel.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    type = json['type'];
    price = json['price'];
    star = json['star'];
    zonename = json['zonename'];
    districtname = json['districtname'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['type'] = this.type;
    data['price'] = this.price;
    data['star'] = this.star;
    data['zonename'] = this.zonename;
    data['districtname'] = this.districtname;
    data['url'] = this.url;
    return data;
  }
}

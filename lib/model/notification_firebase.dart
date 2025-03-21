class NotificationFirebase {
  Notification? notification;
  String? priority;
  Data? data;

  NotificationFirebase({this.notification, this.priority, this.data});

  NotificationFirebase.fromJson(Map<String, dynamic> json) {
    // notification = json['notification'] != null
    //     ? new Notification.fromJson(json['notification'])
    //     : null;
    // priority = json['priority'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    data['priority'] = this.priority;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Notification {
  String? title;
  Null body;

  Notification({this.title, this.body});

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

class Data {
  String? title;
  String? content;
  int? id;
  int? type;
  String? clickAction;

  Data({this.title, this.content, this.id, this.type, this.clickAction});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    id = json['id'];
    type = json['type'];
    clickAction = json['click_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['id'] = this.id;
    data['type'] = this.type;
    data['click_action'] = this.clickAction;
    return data;
  }
}

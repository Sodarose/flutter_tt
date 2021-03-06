//
// dao.dart
// Copyright (C) 2019 xiaominfc(武汉鸣鸾信息科技有限公司) <xiaominfc@gmail.com>
//
// Distributed under terms of the MIT license.
//
import 'package:sqflite/sqlite_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './database_helper.dart';

class UserEntry extends BaseItem {

  String name;
  String avatar;
  int id;
  String email;
  String phone;
  String signInfo;
  UserEntry({this.id,this.name,this.avatar,this.signInfo,this.email, this.phone});

  @override
  Map<String, dynamic> toMap() {
    return {'id':id, 'name':name, 'avatar':avatar, 'signInfo':signInfo,'email':email, 'phone':phone};
  }
  @override
  fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['name'];
    this.avatar = map['avatar'];
    this.signInfo = map['signInfo'];
    this.email = map['email'];
    this.phone = map['phone'];
    return this;
  }


  @override
  String toString() {
    return toMap().toString();
  }
  
}

class UserDao extends PrimaryDao<UserEntry> {

  @override
  String tableName() {
    return 'im_user';
  }

  @override
  buildItem(Map<String, dynamic> map) {
    return UserEntry().fromMap(map);
  }

  @override
  initTable(Database db, int version) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('users_lastUpdateTime', 0);
    return super.initTable(db,version);
  }

  @override
  tableStruct(){
    return '(id INTEGER PRIMARY KEY, name TEXT, avatar TEXT, signInfo TEXT, email TEXT, phone TEXT)';
  }
}


class GroupEntry extends BaseItem {

  int id;
  String name;
  String avatar;
  int version;
  int shieldStatus;

  GroupEntry({this.id,this.name,this.avatar,this.version,this.shieldStatus});

  @override
  Map<String, dynamic> toMap() {
    return {'id':id,'name':name, 'avatar':avatar, 'version':version, 'shieldStatus':shieldStatus};
  }

  @override
  fromMap(Map<String, dynamic> map) {
    id=map['id'];
    name = map['name'];
    avatar = map['avatar'];
    version = map['version'];
    shieldStatus = map['shieldStatus'];
    return this;
  }
}

class GroupDao extends PrimaryDao<GroupEntry> {

  @override
  BaseItem buildItem(Map<String, dynamic> map) {
    return GroupEntry().fromMap(map);
  }

  
  @override
  String tableName() {
    return "im_group";
  }

  @override
  tableStruct(){
    return '(id INTEGER PRIMARY KEY, name TEXT, avatar TEXT, version INTEGER, shieldStatus INTEGER)';
  }
}


class IMMsgType {
  static const int MSG_TYPE_SINGLE_TEXT = 1;
  static const int MSG_TYPE_SINGLE_AUDIO = 2;
  static const int MSG_TYPE_GROUP_TEXT = 17;
  static const int MSG_TYPE_GROUP_AUDIO = 18;
}



class IMMsgSendStatus {
  static const int Sending = 1;
  static const int Ok = 2;
  static const int Failed = 0;
}

class MessageEntry extends BaseItem {
  int fromId;
  int sessionId;
  int msgId;
  String msgText;
  int time;
  List msgData;
  int msgType;

  int sendStatus = IMMsgSendStatus.Ok;

  MessageEntry({this.msgId,this.fromId,this.msgData,this.sessionId,this.time,this.msgType});

  @override
  fromMap(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'fromId':fromId, 'msgId':msgId, 'msgText':msgText, 'time':time,'sessionId':sessionId,'msgType':msgType};
  }
}

class AudioMessageEntry extends MessageEntry {
  String audioPath;
  
  AudioMessageEntry({int msgId,int fromId,List msgData,int sessionId,int time,int msgType}):super(msgId:msgId,fromId:fromId,msgData:msgData,sessionId:sessionId,time:time,msgType:msgType) {
    
  }
  Map<String, dynamic> toMap() { 
    Map result = super.toMap();
    result['audioPath'] = audioPath;
    return result;
  }
}

class IMSeesionType {
  static const int Person=1;
  static const int Group=2;
}

class SessionEntry extends BaseItem {

  String sessionKey;
  int sessionId;
  String lastMsg;
  int sessionType;
  int updatedTime;
  int unreadCnt;

  SessionEntry([int _sessionId,int _sessionType]){
    this.sessionId = _sessionId;
    this.sessionType = _sessionType;
    this.sessionKey = _sessionId.toString() + "_" + _sessionType.toString();
    this.unreadCnt = 0;
  }

  @override
  Map<String, dynamic> toMap() {    
    return {'sessionKey':sessionKey,'sessionId':sessionId,  'lastMsg':lastMsg, 'sessionType':sessionType,'updatedTime': updatedTime};
  }

  @override
  fromMap(Map<String, dynamic> map) {
    sessionKey = map['sessionKey'];
    sessionId = map['sessionId'];
    lastMsg = map['lastMsg'];
    sessionType = map['sessionType'];
    updatedTime = map['updatedTime'];
    this.unreadCnt = 0;
    return this;
  }
}

class SessionDao extends PrimaryDao<SessionEntry>{
  @override
  BaseItem buildItem(Map<String, dynamic> map) {
    return SessionEntry().fromMap(map);
  }

  @override
  String primarykey() {
    return "sessionKey";
  }

  @override
  String tableName() {
    return "im_session";
  }

  @override
  tableStruct() {
    return '(sessionKey TEXT PRIMARY KEY, sessionId INTEGER, sessionType INTEGER, lastMsg TEXT, updatedTime INTEGER)';
  }

}


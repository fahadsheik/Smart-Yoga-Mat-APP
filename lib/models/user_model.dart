class User {
  final String id;
  final String? name;
  final String? email;
  final String mobileNumber;
  final bool isRegistered;
  final String? token;

  User({
    required this.id,
    this.name,
    this.email,
    required this.mobileNumber,
    this.isRegistered = false,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['userId'] ?? '',
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobile'] ?? json['mobileNumber'] ?? '',
      isRegistered: json['isRegistered'] ?? false,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'isRegistered': isRegistered,
      'token': token,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? mobileNumber,
    bool? isRegistered,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isRegistered: isRegistered ?? this.isRegistered,
      token: token ?? this.token,
    );
  }
}

class DeviceInfo {
  final String deviceType;
  final String deviceId;
  final String deviceName;
  final String deviceOSVersion;
  final String deviceIPAddress;
  final double lat;
  final double long;
  final String buyerGcmId;
  final String buyerPemId;
  final AppInfo app;

  DeviceInfo({
    required this.deviceType,
    required this.deviceId,
    required this.deviceName,
    required this.deviceOSVersion,
    required this.deviceIPAddress,
    required this.lat,
    required this.long,
    this.buyerGcmId = '',
    this.buyerPemId = '',
    required this.app,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceType: json['deviceType'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      deviceOSVersion: json['deviceOSVersion'],
      deviceIPAddress: json['deviceIPAddress'],
      lat: json['lat'],
      long: json['long'],
      buyerGcmId: json['buyer_gcmid'] ?? '',
      buyerPemId: json['buyer_pemid'] ?? '',
      app: AppInfo.fromJson(json['app']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceType': deviceType,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceOSVersion': deviceOSVersion,
      'deviceIPAddress': deviceIPAddress,
      'lat': lat,
      'long': long,
      'buyer_gcmid': buyerGcmId,
      'buyer_pemid': buyerPemId,
      'app': app.toJson(),
    };
  }
}

class AppInfo {
  final String version;
  final String installTimeStamp;
  final String uninstallTimeStamp;
  final String downloadTimeStamp;

  AppInfo({
    required this.version,
    required this.installTimeStamp,
    required this.uninstallTimeStamp,
    required this.downloadTimeStamp,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      version: json['version'],
      installTimeStamp: json['installTimeStamp'],
      uninstallTimeStamp: json['uninstallTimeStamp'],
      downloadTimeStamp: json['downloadTimeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'installTimeStamp': installTimeStamp,
      'uninstallTimeStamp': uninstallTimeStamp,
      'downloadTimeStamp': downloadTimeStamp,
    };
  }
}
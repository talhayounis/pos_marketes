class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? color;

  UserModel({this.uid,this.color, this.email, this.firstName, this.secondName});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      color: map['color'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'color': color,
    };
  }
}


class ClientModel {
  String? uid;
  String? clientName;
  String? phoneNumber;
  String? companyName;
  String? clientRole;
  String? message;
  String? address;
  String? formFilledBy;
  String? currentLocation;
  String? uploadTime;

  ClientModel({this.uid,this.uploadTime,this.phoneNumber,this.formFilledBy ,this.clientRole, this.clientName, this.companyName, this.address, this.message, this.currentLocation});

  // receiving data from server
  factory ClientModel.fromMap(map) {
    return ClientModel(
      uid: map['uid'],
      clientName: map['clientName'],
      phoneNumber: map['phoneNumber'],
      companyName: map['companyName'],
      formFilledBy: map['formFilledBy'],
      clientRole: map['clientRole'],
      message: map['message'],
      address: map['address'],
      currentLocation: map['currentLocation'],
      uploadTime: map['uploadTime'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'clientName': clientName,
      'phoneNumber': phoneNumber,
      'companyName': companyName,
      'clientRole': clientRole,
      'formFilledBy': formFilledBy,
      'message': message,
      'address': address,
      'currentLocation': currentLocation,
      'uploadTime': uploadTime,
    };
  }
}
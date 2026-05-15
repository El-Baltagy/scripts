// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => DataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$DataItemImpl _$$DataItemImplFromJson(Map<String, dynamic> json) =>
    _$DataItemImpl(
      user_id: (json['user_id'] as num).toInt(),
      user_firstname: json['user_firstname'] as String,
      user_lastname: json['user_lastname'] as String,
      user_name: json['user_name'] as String,
      email: json['email'] as String,
      user_avatar: json['user_avatar'] as String,
      user_status: json['user_status'],
      room_id: (json['room_id'] as num).toInt(),
    );

Map<String, dynamic> _$$DataItemImplToJson(_$DataItemImpl instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'user_firstname': instance.user_firstname,
      'user_lastname': instance.user_lastname,
      'user_name': instance.user_name,
      'email': instance.email,
      'user_avatar': instance.user_avatar,
      'user_status': instance.user_status,
      'room_id': instance.room_id,
    };

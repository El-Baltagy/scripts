// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  List<DataItem> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({List<DataItem> data});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<DataItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DataItem> data});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$UserImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<DataItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl({required final List<DataItem> data})
      : _data = data,
        super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  final List<DataItem> _data;
  @override
  List<DataItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User extends User {
  const factory _User({required final List<DataItem> data}) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  List<DataItem> get data;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DataItem _$DataItemFromJson(Map<String, dynamic> json) {
  return _DataItem.fromJson(json);
}

/// @nodoc
mixin _$DataItem {
  int get user_id => throw _privateConstructorUsedError;
  String get user_firstname => throw _privateConstructorUsedError;
  String get user_lastname => throw _privateConstructorUsedError;
  String get user_name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get user_avatar => throw _privateConstructorUsedError;
  dynamic get user_status => throw _privateConstructorUsedError;
  int get room_id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DataItemCopyWith<DataItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataItemCopyWith<$Res> {
  factory $DataItemCopyWith(DataItem value, $Res Function(DataItem) then) =
      _$DataItemCopyWithImpl<$Res, DataItem>;
  @useResult
  $Res call(
      {int user_id,
      String user_firstname,
      String user_lastname,
      String user_name,
      String email,
      String user_avatar,
      dynamic user_status,
      int room_id});
}

/// @nodoc
class _$DataItemCopyWithImpl<$Res, $Val extends DataItem>
    implements $DataItemCopyWith<$Res> {
  _$DataItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_id = null,
    Object? user_firstname = null,
    Object? user_lastname = null,
    Object? user_name = null,
    Object? email = null,
    Object? user_avatar = null,
    Object? user_status = freezed,
    Object? room_id = null,
  }) {
    return _then(_value.copyWith(
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as int,
      user_firstname: null == user_firstname
          ? _value.user_firstname
          : user_firstname // ignore: cast_nullable_to_non_nullable
              as String,
      user_lastname: null == user_lastname
          ? _value.user_lastname
          : user_lastname // ignore: cast_nullable_to_non_nullable
              as String,
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      user_avatar: null == user_avatar
          ? _value.user_avatar
          : user_avatar // ignore: cast_nullable_to_non_nullable
              as String,
      user_status: freezed == user_status
          ? _value.user_status
          : user_status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      room_id: null == room_id
          ? _value.room_id
          : room_id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataItemImplCopyWith<$Res>
    implements $DataItemCopyWith<$Res> {
  factory _$$DataItemImplCopyWith(
          _$DataItemImpl value, $Res Function(_$DataItemImpl) then) =
      __$$DataItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int user_id,
      String user_firstname,
      String user_lastname,
      String user_name,
      String email,
      String user_avatar,
      dynamic user_status,
      int room_id});
}

/// @nodoc
class __$$DataItemImplCopyWithImpl<$Res>
    extends _$DataItemCopyWithImpl<$Res, _$DataItemImpl>
    implements _$$DataItemImplCopyWith<$Res> {
  __$$DataItemImplCopyWithImpl(
      _$DataItemImpl _value, $Res Function(_$DataItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_id = null,
    Object? user_firstname = null,
    Object? user_lastname = null,
    Object? user_name = null,
    Object? email = null,
    Object? user_avatar = null,
    Object? user_status = freezed,
    Object? room_id = null,
  }) {
    return _then(_$DataItemImpl(
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as int,
      user_firstname: null == user_firstname
          ? _value.user_firstname
          : user_firstname // ignore: cast_nullable_to_non_nullable
              as String,
      user_lastname: null == user_lastname
          ? _value.user_lastname
          : user_lastname // ignore: cast_nullable_to_non_nullable
              as String,
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      user_avatar: null == user_avatar
          ? _value.user_avatar
          : user_avatar // ignore: cast_nullable_to_non_nullable
              as String,
      user_status: freezed == user_status
          ? _value.user_status
          : user_status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      room_id: null == room_id
          ? _value.room_id
          : room_id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataItemImpl extends _DataItem {
  const _$DataItemImpl(
      {required this.user_id,
      required this.user_firstname,
      required this.user_lastname,
      required this.user_name,
      required this.email,
      required this.user_avatar,
      required this.user_status,
      required this.room_id})
      : super._();

  factory _$DataItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataItemImplFromJson(json);

  @override
  final int user_id;
  @override
  final String user_firstname;
  @override
  final String user_lastname;
  @override
  final String user_name;
  @override
  final String email;
  @override
  final String user_avatar;
  @override
  final dynamic user_status;
  @override
  final int room_id;

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataItemImplCopyWith<_$DataItemImpl> get copyWith =>
      __$$DataItemImplCopyWithImpl<_$DataItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DataItemImplToJson(
      this,
    );
  }
}

abstract class _DataItem extends DataItem {
  const factory _DataItem(
      {required final int user_id,
      required final String user_firstname,
      required final String user_lastname,
      required final String user_name,
      required final String email,
      required final String user_avatar,
      required final dynamic user_status,
      required final int room_id}) = _$DataItemImpl;
  const _DataItem._() : super._();

  factory _DataItem.fromJson(Map<String, dynamic> json) =
      _$DataItemImpl.fromJson;

  @override
  int get user_id;
  @override
  String get user_firstname;
  @override
  String get user_lastname;
  @override
  String get user_name;
  @override
  String get email;
  @override
  String get user_avatar;
  @override
  dynamic get user_status;
  @override
  int get room_id;
  @override
  @JsonKey(ignore: true)
  _$$DataItemImplCopyWith<_$DataItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_device_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiscoveredDeviceModelCollection on Isar {
  IsarCollection<DiscoveredDeviceModel> get discoveredDeviceModels =>
      this.collection();
}

const DiscoveredDeviceModelSchema = CollectionSchema(
  name: r'DiscoveredDeviceModel',
  id: -713292905262290897,
  properties: {
    r'deviceId': PropertySchema(
      id: 0,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'hasMessagedBefore': PropertySchema(
      id: 1,
      name: r'hasMessagedBefore',
      type: IsarType.bool,
    ),
    r'lastDiscovered': PropertySchema(
      id: 2,
      name: r'lastDiscovered',
      type: IsarType.dateTime,
    ),
    r'latitude': PropertySchema(
      id: 3,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 4,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'profilePicturePath': PropertySchema(
      id: 5,
      name: r'profilePicturePath',
      type: IsarType.string,
    ),
    r'username': PropertySchema(
      id: 6,
      name: r'username',
      type: IsarType.string,
    )
  },
  estimateSize: _discoveredDeviceModelEstimateSize,
  serialize: _discoveredDeviceModelSerialize,
  deserialize: _discoveredDeviceModelDeserialize,
  deserializeProp: _discoveredDeviceModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'deviceId': IndexSchema(
      id: 4442814072367132509,
      name: r'deviceId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'deviceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _discoveredDeviceModelGetId,
  getLinks: _discoveredDeviceModelGetLinks,
  attach: _discoveredDeviceModelAttach,
  version: '3.1.0+1',
);

int _discoveredDeviceModelEstimateSize(
  DiscoveredDeviceModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deviceId.length * 3;
  {
    final value = object.profilePicturePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.username;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _discoveredDeviceModelSerialize(
  DiscoveredDeviceModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.deviceId);
  writer.writeBool(offsets[1], object.hasMessagedBefore);
  writer.writeDateTime(offsets[2], object.lastDiscovered);
  writer.writeDouble(offsets[3], object.latitude);
  writer.writeDouble(offsets[4], object.longitude);
  writer.writeString(offsets[5], object.profilePicturePath);
  writer.writeString(offsets[6], object.username);
}

DiscoveredDeviceModel _discoveredDeviceModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiscoveredDeviceModel();
  object.deviceId = reader.readString(offsets[0]);
  object.hasMessagedBefore = reader.readBool(offsets[1]);
  object.id = id;
  object.lastDiscovered = reader.readDateTimeOrNull(offsets[2]);
  object.latitude = reader.readDoubleOrNull(offsets[3]);
  object.longitude = reader.readDoubleOrNull(offsets[4]);
  object.profilePicturePath = reader.readStringOrNull(offsets[5]);
  object.username = reader.readStringOrNull(offsets[6]);
  return object;
}

P _discoveredDeviceModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _discoveredDeviceModelGetId(DiscoveredDeviceModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _discoveredDeviceModelGetLinks(
    DiscoveredDeviceModel object) {
  return [];
}

void _discoveredDeviceModelAttach(
    IsarCollection<dynamic> col, Id id, DiscoveredDeviceModel object) {
  object.id = id;
}

extension DiscoveredDeviceModelByIndex
    on IsarCollection<DiscoveredDeviceModel> {
  Future<DiscoveredDeviceModel?> getByDeviceId(String deviceId) {
    return getByIndex(r'deviceId', [deviceId]);
  }

  DiscoveredDeviceModel? getByDeviceIdSync(String deviceId) {
    return getByIndexSync(r'deviceId', [deviceId]);
  }

  Future<bool> deleteByDeviceId(String deviceId) {
    return deleteByIndex(r'deviceId', [deviceId]);
  }

  bool deleteByDeviceIdSync(String deviceId) {
    return deleteByIndexSync(r'deviceId', [deviceId]);
  }

  Future<List<DiscoveredDeviceModel?>> getAllByDeviceId(
      List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'deviceId', values);
  }

  List<DiscoveredDeviceModel?> getAllByDeviceIdSync(
      List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'deviceId', values);
  }

  Future<int> deleteAllByDeviceId(List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'deviceId', values);
  }

  int deleteAllByDeviceIdSync(List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'deviceId', values);
  }

  Future<Id> putByDeviceId(DiscoveredDeviceModel object) {
    return putByIndex(r'deviceId', object);
  }

  Id putByDeviceIdSync(DiscoveredDeviceModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'deviceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDeviceId(List<DiscoveredDeviceModel> objects) {
    return putAllByIndex(r'deviceId', objects);
  }

  List<Id> putAllByDeviceIdSync(List<DiscoveredDeviceModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'deviceId', objects, saveLinks: saveLinks);
  }
}

extension DiscoveredDeviceModelQueryWhereSort
    on QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QWhere> {
  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiscoveredDeviceModelQueryWhere on QueryBuilder<DiscoveredDeviceModel,
    DiscoveredDeviceModel, QWhereClause> {
  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhereClause>
      deviceIdEqualTo(String deviceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deviceId',
        value: [deviceId],
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterWhereClause>
      deviceIdNotEqualTo(String deviceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceId',
              lower: [],
              upper: [deviceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceId',
              lower: [deviceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceId',
              lower: [deviceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceId',
              lower: [],
              upper: [deviceId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DiscoveredDeviceModelQueryFilter on QueryBuilder<
    DiscoveredDeviceModel, DiscoveredDeviceModel, QFilterCondition> {
  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
          QAfterFilterCondition>
      deviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
          QAfterFilterCondition>
      deviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> hasMessagedBeforeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasMessagedBefore',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> lastDiscoveredIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDiscovered',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> lastDiscoveredIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDiscovered',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> lastDiscoveredEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDiscovered',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> lastDiscoveredGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDiscovered',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> lastDiscoveredLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDiscovered',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> lastDiscoveredBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDiscovered',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> latitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> longitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profilePicturePath',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profilePicturePath',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicturePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profilePicturePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profilePicturePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profilePicturePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profilePicturePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profilePicturePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
          QAfterFilterCondition>
      profilePicturePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profilePicturePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
          QAfterFilterCondition>
      profilePicturePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profilePicturePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicturePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> profilePicturePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePicturePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
          QAfterFilterCondition>
      usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
          QAfterFilterCondition>
      usernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel,
      QAfterFilterCondition> usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }
}

extension DiscoveredDeviceModelQueryObject on QueryBuilder<
    DiscoveredDeviceModel, DiscoveredDeviceModel, QFilterCondition> {}

extension DiscoveredDeviceModelQueryLinks on QueryBuilder<DiscoveredDeviceModel,
    DiscoveredDeviceModel, QFilterCondition> {}

extension DiscoveredDeviceModelQuerySortBy
    on QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QSortBy> {
  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByHasMessagedBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessagedBefore', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByHasMessagedBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessagedBefore', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByLastDiscovered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDiscovered', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByLastDiscoveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDiscovered', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByProfilePicturePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicturePath', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByProfilePicturePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicturePath', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension DiscoveredDeviceModelQuerySortThenBy
    on QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QSortThenBy> {
  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByHasMessagedBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessagedBefore', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByHasMessagedBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessagedBefore', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByLastDiscovered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDiscovered', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByLastDiscoveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDiscovered', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByProfilePicturePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicturePath', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByProfilePicturePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicturePath', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QAfterSortBy>
      thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension DiscoveredDeviceModelQueryWhereDistinct
    on QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct> {
  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct>
      distinctByDeviceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct>
      distinctByHasMessagedBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasMessagedBefore');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct>
      distinctByLastDiscovered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDiscovered');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct>
      distinctByProfilePicturePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePicturePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DiscoveredDeviceModel, QDistinct>
      distinctByUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension DiscoveredDeviceModelQueryProperty on QueryBuilder<
    DiscoveredDeviceModel, DiscoveredDeviceModel, QQueryProperty> {
  QueryBuilder<DiscoveredDeviceModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, String, QQueryOperations>
      deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, bool, QQueryOperations>
      hasMessagedBeforeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasMessagedBefore');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, DateTime?, QQueryOperations>
      lastDiscoveredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDiscovered');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, double?, QQueryOperations>
      latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, double?, QQueryOperations>
      longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, String?, QQueryOperations>
      profilePicturePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePicturePath');
    });
  }

  QueryBuilder<DiscoveredDeviceModel, String?, QQueryOperations>
      usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}

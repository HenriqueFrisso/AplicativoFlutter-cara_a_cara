// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pessoa.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPessoaCollection on Isar {
  IsarCollection<Pessoa> get pessoas => this.collection();
}

const PessoaSchema = CollectionSchema(
  name: r'Pessoa',
  id: 2660833406925659182,
  properties: {
    r'fotoBase64': PropertySchema(
      id: 0,
      name: r'fotoBase64',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
  },

  estimateSize: _pessoaEstimateSize,
  serialize: _pessoaSerialize,
  deserialize: _pessoaDeserialize,
  deserializeProp: _pessoaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'baralhos': LinkSchema(
      id: 4856331971111094501,
      name: r'baralhos',
      target: r'Baralho',
      single: false,
    ),
  },
  embeddedSchemas: {},

  getId: _pessoaGetId,
  getLinks: _pessoaGetLinks,
  attach: _pessoaAttach,
  version: '3.3.0',
);

int _pessoaEstimateSize(
  Pessoa object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.fotoBase64;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _pessoaSerialize(
  Pessoa object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fotoBase64);
  writer.writeString(offsets[1], object.name);
}

Pessoa _pessoaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Pessoa(
    fotoBase64: reader.readStringOrNull(offsets[0]),
    name: reader.readString(offsets[1]),
  );
  object.id = id;
  return object;
}

P _pessoaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pessoaGetId(Pessoa object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pessoaGetLinks(Pessoa object) {
  return [object.baralhos];
}

void _pessoaAttach(IsarCollection<dynamic> col, Id id, Pessoa object) {
  object.id = id;
  object.baralhos.attach(col, col.isar.collection<Baralho>(), r'baralhos', id);
}

extension PessoaQueryWhereSort on QueryBuilder<Pessoa, Pessoa, QWhere> {
  QueryBuilder<Pessoa, Pessoa, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PessoaQueryWhere on QueryBuilder<Pessoa, Pessoa, QWhereClause> {
  QueryBuilder<Pessoa, Pessoa, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Pessoa, Pessoa, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PessoaQueryFilter on QueryBuilder<Pessoa, Pessoa, QFilterCondition> {
  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fotoBase64'),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fotoBase64'),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64EqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fotoBase64',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64GreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fotoBase64',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64LessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fotoBase64',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64Between(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fotoBase64',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fotoBase64',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fotoBase64',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64Contains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fotoBase64',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64Matches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fotoBase64',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fotoBase64', value: ''),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> fotoBase64IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fotoBase64', value: ''),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension PessoaQueryObject on QueryBuilder<Pessoa, Pessoa, QFilterCondition> {}

extension PessoaQueryLinks on QueryBuilder<Pessoa, Pessoa, QFilterCondition> {
  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> baralhos(
    FilterQuery<Baralho> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'baralhos');
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> baralhosLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'baralhos', length, true, length, true);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> baralhosIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'baralhos', 0, true, 0, true);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> baralhosIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'baralhos', 0, false, 999999, true);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> baralhosLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'baralhos', 0, true, length, include);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> baralhosLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'baralhos', length, include, 999999, true);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterFilterCondition> baralhosLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'baralhos',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PessoaQuerySortBy on QueryBuilder<Pessoa, Pessoa, QSortBy> {
  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> sortByFotoBase64() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoBase64', Sort.asc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> sortByFotoBase64Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoBase64', Sort.desc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PessoaQuerySortThenBy on QueryBuilder<Pessoa, Pessoa, QSortThenBy> {
  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> thenByFotoBase64() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoBase64', Sort.asc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> thenByFotoBase64Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoBase64', Sort.desc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PessoaQueryWhereDistinct on QueryBuilder<Pessoa, Pessoa, QDistinct> {
  QueryBuilder<Pessoa, Pessoa, QDistinct> distinctByFotoBase64({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fotoBase64', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pessoa, Pessoa, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension PessoaQueryProperty on QueryBuilder<Pessoa, Pessoa, QQueryProperty> {
  QueryBuilder<Pessoa, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Pessoa, String?, QQueryOperations> fotoBase64Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fotoBase64');
    });
  }

  QueryBuilder<Pessoa, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

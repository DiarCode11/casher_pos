import 'package:equatable/equatable.dart';

class StoreCategoryDto extends Equatable {
  final String name;

  const StoreCategoryDto({required this.name});

  @override
  List<Object?> get props => [name];
}

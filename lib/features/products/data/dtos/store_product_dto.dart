import 'dart:io';

import 'package:equatable/equatable.dart';

class StoreProductDto extends Equatable {
	final String name;
	final String price;
	final File? image;
	final int categoryId;

	const StoreProductDto({
		required this.name,
		required this.price,
		this.image,
		required this.categoryId
		});

	@override
	List<Object?> get props => [name, price, image?.path, categoryId];
}
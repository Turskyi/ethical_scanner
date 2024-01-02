/// This library represents an Application-independent Enterprise Business
/// Rules.
///
/// Application-independent business rules are rules or procedures that make or
/// save the business money. Irrespective of whether they were implemented on a
/// computer, they would make or save money even if they were executed manually.
///
/// An Entity is an object within our computer system in a single and separate
/// module that embodies a small set of critical business rules operating on
/// Critical business data.
library entities;

export 'src/product_info/product_info.dart';
export 'src/enums/product_info_key.dart';
export 'src/errors/api_exception.dart';
export 'src/errors/network_error.dart';
export 'src/errors/failure_details.dart';
export 'src/resource.dart';
export 'src/status.dart';
export 'src/enums/vegan.dart';
export 'src/enums/vegetarian.dart';

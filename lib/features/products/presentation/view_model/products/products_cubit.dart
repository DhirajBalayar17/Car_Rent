import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_new/features/products/data/models/product_request.dart';
import 'package:my_new/features/products/domain/usecases/fetch_products.dart';
import '../../../domain/entities/product.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final FetchProducts fetchProducts;
  ProductsCubit(this.fetchProducts) : super(const ProductsLoading());

  int page = 1;
  Timer? _debounce;
  String _currentSearchQuery = '';
  String _currentSortField = 'date';
  String _currentSortOrder = '-1';

  Future<void> loadProducts([ProductRequest? request]) async {
    emit(const ProductsLoading());
    page = 1;

    ProductRequest productRequest;
    if (request != null) {
      productRequest = request;
    } else {
      productRequest = ProductRequest(
        page: page,
        size: 50,
        search: _currentSearchQuery,
      );

      if (_currentSortField == 'date') {
        productRequest = ProductRequest(
          page: page,
          size: 50,
          date: _currentSortOrder,
          search: _currentSearchQuery,
        );
      } else if (_currentSortField == 'price') {
        productRequest = ProductRequest(
          page: page,
          size: 50,
          price: _currentSortOrder,
          search: _currentSearchQuery,
        );
      }
    }

    final result = await fetchProducts(productRequest);
    result.fold(
      (l) => emit(ProductsError(l.message)),
      (r) => emit(ProductsLoaded(products: r)),
    );
  }

  Future<void> loadMoreProducts([ProductRequest? request]) async {
    if (state is! ProductsLoaded) return;
    page++;

    ProductRequest productRequest;
    if (request != null) {
      productRequest = request;
    } else {
      if (_currentSortField == 'date') {
        productRequest = ProductRequest(
          page: page,
          size: 50,
          date: _currentSortOrder,
          search: _currentSearchQuery,
        );
      } else if (_currentSortField == 'price') {
        productRequest = ProductRequest(
          page: page,
          size: 50,
          price: _currentSortOrder,
          search: _currentSearchQuery,
        );
      } else {
        productRequest = ProductRequest(
          page: page,
          size: 50,
        );
      }
    }

    final result = await fetchProducts(productRequest);
    result.fold(
      (l) => emit(ProductsError(l.message)),
      (r) {
        final currentState = state as ProductsLoaded;
        emit(ProductsLoaded(products: [...currentState.products, ...r]));
      },
    );
  }

  void searchProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (query == _currentSearchQuery) return;
    _currentSearchQuery = query;

    _debounce = Timer(const Duration(milliseconds: 300), () {
      ProductRequest request;
      if (_currentSortField == 'date') {
        request = ProductRequest(
          page: 1,
          size: 50,
          date: _currentSortOrder,
          search: _currentSearchQuery,
        );
      } else if (_currentSortField == 'price') {
        request = ProductRequest(
          page: 1,
          size: 50,
          price: _currentSortOrder,
          search: _currentSearchQuery,
        );
      } else {
        request = ProductRequest(
          page: 1,
          size: 50,
        );
      }

      loadProducts(request);
    });
  }

  void setSortOption(String field, String order) {
    _currentSortField = field;
    _currentSortOrder = order;

    ProductRequest request;
    if (field == 'date') {
      request = ProductRequest(
          page: 1, size: 50, date: order, search: _currentSearchQuery);
    } else if (field == 'price') {
      request = ProductRequest(
          page: 1, size: 50, price: order, search: _currentSearchQuery);
    } else {
      request = ProductRequest(page: 1, size: 50, search: _currentSearchQuery);
    }

    loadProducts(request);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

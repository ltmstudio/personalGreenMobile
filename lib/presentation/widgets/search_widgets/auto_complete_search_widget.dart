//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class ProductSelector extends StatefulWidget {
//   const ProductSelector({super.key, required this.onSelectProduct});
//
//   final ValueChanged onSelectProduct;
//
//   @override
//   State<ProductSelector> createState() => _ProductSelectorState();
// }
//
// class _ProductSelectorState extends State<ProductSelector> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   Timer? _debounce;
//   String? _lastQuery; // to avoid firing the same request repeatedly
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//
//     // make sure suggestions overlay is closed before disposal
//     _focusNode.unfocus();
//     _focusNode.dispose();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged(String value, List<ProductModel> products) {
//     // Cancel previous timer
//     _debounce?.cancel();
//
//     // Start a new timer: backend request only fires after 500ms of inactivity
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       final query = value.trim();
//       if (query.isEmpty) {
//         widget.onSelectProduct(null);
//         _lastQuery = null;
//         return;
//       }
//
//       final lowerQuery = query.toLowerCase();
//
//       // Check exact match
//       final matches = products.where((p) => p.name.toLowerCase() == lowerQuery);
//       final exactMatch = matches.isNotEmpty ? matches.first : null;
//       if (exactMatch != null) {
//         widget.onSelectProduct(exactMatch.id.toString());
//         _lastQuery = null;
//         return;
//       }
//
//       // Check partial match (suggestions only)
//       final partialMatch = products.any(
//             (p) => p.name.toLowerCase().startsWith(lowerQuery),
//       );
//       if (partialMatch) {
//         _lastQuery = null;
//         return; // show suggestions, no backend request
//       }
//
//       // No local match → call backend if query changed
//       if (_lastQuery == query) return;
//       _lastQuery = query;
//
//       locator<ProductsCubit>().getAllProducts(ProductParams(search: query));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductsCubit, ProductsState>(
//       builder: (context, state) {
//         final names = state is ProductsLoaded
//             ? state.data.map((c) => c.name).toList()
//             : <String>[];
//
//         final inputDecoration = InputDecoration(
//           hintText: state is ProductsLoading
//               ? AppStrings.loadingProducts
//               : state is ProductsError
//               ? AppStrings.notLoaded
//               : AppStrings.selectProduct,
//           suffixIcon: const Icon(
//             Icons.keyboard_arrow_down_outlined,
//             color: AppColors.gray,
//             size: 30,
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 14,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(
//               color: AppColors.timeBorder,
//               // highlight color when focused
//               width: 1,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(
//               color: AppColors.timeBorder,
//               // highlight color when focused
//               width: 1,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: AppColors.timeBorder, width: 1),
//           ),
//         );
//
//         return EasyAutocomplete(
//           controller: _controller,
//           focusNode: _focusNode,
//           suggestions: names,
//           debounceDuration: Duration.zero,
//           // we handle debounce manually
//           onChanged: (value) => _onSearchChanged(
//             value,
//             state is ProductsLoaded ? state.data : [],
//           ),
//           validator: (v) {
//             if (v == null ||
//                 !names.map((n) => n.toLowerCase()).contains(v.toLowerCase())) {
//               return AppStrings.selectProduct;
//             }
//             return null;
//           },
//
//           decoration: inputDecoration,
//         );
//       },
//     );
//   }
// }
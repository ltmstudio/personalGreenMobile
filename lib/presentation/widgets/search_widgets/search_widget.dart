import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/presentation/widgets/gray_loading_indicator.dart';

class HomePageSearchWidget extends StatefulWidget {
  final TextEditingController searchCtrl;
  final Function onSearch;
  final Function? onClear;
  final String? hint;
  final bool? filled;

  const HomePageSearchWidget({
    super.key,
    required this.searchCtrl,
    required this.onSearch,
    this.hint,
    this.onClear, this.filled,
  });

  @override
  State<HomePageSearchWidget> createState() => _HomePageSearchWidgetState();
}

class _HomePageSearchWidgetState extends State<HomePageSearchWidget> {
  bool isloading = false;

  Timer? debounce;

  onSearchChange(val) {
    if (debounce?.isActive ?? false) {
      setState(() {});
      debounce?.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 800), fetch);
  }

  fetch() async {
    setState(() {
      isloading = true;
    });
    await widget.onSearch();
    setState(() {
      isloading = false;
    });
  }

  clear() {
    if (widget.onClear != null) {
      widget.onClear!();
    } else {
      widget.searchCtrl.clear();
      widget.onSearch();
      FocusManager.instance.primaryFocus?.unfocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: widget.searchCtrl,
      onChanged: onSearchChange,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: Icon(
          HeroiconsOutline.magnifyingGlass,
          color: AppColors.gray,
        ),
        errorText: null,
        hintText: widget.hint,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color:AppColors.gray),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        fillColor: AppColors.white,
        filled: widget.filled ?? false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightGrayBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color:  AppColors.lightGrayBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightGrayBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightGrayBorder),
        ),
        suffixIcon: isloading
            ? Container(
          width: 22,
          alignment: Alignment.center,
          child: const SizedBox(
            height: 22,
            width: 22,
            child: const GrayLoadingIndicator(
              size: 22,
            ),
          ),
        )
            : widget.searchCtrl.text.isNotEmpty
            ? InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: clear,
          child: Icon(
            Icons.clear,
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
        )
            : null,
      ),
    );
  }
}
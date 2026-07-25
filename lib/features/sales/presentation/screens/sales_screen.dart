import 'package:casher_pos/features/sales/cubit/cart_cubit.dart';
import 'package:casher_pos/features/sales/cubit/cart_state.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/presentation/widget/cart_widget.dart';
import 'package:casher_pos/features/sales/presentation/widget/product_list_widget.dart';
import 'package:casher_pos/features/sales/presentation/widget/sales_top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SalesCubit()..loadProducts()),
        BlocProvider(create: (context) {
          return CartCubit(salesCubit: context.read<SalesCubit>());
        }),
      ],
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SalesTopBarWidget(),
                Expanded(
                  child: ProductListWidget(),
                ),
              ],
            ),
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final hasItems = state.items.isNotEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: hasItems ? 400 : 0,
                child: ClipRect(
                  child: OverflowBox(
                    maxWidth: 400,
                    minWidth: 400,
                    alignment: Alignment.centerLeft,
                    child: hasItems ? CartWidget() : const SizedBox(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
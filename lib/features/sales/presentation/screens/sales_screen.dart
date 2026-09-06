import 'package:casher_pos/core/di/injection.dart';
import 'package:casher_pos/features/sales/cubit/cart_cubit.dart';
import 'package:casher_pos/features/sales/cubit/cart_state.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/data/repositories/sales_repository.dart';
import 'package:casher_pos/features/sales/presentation/widget/cart_widget.dart';
import 'package:casher_pos/features/sales/presentation/widget/product_list_widget.dart';
import 'package:casher_pos/features/sales/presentation/widget/sales_top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SalesCubit(repository: getIt<SalesRepository>())..loadProducts()),
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
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Cari produk...',
                                        prefixIcon: Icon(LucideIcons.search, color: Colors.grey.shade600),
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                        SizedBox(width: 12),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
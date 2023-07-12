// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/numberpicker_cubit.dart';

class IntegerExample extends StatefulWidget {
  const IntegerExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntegerExampleState createState() => _IntegerExampleState();
}

class _IntegerExampleState extends State<IntegerExample> {
  late CurrentAmountCubit currentAmountCubit;
  final TextEditingController _controller = TextEditingController();


  @override
  void didChangeDependencies() {
    currentAmountCubit = context.watch<CurrentAmountCubit>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    currentAmountCubit.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {currentAmountCubit.decrement(); _controller.text = currentAmountCubit.state.toString();}
        ),
        Expanded(
          child: TextField(
            textAlign: TextAlign.center,
            controller: _controller,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final amount = int.tryParse(value) ?? 0;
              currentAmountCubit.setCurrentAmount(amount);
            },
            decoration: const InputDecoration(
              hintText: 'USD',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {currentAmountCubit.increment(); _controller.text = currentAmountCubit.state.toString();}
        ),
      ],
    );
  }
}

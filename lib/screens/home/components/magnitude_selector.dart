import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// low priority todo: min can be higher than max
class MagnitudeSelector extends StatelessWidget {
  final int initialValue;
  final Function(int) notifier;

  MagnitudeSelector({
    @required this.notifier,
    @required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_MagnitudeSelectorNotifier>.value(
      value: _MagnitudeSelectorNotifier(initialValue),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<_MagnitudeSelectorNotifier>(context);
          return DropdownButton<int>(
            value: provider.currentMagnitude,
            isDense: true,
            items: List<DropdownMenuItem<int>>.generate(
              13,
              (i) => DropdownMenuItem(
                child: Text(
                  i.toStringAsFixed(1),
                ),
                value: i,
              ),
            ),
            onChanged: (i) {
              provider.currentMagnitude = i;

              notifier(i);
            },
          );
        },
      ),
    );
  }
}

class _MagnitudeSelectorNotifier extends ChangeNotifier {
  int _currentMagnitude;

  _MagnitudeSelectorNotifier(this._currentMagnitude);

  set currentMagnitude(int newMagnitude) {
    _currentMagnitude = newMagnitude;

    notifyListeners();
  }

  int get currentMagnitude => _currentMagnitude;
}

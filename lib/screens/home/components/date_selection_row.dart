import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DateSelectionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();

    return ChangeNotifierProvider<_DateChangeProvider>.value(
      value: _DateChangeProvider(currentDate),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: generateRow(currentDate),
      ),
    );
  }

  List<Widget> generateRow(DateTime currentDate) {
    const int daysPerRow = 5;

    List<Widget> row = [];

    row.add(DateSelectionItem());

    for (int i = 0; i < daysPerRow; i++)
      row.add(
        DateSelectionItem(
          date: currentDate.subtract(
            Duration(days: daysPerRow - i - 1),
          ),
        ),
      );

    return row;
  }
}

class DateSelectionItem extends StatelessWidget {
  final DateTime date;

  const DateSelectionItem({
    Key key,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    final bool isPortrait = mediaQuery.orientation == Orientation.portrait;

    // contrasts with background
    final Color borderColor = Theme.of(context).iconTheme.color;
    final Color activeBorderColor = Theme.of(context).accentColor;

    final _DateChangeProvider dateProvider =
        Provider.of<_DateChangeProvider>(context);
    final bool active = (dateProvider.currentActiveDate == date &&
            dateProvider.customDate == null) ||
        (date == null && dateProvider.customDate != null);

    return InkWell(
      onTap: () async {
        if (date != null) {
          dateProvider.currentActiveDate = date;
          dateProvider.customDate = null;
        } else {
          if (dateProvider.customDate != null) dateProvider.customDate = null;

          DateTime selectedDate = await showDatePicker(
            context: context,
            initialDate: dateProvider.currentActiveDate,
            firstDate: DateTime(1970),
            lastDate: DateTime.now(),
          );

          dateProvider.customDate = selectedDate;
        }
      },
      child: Container(
        width: width / (isPortrait ? 8 : 16),
        height: height / (isPortrait ? 16 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          border: Border.all(
            color: active ? activeBorderColor : borderColor,
          ),
        ),
        child: Center(
          child: date != null
              ? Text(
                  date.day.toString(),
                  style: Theme.of(context).textTheme.headline5,
                )
              : Icon(
                  dateProvider.customDate == null ? Icons.calendar_today : Icons.clear,
                ),
        ),
      ),
    );
  }
}

class _DateChangeProvider extends ChangeNotifier {
  DateTime _currentActiveDate;
  DateTime _customDate;

  _DateChangeProvider(this._currentActiveDate);

  set currentActiveDate(DateTime newDate) {
    _currentActiveDate = newDate;

    _notify();
  }

  get currentActiveDate => _currentActiveDate;

  set customDate(DateTime newDate) {
    _customDate = newDate;

    _notify();
  }

  get customDate => _customDate;

  _notify() {
    // TODO: notify BLOC

    notifyListeners();
  }
}

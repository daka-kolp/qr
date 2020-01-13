import 'package:flutter/material.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;

class UserInventoryFilterPanel extends StatelessWidget {
  final UserInventoryFilter selectedFilter;
  final ValueChanged<UserInventoryFilter> onPressed;

  const UserInventoryFilterPanel({
    Key key,
    @required this.selectedFilter,
    @required this.onPressed,
  })  : assert(selectedFilter != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        child: Row(
          children: <Widget>[
            _ButtonFilter(
              filter: UserInventoryFilter.taken,
              title: qrLocale.taken,
              selected: selectedFilter == UserInventoryFilter.taken,
              onPressed: onPressed,
            ),
            _ButtonFilter(
              filter: UserInventoryFilter.history,
              title: qrLocale.history,
              selected: selectedFilter == UserInventoryFilter.history,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonFilter extends StatelessWidget {
  final UserInventoryFilter filter;
  final String title;
  final ValueChanged<UserInventoryFilter> onPressed;
  final bool selected;

  const _ButtonFilter({
    Key key,
    @required this.filter,
    @required this.title,
    @required this.onPressed,
    @required this.selected,
  })  : assert(filter != null),
        assert(title != null),
        assert(onPressed != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            width: 2.0,
            color: selected ? Theme.of(context).primaryColorDark : Colors.transparent,
          ),
        ),
        child: Text(title),
        onPressed: () => onPressed(filter),
      ),
    );
  }
}

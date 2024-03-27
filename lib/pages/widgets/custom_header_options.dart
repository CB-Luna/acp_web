import 'package:acp_web/pages/widgets/custom_button.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomHeaderOptions extends StatefulWidget {
  const CustomHeaderOptions({
    super.key,
    required this.filterSelected,
    required this.gridSelected,
    this.onFilterSelected,
    this.onGridSelected,
    this.onListSelected,
    this.ondownloadExcel,
    this.calendar = false,
    this.calendarButton,
    required this.encabezado,
  });

  final String encabezado;

  final bool filterSelected;
  final bool gridSelected;
  
  final bool? calendar;
  final CustomButton? calendarButton;

  final Function()? onFilterSelected;
  final Function()? onGridSelected;
  final Function()? onListSelected;
  final Function()? ondownloadExcel;

  @override
  State<CustomHeaderOptions> createState() => CustomHeaderOptionsState();
}

class CustomHeaderOptionsState extends State<CustomHeaderOptions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.encabezado,
          style: AppTheme.of(context).title3,
        ),
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (widget.calendar == true) widget.calendarButton!,
            Tooltip(
              message: 'Filtro',
              child: IconButton(
                icon: Icon(
                  Icons.filter_alt_outlined,
                  size: 24,
                  color: widget.filterSelected ? AppTheme.of(context).primaryColor : AppTheme.of(context).secondaryColor,
                ),
                splashRadius: 0.01,
                onPressed: widget.onFilterSelected,
              ),
            ),
            if (widget.onListSelected != null)
              Tooltip(
                message: 'Lista',
                child: IconButton(
                  icon: Icon(
                    Icons.format_list_bulleted_outlined,
                    size: 24,
                    color: !widget.gridSelected ? AppTheme.of(context).primaryColor : AppTheme.of(context).secondaryColor,
                  ),
                  isSelected: !widget.gridSelected,
                  splashRadius: 0.01,
                  onPressed: widget.onListSelected,
                ),
              ),
            if (widget.onGridSelected != null)
              Tooltip(
                message: 'Mosaico',
                child: IconButton(
                  icon: Icon(
                    Icons.grid_on_outlined,
                    size: 24,
                    color: widget.gridSelected ? AppTheme.of(context).primaryColor : AppTheme.of(context).secondaryColor,
                  ),
                  isSelected: widget.gridSelected,
                  splashRadius: 0.01,
                  onPressed: widget.onGridSelected,
                ),
              ),
            if (widget.ondownloadExcel != null)
              Tooltip(
                message: 'Descargar Excel',
                child: IconButton(
                  icon: Icon(
                    Icons.download,
                    size: 24,
                    color: AppTheme.of(context).secondaryColor,
                  ),
                  splashRadius: 0.01,
                  onPressed: widget.ondownloadExcel,
                ),
              ),
            IconButton(
              icon: Icon(
                Icons.more_horiz_outlined,
                size: 24,
                color: AppTheme.of(context).secondaryColor,
              ),
              splashRadius: 0.01,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

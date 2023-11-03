import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.of(context).primaryBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2023 ACP ALTERNATIVAS DE CAPITAL',
              style: AppTheme.of(context).bodyText2,
            ),
            Wrap(
              spacing: 16,
              children: [
                Text(
                  'About',
                  style: AppTheme.of(context).bodyText2,
                ),
                Text(
                  'Support',
                  style: AppTheme.of(context).bodyText2,
                ),
                Text(
                  'Contact Us',
                  style: AppTheme.of(context).bodyText2,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

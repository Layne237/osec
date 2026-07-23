import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';

/// Selectable payment-method row (MTN, Orange), with a logo tile, name, an
/// optional subtitle and a radio indicator.
///
/// Ligne de moyen de paiement sélectionnable (MTN, Orange) : tuile logo, nom,
/// sous-titre facultatif et indicateur radio.
///
/// The brand logos are drawn as coloured tiles with initials — no network image
/// or bundled asset is required, so the card always renders.
///
/// Les logos de marque sont dessinés comme des tuiles colorées avec initiales —
/// aucune image distante ni asset requis.
class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.logoText,
    required this.logoColor,
    this.enabled = true,
  });

  final String name;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  /// Short brand initials rendered in the logo tile. / Initiales de la marque.
  final String logoText;

  /// Brand colour for the logo tile. / Couleur de marque de la tuile.
  final Color logoColor;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.animationFast,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.royalBlue.withValues(alpha: 0.10)
            : AppColors.containerSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.royalBlue : AppColors.glassBorder,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _LogoTile(text: logoText, color: logoColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                _RadioDot(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoTile extends StatelessWidget {
  const _LogoTile({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.animationFast,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.royalBlue : AppColors.mutedText,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.royalBlue,
                ),
              ),
            )
          : null,
    );
  }
}

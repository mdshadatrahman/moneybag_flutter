import 'package:flutter/material.dart';

import '../../../moneybag.dart';
import 'contact_dialog.dart';
import 'qa_dialog.dart';

/// create a [SeasonHeaderView] for the [MoneyBagSessionView]
/// include the countdown and helpline
///
class SeasonHeaderView extends StatelessWidget {
  const SeasonHeaderView({
    super.key,
    required this.remainingTime,
    this.theme = const MoneybagTheme(),
  });

  final Duration remainingTime;
  final MoneybagTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24 + 40),
      child: Material(
        color: theme.primaryColor,
        elevation: 0,
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  const BackButton(
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  if (remainingTime.inSeconds > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Session expires in:",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: theme.primarySurfaceColor,
                              ),
                        ),
                        Text(
                          "${remainingTime.inMinutes.toString().padLeft(2, '0')}:${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: theme.primarySurfaceColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Align(
              child: Transform.translate(
                offset: const Offset(0, 48),
                child: const MoneybagLogo(),
              ),
            ),
            const Positioned(
              right: 16,
              top: 16,
              child: _HelpLineAction(),
            ),
          ],
        ),
      ),
    );
  }
}

/// logo path
class MoneybagLogo extends StatelessWidget {
  const MoneybagLogo({super.key});

  @override
  Widget build(BuildContext context) {
    const path = "https://dev-api.moneybag.com.bd/api/v1/uploads/uploads/get/17045536-bc12-4281-8bf7-8e4ee25e172e.png";
    return Container(
      height: 84,
      width: 84,
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.white,
        shadows: [BoxShadow(color: Colors.black38, blurRadius: 6)],
      ),
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(8),
      child: Image.network(
        path,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) => const Placeholder(),
      ),
    );
  }
}

/// contact help line
class _HelpLineAction extends StatelessWidget {
  const _HelpLineAction();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white),
          ),
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => ContactView.show(context),
            icon: const Icon(
              Icons.headset_mic_rounded,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white),
          ),
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => FrequentAskedQuestionView.show(context),
            icon: const Icon(
              Icons.question_mark_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

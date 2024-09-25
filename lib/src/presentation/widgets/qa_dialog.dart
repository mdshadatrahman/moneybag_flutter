import 'package:flutter/material.dart';

import '../../../moneybag.dart';
import '../../models/frequent_asked_question.dart';

class FrequentAskedQuestionView extends StatefulWidget {
  const FrequentAskedQuestionView._(this.theme);

  final MoneybagTheme theme;

  static show(BuildContext context) {
    final theme = MoneybagInheritedWidget.maybeOf(context)?.theme ?? const MoneybagTheme();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 96.0),
          child: FrequentAskedQuestionView._(theme),
        );
      },
    );
  }

  @override
  State<FrequentAskedQuestionView> createState() => _FrequentAskedQuestionViewState();
}

class _FrequentAskedQuestionViewState extends State<FrequentAskedQuestionView> {
  final questions = FrequentAskedQuestion.data;

  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final configTheme = widget.theme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    shape: CircleBorder(
                      side: BorderSide(color: configTheme.primaryColor),
                    ),
                    color: Colors.white,
                    child: const CloseButton(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Frequently Asked Questions",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ExpansionPanelList(
                    elevation: 0,
                    expandIconColor: configTheme.primaryColor,
                    expansionCallback: (int index, bool isExpanded) {
                      expandedIndex = isExpanded ? index : null;
                      setState(() {});
                    },
                    dividerColor: configTheme.disabledColor,
                    expandedHeaderPadding: const EdgeInsets.all(0),
                    children: questions.map((q) {
                      return ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.grey.shade100,
                        isExpanded: expandedIndex == questions.indexOf(q),
                        headerBuilder: (ctx, isOpen) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(q.question),
                            ),
                          );
                        },
                        body: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(q.ans),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

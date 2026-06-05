part of 'quick_settle_page.dart';

class _QuickSettleForm extends StatelessWidget {
  const _QuickSettleForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 240),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    // color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    // color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(width: 5),
                DecoratedBox(
                  decoration: BoxDecoration(
                    // color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    // color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<QuickSettleBloc, QuickSettleState>(
            builder: (context, state) {
              final total = state.store.total;
              final numberOfPeople = state.store.peopleRecord.length;
              final splitPerPerson = state.store.individualShare;
              return Container(
                padding: const EdgeInsets.only(top: 18, left: 26, bottom: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // color: AppColors.darkGreyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Amount: ${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Number Of People: $numberOfPeople',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Split Per Person: '
                      '${splitPerPerson.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 240),
            child: GestureDetector(
              onTap: () {
                getBloc<QuickSettleBloc>(context).toggleListView();
              },
              child: Container(
                width: 80,
                height: 31,
                decoration: BoxDecoration(
                  // color: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    'Change',
                    style: TextStyle(
                      // color: AppColors.whiteColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<QuickSettleBloc, QuickSettleState>(
              builder: (context, state) {
                final transactions = state.store.finalTransaction;

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final sender = transaction.keys.first;
                    final details = transaction[sender]!.split('|');
                    final receiver = details[0];
                    final amount = double.parse(details[1]);
                    if (state.store.toggleCard) {
                      return QuickSettleOutputArrowCard(
                        sender: sender,
                        receiver: receiver,
                        amount: amount < 0
                            ? (-1 * amount).toStringAsFixed(2)
                            : amount.toStringAsFixed(2),
                      );
                    } else {
                      return QuickSettleOutputTextCard(
                        sender: sender,
                        receiver: receiver,
                        amount: amount < 0
                            ? (-1 * amount).toStringAsFixed(2)
                            : amount.toStringAsFixed(2),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      // color: AppColors.blueButtonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            // color: AppColors.whiteColor,
                          ),
                          Text(
                            'Edit',
                            style: TextStyle(
                              // color: AppColors.whiteColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final summary = getBloc<QuickSettleBloc>(
                      context,
                    ).state.store.summaryMap;
                    unawaited(
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (context) {
                          return SummaryBottomSheet(summaryMap: summary);
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      // color: AppColors.blueButtonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Center(
                        child: Text(
                          'Summary',
                          style: TextStyle(
                            // color: AppColors.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

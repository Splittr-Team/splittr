part of 'quick_split_page.dart';

class _QuickSplitForm extends StatelessWidget {
  const _QuickSplitForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            'Add Name & Amount',
            style: TextStyle(
              // color: AppColors.whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: getBloc<QuickSplitBloc>(context).addPerson,
                child: Container(
                  width: 75,
                  height: 31,
                  decoration: BoxDecoration(
                    // color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_box,
                        // color: AppColors.blackColor,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          // color: AppColors.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: getBloc<QuickSplitBloc>(context).clearData,
                child: Container(
                  width: 75,
                  height: 31,
                  decoration: BoxDecoration(
                    // color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.clear_all,
                        // color: AppColors.blackColor,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Clear',
                        style: TextStyle(
                          // color: AppColors.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: BlocBuilder<QuickSplitBloc, QuickSplitState>(
            builder: (context, state) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                itemCount: state.store.peopleRecords.length,
                itemBuilder: (context, index) {
                  return QuickSplitInputCard(
                    onDelete: () {
                      getBloc<QuickSplitBloc>(
                        context,
                      ).deletePerson(index: index);
                    },
                    onPersonNameChanged: (name) {
                      getBloc<QuickSplitBloc>(
                        context,
                      ).nameChanged(index: index, name: name);
                    },
                    onAmountChanged: (amount) {
                      getBloc<QuickSplitBloc>(
                        context,
                      ).amountChanged(index: index, amount: amount);
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: 325,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            // color: AppColors.blueButtonColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            onTap: getBloc<QuickSplitBloc>(context).quickSettleClicked,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            leading: const Text(
              'Check Split',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

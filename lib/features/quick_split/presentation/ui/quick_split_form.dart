part of 'quick_split_page.dart';

class _QuickSplitForm extends StatelessWidget {
  const _QuickSplitForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md + AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl + AppSpacing.xs,
          ),
          child: AppTextField(
            labelText: 'Split Title',
            hintText: 'e.g. Dinner at Koramangala',
            onChanged: (title) {
              getBloc<QuickSplitBloc>(context).add(
                QuickSplitEvent.splitTitleChanged(splitTitle: title),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md + AppSpacing.xs),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl + AppSpacing.xs,
          ),
          child: Text(
            'Add Name & Amount',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.xl),
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
                      SizedBox(width: AppSpacing.xs),
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
              const SizedBox(width: AppSpacing.sm),
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
                      SizedBox(width: AppSpacing.xs),
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
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: BlocBuilder<QuickSplitBloc, QuickSplitState>(
            builder: (context, state) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.sm),
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
        const SizedBox(height: AppSpacing.md),
        Container(
          width: 325,
          height: 70,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md + AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            onTap: getBloc<QuickSplitBloc>(context).quickSettleClicked,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: AppSpacing.md,
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
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

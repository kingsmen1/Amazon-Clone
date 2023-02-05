import 'package:amazon_clone/features/accounts/services/accountServices.dart';
import 'package:amazon_clone/features/accounts/widgets/accountButton.dart';
import 'package:flutter/cupertino.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your Orders', onTap: () {}),
            AccountButton(text: 'Turn Seller', onTap: () {}),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Log Out',
                onTap: () => AccountServices().logout(context)),
            AccountButton(text: 'Your Wishlist', onTap: () {}),
          ],
        )
      ],
    );
  }
}

import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BankListScreen extends StatefulWidget {
  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  List<Map<String, dynamic>> banks = [
    {
      'icon': ic_wallet_history,
      'name': 'Bank of America',
      'account': '1234567890123456',
      'isDefault': true,
    },
    {
      'icon': ic_wallet_history,
      'name': 'Chase Bank',
      'account': '9876543210987654',
      'isDefault': false,
    },
  ];

  String getMaskedAccount(String account) {
    if (account.length > 4) {
      return '**** **** **** ${account.substring(account.length - 4)}';
    } else {
      return account;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: "Bank Accounts",
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () {
            toast("Add new bank clicked");
            // TODO: Navigate to Add Bank Screen
          },
        ),
      ],
      child: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        children: banks.map((bank) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(
              color: context.cardColor,
              borderRadius: radius(12),
              boxShadow: defaultBoxShadow(),
            ),
            child: Row(
              children: [
                bank['icon'].iconImage(size: 36),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bank['name'], style: boldTextStyle(size: 14)),
                    4.height,
                    Text(getMaskedAccount(bank['account']),
                        style: secondaryTextStyle()),
                    8.height,
                    TextButton(
                      onPressed: () {
                        toast("Edit ${bank['name']}");
                      },
                      child: Text("Edit", style: primaryTextStyle(color: primaryColor)),
                    ),
                  ],
                ).expand(),
                if (bank['isDefault'])
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: boxDecorationDefault(
                      color: primaryColor.withAlpha(30),
                      borderRadius: radius(20),
                      border: Border.all(color: primaryColor),
                    ),
                    child: Text("Default",
                        style: boldTextStyle(
                          color: primaryColor,
                          size: 12,
                        )),
                  )
                else
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        banks.forEach((b) => b['isDefault'] = false);
                        bank['isDefault'] = true;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text("Set Default",
                        style: secondaryTextStyle(color: primaryColor)),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

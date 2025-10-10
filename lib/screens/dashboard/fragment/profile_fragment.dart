import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/about_screen.dart';
import 'package:booking_system_flutter/screens/auth/edit_profile_screen.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/blog/view/blog_list_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/customer_rating_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/screens/service/favourite_service_screen.dart';
import 'package:booking_system_flutter/screens/setting_screen.dart';
import 'package:booking_system_flutter/screens/wallet/user_wallet_balance_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/extensions/num_extenstions.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_configuration.dart';
import '../../bankDetails/view/bank_details.dart';
import '../../favourite_provider_screen.dart';
import '../../helpDesk/help_desk_list_screen.dart';
import '../component/wallet_history.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<num>? futureWalletBalance;

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {
      appStore.setLoading(false);
      setStatusBarColor(context.primaryColor);
    });
  }

  Future<void> init() async {
    if (appStore.isLoggedIn) {
      appStore.setUserWalletAmount();
      userDetailAPI();
    }
  }

  Future<void> userDetailAPI() async {
    await getUserDetail(appStore.userId, forceUpdate: false).then((value) async {
      await saveUserData(value, forceSyncAppConfigurations: false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.profile,
        textColor: white,
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 0.0,
        color: context.primaryColor,
        showBack: false,
        actions: [
          IconButton(
            icon: ic_setting.iconImage(color: white, size: 20),
            onPressed: () async {
              SettingScreen().launch(context);
            },
          ),
        ],
      ),
      body: Observer(
        builder: (BuildContext context) {
          return Stack(
            children: [
              AnimatedScrollView(
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                padding: EdgeInsets.only(bottom: 32),
                crossAxisAlignment: CrossAxisAlignment.center,
                onSwipeRefresh: () async {
                  await removeKey(LAST_USER_DETAILS_SYNCED_TIME);
                  init();
                  setState(() {});
                  return 1.seconds.delay;
                },
                children: [
                  if (appStore.isLoggedIn)
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(),
                        backgroundColor: appStore.isDarkMode ? context.cardColor : lightPrimaryColor,
                        // border: Border.all(color: primaryColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
  alignment: Alignment.bottomCenter,
  clipBehavior: Clip.none,
  children: [
    // Circular border with image inside
    Container(
      padding: const EdgeInsets.all(3), // border thickness
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: CachedImageWidget(
        url: appStore.userProfileImage,
        height: 70,
        width: 70,
        circle: true,
        fit: BoxFit.cover,
      ),
    ),

    // "Edit" label positioned at bottom
    Positioned(
      bottom: -10, // move below the circle border
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor, width: 1),
        ),
        child: Row(
          children: [
            // const Icon(Icons.edit, size: 14, color: Colors.black54),
            // const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(left:  2.0, right: 2),
              child: Text("Edit", style: secondaryTextStyle(size: 12, color: Colors.black, weight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ),
  ],
),

                                  /*   Positioned(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                      decoration: boxDecorationDefault(
                                        color: primaryColor,
                                        border: Border.all(color: primaryLightColor, width: 2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(language.lblEdit, style: secondaryTextStyle(color: whiteColor, size: 12)),
                                    ).onTap(() {
                                      EditProfileScreen().launch(context);
                                    }),
                                  ),*/
                                // ],
                              // ),
                              24.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Marquee(child: Text(appStore.userFullName, style: boldTextStyle(color: primaryColor, size: 16))),
                                  Marquee(child: Text(appStore.userEmail, style: secondaryTextStyle())),
                                ],
                              ).expand(),
                            ],
                          ).paddingOnly(left: 16, top: 16, bottom: 16).onTap(() {
                            EditProfileScreen().launch(context);
                          }),
                          //
                        ],
                      ),
                    ).paddingOnly(left: 16, right: 16, top: 24),
                  Observer(builder: (context) {
                    return SettingSection(
                      title: Text(language.lblGENERAL, style: boldTextStyle(color: primaryColor)),
                      headingDecoration: boxDecorationDefault(color: context.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16))),
                      divider: Offstage(),
                      headerPadding: EdgeInsets.only(bottom: 14, right: 14, left: 16, top: 14),
                      items: [
//                         SettingItemWidget(
//   decoration: boxDecorationDefault(color: context.cardColor),
//   leading: Image.asset(ic_wallet_cartoon, height: 20),
//   title: language.walletBalance,
//   titleTextStyle: boldTextStyle(size: 12),
//   padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
//   trailing: Text(
//     appStore.userWalletAmount.toPriceFormat(),
//     style: boldTextStyle(),
//   ),
//   onTap: () {
//     if (appConfigurationStore.onlinePaymentStatus) {
//       UserWalletBalanceScreen().launch(context);
//     }
//   },
// ).visible(appConfigurationStore.isEnableUserWallet),
if (appStore.isLoggedIn)
                          SettingItemWidget(
                            decoration: boxDecorationDefault(color: context.cardColor),
                            leading: ic_wallet_cartoon.iconImage(size: SETTING_ICON_SIZE),
                            title: language.walletBalance,
                            titleTextStyle: boldTextStyle(size: 12),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            trailing: Text(
    appStore.userWalletAmount.toPriceFormat(),
    style: boldTextStyle(),
  ),
                            onTap: () {
                              if (appConfigurationStore.onlinePaymentStatus) {
      UserWalletBalanceScreen().launch(context);
    }
                            },
                          ),
                        if (appStore.isLoggedIn && appConfigurationStore.isEnableUserWallet)
                          SettingItemWidget(
                            decoration: boxDecorationDefault(color: context.cardColor),
                            leading: ic_wallet_history.iconImage(size: SETTING_ICON_SIZE),
                            title: language.walletHistory,
                            titleTextStyle: boldTextStyle(size: 12),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            trailing: trailing,
                            onTap: () {
                              UserWalletHistoryScreen().launch(context);
                            },
                          ),
                        if (appStore.isLoggedIn && rolesAndPermissionStore.bankList)
                          SettingItemWidget(
                            decoration: boxDecorationDefault(color: context.cardColor),
                            leading: ic_card.iconImage(size: SETTING_ICON_SIZE),
                            title: language.lblBankDetails,
                            titleTextStyle: boldTextStyle(size: 12),
                            trailing: trailing,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            onTap: () {
                              BankDetails().launch(context);
                            },
                          ),
if (appStore.isLoggedIn)
                        SettingItemWidget(
                          decoration: boxDecorationDefault(color: context.cardColor),
                          leading: ic_heart.iconImage(size: SETTING_ICON_SIZE),
                          title: language.lblFavorite,
                          titleTextStyle: boldTextStyle(size: 12),
                          trailing: trailing,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          onTap: () {
                            doIfLoggedIn(context, () {
                              FavouriteServiceScreen().launch(context);
                            });
                          },
                        ),
// if (appStore.isLoggedIn)
//                         SettingItemWidget(
//                           decoration: boxDecorationDefault(color: context.cardColor),
//                           leading: ic_profile2.iconImage(size: SETTING_ICON_SIZE),
//                           title: "Subscription Plans",
//                           titleTextStyle: boldTextStyle(size: 12),
//                           trailing: trailing,
//                           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                           onTap: () {
//                             doIfLoggedIn(context, () {
//                               FavouriteProviderScreen().launch(context);
//                             });
//                           },
//                         ),
// if (appStore.isLoggedIn)
//                         SettingItemWidget(
//                           decoration: boxDecorationDefault(color: context.cardColor),
//                           leading: ic_profile2.iconImage(size: SETTING_ICON_SIZE),
//                           title: "Bid List",
//                           titleTextStyle: boldTextStyle(size: 12),
//                           trailing: trailing,
//                           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                           onTap: () {
//                             doIfLoggedIn(context, () {
//                               FavouriteProviderScreen().launch(context);
//                             });
//                           },
//                         ),
if (appStore.isLoggedIn)
                        SettingItemWidget(
                          decoration: boxDecorationDefault(color: context.cardColor),
                          leading: ic_profile2.iconImage(size: SETTING_ICON_SIZE),
                          title: language.favouriteProvider,
                          titleTextStyle: boldTextStyle(size: 12),
                          trailing: trailing,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          onTap: () {
                            doIfLoggedIn(context, () {
                              FavouriteProviderScreen().launch(context);
                            });
                          },
                        ),
                        if (appConfigurationStore.blogStatus && rolesAndPermissionStore.blogList)
                          SettingItemWidget(
                            decoration: boxDecorationDefault(color: context.cardColor),
                            leading: ic_document.iconImage(size: SETTING_ICON_SIZE),
                            title: language.blogs,
                            titleTextStyle: boldTextStyle(size: 12),
                            trailing: trailing,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            onTap: () {
                              BlogListScreen().launch(context);
                            },
                          ),
                        // .visible(rolesAndPermissionStore.blogList),
                        SettingItemWidget(
                          decoration: boxDecorationDefault(color: context.cardColor),
                          leading: ic_star.iconImage(size: SETTING_ICON_SIZE),
                          title: language.rateUs,
                          titleTextStyle: boldTextStyle(size: 12),
                          trailing: trailing,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          onTap: () async {
                            // toast("Tank you for Rating Us...");
                            if (isAndroid) {
                              if (getStringAsync(CUSTOMER_PLAY_STORE_URL).isNotEmpty) {
                                commonLaunchUrl(getStringAsync(CUSTOMER_PLAY_STORE_URL), launchMode: LaunchMode.externalApplication);
                              } else {
                                commonLaunchUrl('${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}', launchMode: LaunchMode.externalApplication);
                              }
                            } else if (isIOS) {
                              if (getStringAsync(CUSTOMER_APP_STORE_URL).isNotEmpty) {
                                commonLaunchUrl(getStringAsync(CUSTOMER_APP_STORE_URL), launchMode: LaunchMode.externalApplication);
                              } else {
                                commonLaunchUrl(IOS_LINK_FOR_USER, launchMode: LaunchMode.externalApplication);
                              }
                            }
                          },
                        ),
                        SettingItemWidget(
                          decoration: boxDecorationDefault(color: context.cardColor),
                          leading: ic_my_review.iconImage(size: SETTING_ICON_SIZE),
                          title: language.myReviews,
                          titleTextStyle: boldTextStyle(size: 12),
                          trailing: trailing,
                          padding:
                              appStore.isLoggedIn ? EdgeInsets.symmetric(vertical: 12, horizontal: 16) : EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          onTap: () async {
                            doIfLoggedIn(context, () {
                              CustomerRatingScreen().launch(context);
                            });
                          },
                        ),
                        if (appStore.isLoggedIn && rolesAndPermissionStore.helpDeskList)
                          SettingItemWidget(
                            decoration: boxDecorationDefault(color: context.cardColor),
                            leading: ic_help_desk.iconImage(size: SETTING_ICON_SIZE),
                            title: language.helpDesk,
                            titleTextStyle: boldTextStyle(size: 12),
                            trailing: trailing,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            onTap: () {
                              HelpDeskListScreen().launch(context);
                            },
                          ),
                        SettingItemWidget(
                          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16))),
                          title: '',
                          titleTextStyle: boldTextStyle(size: 0),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          padding: EdgeInsets.only(bottom: 6, right: 16, left: 16, top: 6),
                          onTap: () {},
                        ),
                      ],
                    ).paddingAll(16);
                  }),
                  SettingSection(
                    title: Text(language.lblAboutApp.toUpperCase(), style: boldTextStyle(color: primaryColor)),
                    headingDecoration: boxDecorationDefault(color: context.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16))),
                    divider: Offstage(),
                    headerPadding: EdgeInsets.only(bottom: 14, right: 14, left: 16, top: 14),
                    items: [
                      8.height,
                      SettingItemWidget(
                        decoration: boxDecorationDefault(color: context.cardColor),
                        leading: ic_about_us.iconImage(size: SETTING_ICON_SIZE),
                        title: language.lblAboutApp,
                        titleTextStyle: boldTextStyle(size: 12),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        onTap: () {
                          AboutScreen().launch(context);
                        },
                      ).visible(rolesAndPermissionStore.aboutUs),
                      SettingItemWidget(
                        decoration: boxDecorationDefault(color: context.cardColor),
                        leading: ic_shield_done.iconImage(size: SETTING_ICON_SIZE),
                        title: language.privacyPolicy,
                        titleTextStyle: boldTextStyle(size: 12),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        onTap: () {
                          checkIfLink(context, appConfigurationStore.privacyPolicy, title: language.privacyPolicy);
                        },
                      ).visible(rolesAndPermissionStore.privacyPolicy),
                      SettingItemWidget(
                        decoration: boxDecorationDefault(color: context.cardColor),
                        leading: ic_document.iconImage(size: SETTING_ICON_SIZE),
                        title: language.termsCondition,
                        titleTextStyle: boldTextStyle(size: 12),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        onTap: () {
                          checkIfLink(context, appConfigurationStore.termConditions, title: language.termsCondition);
                        },
                      ).visible(rolesAndPermissionStore.termCondition),
                      SettingItemWidget(
                        decoration: boxDecorationDefault(color: context.cardColor),
                        leading: ic_refund.iconImage(size: SETTING_ICON_SIZE),
                        title: language.refundPolicy,
                        titleTextStyle: boldTextStyle(size: 12),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        onTap: () {
                          checkIfLink(context, appConfigurationStore.refundPolicy, title: language.refundPolicy);
                        },
                      ).visible(rolesAndPermissionStore.refundAndCancellationPolicy),
                      if (appConfigurationStore.helpAndSupport.isNotEmpty && rolesAndPermissionStore.helpAndSupport)
                        SettingItemWidget(
                          decoration: boxDecorationDefault(color: context.cardColor),
                          leading: ic_helpAndSupport.iconImage(size: SETTING_ICON_SIZE),
                          title: language.helpSupport,
                          titleTextStyle: boldTextStyle(size: 12),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          onTap: () {
                            if (appConfigurationStore.helpAndSupport.isNotEmpty) {
                              checkIfLink(context, appConfigurationStore.helpAndSupport, title: language.helpSupport);
                            } else {
                              checkIfLink(context, appConfigurationStore.inquiryEmail.validate(), title: language.helpSupport);
                            }
                          },
                        ),
                      if (appConfigurationStore.helplineNumber.isNotEmpty)
                        SettingItemWidget(
                          decoration: !appStore.isLoggedIn
                              ? boxDecorationDefault(color: context.cardColor)
                              : boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16))),
                          leading: ic_calling.iconImage(size: SETTING_ICON_SIZE),
                          title: language.lblHelplineNumber,
                          titleTextStyle: boldTextStyle(size: 12),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            launchCall(appConfigurationStore.helplineNumber.validate());
                          },
                        ),
                      SettingItemWidget(
                        decoration: !appStore.isLoggedIn
                            ? boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16)))
                            : boxDecorationDefault(color: context.cardColor),
                        leading: Icon(MaterialCommunityIcons.logout, color: context.iconColor, size: SETTING_ICON_SIZE),
                        title: language.signIn,
                        titleTextStyle: boldTextStyle(size: 12),
                        onTap: () {
                          SignInScreen().launch(context);
                        },
                      ).visible(!appStore.isLoggedIn),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  SettingSection(
                    title: Text(language.lblDangerZone.toUpperCase(), style: boldTextStyle(color: redColor, size: 14)),
                    headingDecoration: boxDecorationDefault(color: redColor.withValues(alpha: 0.08), borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16))),
                    divider: Offstage(),
                    headerPadding: EdgeInsets.only(bottom: 14, right: 14, left: 16, top: 14),
                    items: [
                      8.height,
                      SettingItemWidget(
                        decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16))),
                        leading: ic_delete_account.iconImage(size: SETTING_ICON_SIZE),
                        paddingBeforeTrailing: 4,
                        title: language.lblDeleteAccount,
                        titleTextStyle: boldTextStyle(size: 12),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          showConfirmDialogCustom(
                            context,
                            negativeText: language.lblCancel,
                            positiveText: language.lblDelete,
                            onAccept: (_) {
                              ifNotTester(() {
                                appStore.setLoading(true);

                                deleteAccountCompletely().then((value) async {
                                  try {
                                    await userService.removeDocument(appStore.uid);
                                    await userService.deleteUser();
                                  } catch (e) {
                                    print(e);
                                  }

                                  appStore.setLoading(false);

                                  await clearPreferences();
                                  toast(value.message);

                                  push(DashboardScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                                }).catchError((e) {
                                  appStore.setLoading(false);
                                  toast(e.toString());
                                });
                              });
                            },
                            dialogType: DialogType.DELETE,
                            title: language.lblDeleteAccountConformation,
                          );
                        },
                      ),
                      64.height,
                      TextButton(
                        child: Text(language.logout, style: boldTextStyle(color: primaryColor, size: 16)),
                        onPressed: () {
                          logout(context);
                        },
                      ).center(),
                    ],
                  ).visible(appStore.isLoggedIn).paddingOnly(left: 16, right: 16, top: 16),
                  30.height.visible(!appStore.isLoggedIn),
                  SnapHelperWidget<PackageInfoData>(
                    future: getPackageInfo(),
                    onSuccess: (data) {
                      return TextButton(
                        child: VersionInfoWidget(prefixText: 'v', textStyle: secondaryTextStyle()),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: APP_NAME,
                            applicationVersion: data.versionName,
                            applicationIcon: Image.asset(appLogo, height: 50),
                          );
                        },
                      ).center();
                    },
                  ),
                ],
              ),
              Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
            ],
          );
        },
      ),
    );
  }
}

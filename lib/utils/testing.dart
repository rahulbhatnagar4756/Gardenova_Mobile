// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:provider/provider.dart';
// import 'package:punjab_e_kids/screen/parent_screen/bottom_navigation/provider/bottom_navigation_provider.dart';
// import '../../../../main.dart';
// import '../../../../service/api_service/api_service.dart';
// import '../../../../service/api_service/status_enum.dart';
// import '../../../../utils/app_toast/show_toast.dart';
// import '../../../../utils/app_const/app_const.dart';
// import '../../../../utils/inapp_utils/consumable_store.dart';
// import '../../../../utils/shared_pre/shared_pre.dart';
// import '../../dashboard/parent_dashboard.dart';
// import '../../dashboard/provider/parent_dashboard_provider.dart';
// import '../../../parent_screen/bottom_navigation/bottom_navigation.dart';
// import '../modal/children_list_model.dart';
// import '../modal/get_subscription_modal.dart';
// import '../modal/child_subscription_status_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SubscriptionProvider extends ChangeNotifier {
//   final InAppPurchase _iapConnection = InAppPurchase.instance;

//   List<ProductDetails>? productDetailsGloble;
//   List<GetSubscriptionData> getSubscriptionDataList = [];
//   List<ChildrenListAll> childrenAllListData = [];

//   // Selected child IDs for multiple selection
//   List<String> selectedChildIds = [];

//   // Cached subscription statuses for selected children
//   Map<String, ChildSubscriptionStatusData> selectedChildStatuses = {};

//   // Method to toggle child selection
//   void toggleChildSelection(String childId) {
//     if (selectedChildIds.contains(childId)) {
//       selectedChildIds.remove(childId);
//     } else {
//       selectedChildIds.add(childId);
//     }

//     // Clear subscription selection when child selection changes
//     selectedSubscriptionId = null;

//     _fetchSelectedChildStatuses();

//     // Clear subscription selection when child selection changes
//     selectedSubscriptionId = null;

//     print("Selected children count: ${selectedChildIds.length}");
//     print(
//         "Available plans for ${selectedChildIds.length} children: ${filteredSubscriptionPlans.length}");

//     notifyListeners();
//   }

//   // Method to clear all selections
//   void clearChildSelections() {
//     selectedChildIds.clear();
//     selectedChildStatuses.clear();
//     notifyListeners();
//   }

//   // Method to select all children
//   void selectAllChildren() {
//     selectedChildIds = childrenAllListData
//         .map((child) => child.id ?? "")
//         .where((id) => id.isNotEmpty)
//         .toList();
//     _fetchSelectedChildStatuses();
//     notifyListeners();
//   }

//   Future<void> _fetchSelectedChildStatuses({bool force = false}) async {
//     bool updated = false;
//     for (final child in childrenAllListData) {
//       final childId = child.id;
//       if (childId == null) continue;

//       if (force || !selectedChildStatuses.containsKey(childId)) {
//         final status = await checkChildStatus(childId);
//         if (status != null) {
//           selectedChildStatuses[childId] = status;

//           updated = true;
//         }
//       }
//     }
//     if (updated) {
//       notifyListeners();
//     }
//   }

//   // Method to get selected children data
//   List<ChildrenListAll> getSelectedChildren() {
//     return childrenAllListData
//         .where((child) => selectedChildIds.contains(child.id))
//         .toList();
//   }

//   // Getter to check if any selected child has a pending subscription change
//   bool get hasPendingChangeForSelectedChildren {
//     for (final childId in selectedChildIds) {
//       final status = selectedChildStatuses[childId];
//       if (status != null &&
//           (status.subscriptionStatus == "ACTIVE_WITH_PENDING_CHANGE" ||
//               status.pendingPlanId != null)) {
//         return true;
//       }
//     }
//     return false;
//   }

//   // Getter to get the pending plan name for selected children (if any)
//   String? get pendingPlanNameForSelectedChildren {
//     for (final childId in selectedChildIds) {
//       final status = selectedChildStatuses[childId];
//       if (status != null && status.pendingPlanName != null) {
//         return status.pendingPlanName;
//       }
//     }
//     return null;
//   }

//   // Getter to filter subscription plans based on selected children count
//   List<GetSubscriptionData> get filteredSubscriptionPlans {
//     final selectedCount = selectedChildIds.length;

//     // If no children selected, return empty list or all plans (based on your preference)
//     if (selectedCount == 0) {
//       return []; // Return empty list when no children selected
//     }

//     // Filter plans where maxChildren matches the selected children count
//     return getSubscriptionDataList.where((plan) {
//       return plan.maxChildren == selectedCount;
//     }).toList();
//   }

//   // Loaded flag to avoid repeated API calls from Stateless widget
//   bool subscriptionsLoaded = false;
//   Future<void> ensureSubscriptionsLoaded(BuildContext context) async {
//     final dashboardProvider =
//         Provider.of<ParentDashboardProvider>(context, listen: false);

//     if (subscriptionsLoaded) return;
//     await getSubscriptionListApi(context, dashboardProvider.selectedChildID);
//   }

//   // Method to force refresh subscriptions regardless of loaded flag
//   Future<void> forceRefreshSubscriptions(BuildContext context) async {
//     subscriptionsLoaded = false; // Reset flag to force refresh
//     final dashboardProvider =
//         Provider.of<ParentDashboardProvider>(context, listen: false);
//     await getSubscriptionListApi(context, dashboardProvider.selectedChildID);
//   }

//   // Method to refresh children list - can be called when new children are added
//   Future<void> refreshChildrenList(BuildContext context) async {
//     await childrensListApi(context);
//   }

//   // Method to force setup from informative screen - bypasses _iapSetup flag
//   Future<void> forceSetupFromInformative(BuildContext context) async {
//     try {
//       await ensureSubscriptionsLoaded(context);
//       // Always call childrensListApi to get fresh data
//       await childrensListApi(context);

//       // Continue with normal setup if not already done
//       if (!_iapSetup) {
//         await setupInAppPurchase(context);
//       }
//     } catch (e) {
//       print('forceSetupFromInformative error: $e');
//     }
//   }

//   // Method to reset all data when user logs out
//   void resetData() {
//     // Clear all cached data
//     subscriptionsLoaded = false;
//     getSubscriptionDataList.clear();
//     childrenAllListData.clear();
//     selectedChildIds.clear();
//     selectedChildStatuses.clear();
//     selectedSubscriptionId = null;
//     endingDate = null;

//     // Reset IAP flags
//     _userInitiatedPurchase = false;
//     _iapSetup = false;
//     _acceptEvents = false;
//     _userInitiatedRestore = false;

//     // Clear processed transactions
//     _processedTransactionIds.clear();
//     _backendSavedTransactionIds.clear();

//     // Reset product details
//     productDetailsGloble = null;

//     print('SubscriptionProvider data reset for new user login');
//     notifyListeners();
//   }

//   String? endingDate;
//   bool _userInitiatedPurchase = false; // Track explicit Subscribe action
//   String? _intendedPurchaseProductId; // Track exactly what we are trying to buy
//   bool _iapSetup = false; // one-time setup guard
//   bool _acceptEvents = false; // start processing only after user action
//   bool _userInitiatedRestore = false; // track explicit restore
//   // Track processed transactions to avoid duplicates
//   final Set<String> _processedTransactionIds = <String>{};
//   // Track which transactions already saved to backend
//   final Set<String> _backendSavedTransactionIds = <String>{};

//   Future<void> setupInAppPurchase(BuildContext context) async {
//     try {
//       // Always refresh subscription and children data to ensure fresh data for new user login
//       await forceRefreshSubscriptions(context);
//       // Always call childrensListApi to get fresh data when activity starts
//       await childrensListApi(context);

//       // Force refresh the statuses of any already selected children
//       await _fetchSelectedChildStatuses(force: true);

//       // Only setup IAP listeners once
//       if (_iapSetup) return;

//       // Drain any pending iOS transactions before listening to avoid past events firing first.
//       if (Platform.isIOS) {
//         try {
//           final transactions = await SKPaymentQueueWrapper().transactions();
//           for (final t in transactions) {
//             await SKPaymentQueueWrapper().finishTransaction(t);
//           }
//         } catch (e) {
//           print('Drain pending iOS transactions error: $e');
//         }
//       }

//       _acceptEvents = false; // do not process past events by default
//       inAppPurchaseListetion();
//       await initStoreInfo();
//       _iapSetup = true;
//     } catch (e) {
//       print('setupInAppPurchase error: $e');
//     }
//   }

//   Future<void> clearOldTransactions() async {
//     final transactions = await SKPaymentQueueWrapper().transactions();
//     for (var t in transactions) {
//       await SKPaymentQueueWrapper().finishTransaction(t);
//     }
//     print("✅ Cleared old transactions");
//   }

//   // Explicit restore button flow
//   Future<void> restorePurchases() async {
//     try {
//       _userInitiatedRestore = true;
//       _acceptEvents = true; // accept restore callbacks
//       if (Platform.isIOS) {
//         // Do not finish here; let StoreKit deliver restored transactions
//         await _inAppPurchase.restorePurchases();
//       } else {
//         await _inAppPurchase.restorePurchases();
//       }
//     } catch (e) {
//       print('restorePurchases error: $e');
//       _userInitiatedRestore = false;
//       _acceptEvents = false;
//     }
//   }

//   // Utility requested: remove all unfinished transactions and restart listeners
//   Future<void> clearAllUnfinishedTransactionsAndRestart(
//       BuildContext context) async {
//     try {
//       if (Platform.isIOS) {
//         final transactions = await SKPaymentQueueWrapper().transactions();
//         for (final t in transactions) {
//           await SKPaymentQueueWrapper().finishTransaction(t);
//         }
//       }
//       // Reset flags and listeners
//       _processedTransactionIds.clear();
//       _userInitiatedPurchase = false;
//       _userInitiatedRestore = false;
//       _acceptEvents = false;
//       _iapSetup = false;
//       // Re-setup
//       await setupInAppPurchase(context);
//       print('🔁 Cleared unfinished transactions and restarted IAP listeners');
//     } catch (e) {
//       print('clearAllUnfinishedTransactionsAndRestart error: $e');
//     }
//   }

//   Future<void> purchaseSubscription(ProductDetails productDetails) async {
//     _userInitiatedPurchase = true; // mark user intent
//     _acceptEvents = true; // accept callbacks for this flow
//     _intendedPurchaseProductId = productDetails.id;

//     print("data--> ${productDetails.id}");
//     print("data--> ${productDetails.title}");

//     final PurchaseParam purchaseParam;
//     try {
//       // Initiate purchase flow for the specified subscription

//       if (Platform.isIOS) {
//         purchaseParam = PurchaseParam(
//           productDetails: productDetails,
//         );
//         await _iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
//       } else {
//         print('product status 1');
//         purchaseParam = GooglePlayPurchaseParam(productDetails: productDetails);
//         print('product status 2');
//         try {
//           await _iapConnection.buyNonConsumable(
//             purchaseParam: purchaseParam,
//           );
//         } catch (e) {
//           print('e _iapConnection.buyNonConsumable ---> ${e}');
//         }
//       }
//     } catch (e) {
//       _userInitiatedPurchase = false;

//       print("Error purchaseSubscription ${e.toString()}");
//       // Handle purchase error
//     }
//   }

//   ///  IN App purcher start
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<ProductDetails> _products = <ProductDetails>[];
//   List<String> _consumables = <String>[];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;
//   final bool _kAutoConsume = Platform.isIOS || true;

//   List<String> _kProductIds = [];

//   /// The purchase token from the user's most recent FRESH subscription purchase.
//   /// After a deferred downgrade, queryPastPurchases() returns a change-order
//   /// token that Google Play rejects for further subscription changes.
//   /// We cache the original token so upgrade flows can use it as oldPurchaseDetails.
//   static const String _originalPurchaseTokenKey =
//       'bolbani_original_purchase_token';
//   String? _originalPurchaseToken;

//   inAppPurchaseListetion() {
//     try {
//       final Stream<List<PurchaseDetails>> purchaseUpdated =
//           _inAppPurchase.purchaseStream;
//       _subscription =
//           purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//         print('purchaseDetailsList---? ${purchaseDetailsList.length}');
//         _listenToPurchaseUpdated(purchaseDetailsList);
//       }, onDone: () {
//         _subscription.cancel();
//       }, onError: (Object error) {
//         print('Error inAppPurchaseListetion--> ${error.toString()}');
//       });
//     } catch (e) {
//       print('Error inAppPurchaseListetion--> ${e.toString()}');
//     }
//   }

//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       print("isAvailable 1--> ${isAvailable}");
//       _isAvailable = isAvailable;
//       _products = <ProductDetails>[];
//       notifyListeners();
//       return;
//     }

//     if (Platform.isIOS) {
//       print("isAvailable--> ${isAvailable}");
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       print("iosPlatformAddition--> ${iosPlatformAddition}");
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }

//     const Set<String> kIds = <String>{'com.bolbani.kids.monthly_plan'};

//     final ProductDetailsResponse productDetailResponse =
//         await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       print('Error fetching products: ${productDetailResponse.error}');
//       _queryProductError = productDetailResponse.error!.message;
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       // _purchases = <PurchaseDetails>[];
//       // _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = <String>[];
//       _purchasePending = false;
//       _loading = false;
//       notifyListeners();
//       return;
//     }

//     if (productDetailResponse.productDetails.isEmpty) {
//       print('No products found');
//       _queryProductError = null;
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       // _purchases = <PurchaseDetails>[];
//       // _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = <String>[];
//       _purchasePending = false;
//       _loading = false;
//       notifyListeners();
//       return;
//     }
//     List<ProductDetails> products = productDetailResponse.productDetails;
//     final List<String> consumables = await ConsumableStore.load();
//     _isAvailable = isAvailable;
//     _products = productDetailResponse.productDetails;
//     // _notFoundIds = productDetailResponse.notFoundIDs;
//     _consumables = consumables;
//     _purchasePending = false;
//     _loading = false;
//     print('products---> ${products[0].id}');
//     print('products length---> ${products.length}');
//     productDetailsGloble = products;
//     notifyListeners();
//   }

//   Future<void> _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     print("In ap status start =>");
//     try {
//       // Ignore events until a user action (purchase/restore) occurs.
//       if (!_acceptEvents) {
//         print('⚠️ Ignoring purchase updates because acceptEvents=false');
//         return;
//       }

//       var context = navigatorKey.currentContext;
//       for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//         log("==== Transaction Debug ====");
//         log("status: ${purchaseDetails.status}");
//         log("purchaseID: ${purchaseDetails.purchaseID}");
//         log("productID: ${purchaseDetails.productID}");
//         log("==== END ====");

//         // De-dupe by transaction id (if present)
//         final String? txId = purchaseDetails.purchaseID;
//         if (txId != null && _processedTransactionIds.contains(txId)) {
//           log('🔁 Duplicate transaction ignored: $txId');
//           continue;
//         }

//         switch (purchaseDetails.status) {
//           case PurchaseStatus.canceled:
//           case PurchaseStatus.error:
//             log("In ap status: ${purchaseDetails.status}");
//             context?.loaderOverlay.hide();
//             _resetPurchaseState();
//             continue;

//           case PurchaseStatus.pending:
//             log("In ap status: pending");
//             context?.loaderOverlay.show();
//             continue;

//           case PurchaseStatus.purchased:
//           case PurchaseStatus.restored:
//             await _handleSuccessfulPurchaseOrRestore(purchaseDetails, context);
//             continue;
//         }
//       }
//     } catch (e) {
//       print("Error in _listenToPurchaseUpdated: $e");
//     }
//   }

//   void _resetPurchaseState() {
//     _userInitiatedPurchase = false;
//     _intendedPurchaseProductId = null;
//     _userInitiatedRestore = false;
//     _acceptEvents = false;
//     notifyListeners();
//   }

//   List<String> _getVerifyChildIds(BuildContext? context) {
//     List<String> verifyChildIds = List.from(selectedChildIds);
//     if (verifyChildIds.isEmpty && context != null) {
//       try {
//         final dashboardProvider =
//             Provider.of<ParentDashboardProvider>(context, listen: false);
//         if (dashboardProvider.selectedChildID.isNotEmpty) {
//           verifyChildIds = [dashboardProvider.selectedChildID];
//           print(
//               'ℹ️ Added fallback childId ${dashboardProvider.selectedChildID} for saving.');
//         }
//       } catch (e) {
//         print('❌ Could not fetch fallback childId: $e');
//       }
//     }
//     return verifyChildIds;
//   }

//   void _navigateHomeAfterPurchase() {
//     navigatorKey.currentState?.popUntil((route) => route.isFirst);
//     try {
//       final bottomProvider = Provider.of<BottomNavigationProvider>(
//           navigatorKey.currentContext!,
//           listen: false);
//       bottomProvider.setCurrentIndex(0);
//     } catch (e) {}
//   }

//   Future<void> _handleSuccessfulPurchaseOrRestore(
//       PurchaseDetails purchaseDetails, BuildContext? context) async {
//     // Google Play sometimes re-emits active past purchases during the billing flow.
//     // If the user initiated a purchase, ONLY accept the intended product ID.
//     // EXCEPTION: For Android deferred downgrades, Google Play returns the current (old) plan ID.
//     if (_userInitiatedPurchase && _intendedPurchaseProductId != null) {
//       if (purchaseDetails.productID != _intendedPurchaseProductId) {
//         final bool isAndroidDowngrade = Platform.isAndroid &&
//             _currentProductId != null &&
//             purchaseDetails.productID == _currentProductId;

//         if (isAndroidDowngrade) {
//           print(
//               "ℹ️ Detected Android downgrade flow (ID mismatch expected for DEFERRED mode). Proceeding with intended ID: $_intendedPurchaseProductId");
//         } else {
//           print(
//               "⚠️ Ignoring old transaction for ${purchaseDetails.productID} because we are expecting $_intendedPurchaseProductId");
//           if (purchaseDetails.pendingCompletePurchase || Platform.isIOS) {
//             try {
//               await _inAppPurchase.completePurchase(purchaseDetails);
//             } catch (e) {}
//           }
//           return; // Keep waiting for the actual new purchase!
//         }
//       }
//     }

//     final bool isPurchase =
//         purchaseDetails.status == PurchaseStatus.purchased ||
//             (purchaseDetails.status == PurchaseStatus.restored &&
//                 _userInitiatedPurchase);

//     final bool isRestore = purchaseDetails.status == PurchaseStatus.restored &&
//         _userInitiatedRestore;

//     // If it's some other background event we don't handle explicitly
//     if (!isPurchase && !isRestore) {
//       if (purchaseDetails.pendingCompletePurchase || Platform.isIOS) {
//         await _inAppPurchase.completePurchase(purchaseDetails);
//       }
//       return;
//     }

//     if (isPurchase) context?.loaderOverlay.show();
//     if (isRestore) context?.loaderOverlay.hide();

//     List<String> verifyChildIds = _getVerifyChildIds(context);
//     if (verifyChildIds.isEmpty) {
//       print('❌ No child selected and no fallback childId available – abort.');
//       context?.loaderOverlay.hide();
//       return;
//     }

//     final String platform = Platform.isIOS ? 'ios' : 'android';

//     if (isPurchase) {
//       // --- UNIFIED PURCHASE FLOW ---
//       // Use intended product ID for downgrade flows where ID mismatch is expected
//       final String effectiveProductId =
//           (Platform.isAndroid && _intendedPurchaseProductId != null)
//               ? _intendedPurchaseProductId!
//               : purchaseDetails.productID;

//       await _cachePendingPurchase(purchaseDetails,
//           overrideProductId: effectiveProductId);

//       final verified = await verifyPurchaseWithBackend(
//         platform: platform,
//         productId: effectiveProductId,
//         purchaseToken: purchaseDetails.verificationData.serverVerificationData,
//         orderId: purchaseDetails.purchaseID,
//         transactionId: purchaseDetails.purchaseID,
//         purchaseTime: purchaseDetails.transactionDate,
//         childIds: verifyChildIds,
//       );

//       if (purchaseDetails.pendingCompletePurchase || Platform.isIOS) {
//         try {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//           print('🧾 completePurchase done');
//         } catch (e) {
//           print('❌ completePurchase error: $e');
//         }
//       }

//       if (verified) {
//         // Cache the original purchase token on a successful fresh purchase.
//         // This token is needed later if the user tries to upgrade while a
//         // deferred downgrade is pending (the deferred change order token that
//         // queryPastPurchases() returns is rejected by Google Play for further
//         // subscription changes; the original token must be used instead).
//         final isNewFreshPurchase = !(_intendedPurchaseProductId != null &&
//             purchaseDetails.productID != effectiveProductId);
//         if (isNewFreshPurchase) {
//           _originalPurchaseToken =
//               purchaseDetails.verificationData.serverVerificationData;
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString(
//               _originalPurchaseTokenKey, _originalPurchaseToken!);
//           print('🔑 Original purchase token cached for future upgrade use.');
//         }
//         unawaited(deliverProduct(purchaseDetails));
//         await _clearPendingPurchase();
//         showToast(message: 'Plan Purchase Successfully.');
//         _navigateHomeAfterPurchase();
//       } else {
//         print('❌ Backend verification failed – pending cache kept for retry.');
//         showToast(message: 'Verification pending. Will retry automatically.');
//       }
//     } else if (isRestore) {
//       // --- EXPLICIT RESTORE FLOW ---
//       print("🌀 EXPLICIT RESTORE triggered for ${purchaseDetails.productID}");
//       try {
//         bool restored = await verifyPurchaseWithBackend(
//           platform: platform,
//           productId: purchaseDetails.productID,
//           purchaseToken:
//               purchaseDetails.verificationData.serverVerificationData,
//           orderId: purchaseDetails.purchaseID,
//           transactionId: purchaseDetails.purchaseID,
//           purchaseTime: purchaseDetails.transactionDate,
//           childIds: verifyChildIds,
//         );

//         if (restored) {
//           print('✅ Restore validated for ${purchaseDetails.productID}');
//           unawaited(deliverProduct(purchaseDetails));
//           if (purchaseDetails.pendingCompletePurchase || Platform.isIOS) {
//             try {
//               await _inAppPurchase.completePurchase(purchaseDetails);
//               print('🧾 completePurchase done for restore');
//             } catch (e) {
//               print('❌ completePurchase restore error: $e');
//             }
//           }
//           showToast(message: 'Subscription restored.');
//         } else {
//           showToast(message: 'No active subscription found for restore.');
//         }
//       } catch (e) {
//         print('❌ Error during restore: $e');
//         showToast(message: 'Restore failed.');
//       }
//     }

//     if (purchaseDetails.purchaseID != null) {
//       _processedTransactionIds.add(purchaseDetails.purchaseID!);
//     }

//     _resetPurchaseState();
//     if (isPurchase) context?.loaderOverlay.hide();
//   }

//   Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     await ConsumableStore.save(purchaseDetails.purchaseID!);
//     final List<String> consumables = await ConsumableStore.load();
//     _purchasePending = false;
//     _consumables = consumables;
//   }

//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     print(purchaseDetails.verificationData.serverVerificationData);

//     // inAppPurchaseApi(
//     //     receiptData: purchaseDetails.verificationData.serverVerificationData
//     //         .toString())
//     //     .then((value) {
//     //   isButtonLoading.value[indexButtonClick] = false;
//     //   update();
//     //   //   isButton(false);
//     // });
//     return Future<bool>.value(true);
//   }

//   onIosPay(String id) async {
//     _userInitiatedPurchase = true; // mark user intent for iOS flow
//     _acceptEvents = true;
//     _intendedPurchaseProductId = id;

//     // isButton(true);

//     // isButtonLoading.value[indexButtonClick] = true;

//     print("pordcut =>${id}");
//     print("pordcut length =>${_products.length}");
//     ProductDetails productDetailst =
//         _products.firstWhere((element) => element.id == id);

//     print("producyt =>${productDetailst.id}");
//     print("producyt =>${productDetailst.rawPrice}");

//     // ProductDetails productDetailst = ProductDetails(
//     //     id: 'premium_plan399',
//     //     title: '',
//     //     description: '',
//     //     price: '\$399',
//     //     rawPrice: 399.0,
//     //     currencyCode: '\$');
//     try {
//       PurchaseParam purchaseParam;
//       purchaseParam = PurchaseParam(
//         productDetails: productDetailst,
//       );

//       // Finish any pending transactions before starting a new purchase
//       // final transactions = await SKPaymentQueueWrapper().transactions();
//       // for (var transaction in transactions) {
//       //   await SKPaymentQueueWrapper().finishTransaction(transaction);
//       // }

//       _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//     } catch (e) {
//       _userInitiatedPurchase = false;
//       _acceptEvents = false;
//       print("Error: $e");

//       // isButton(false);
//       //  isButtonLoading.value[indexButtonClick] = false;
//       //  update();
//     }
//   }

//   // ============================================================
//   // SERVER-SIDE VERIFICATION (replaces deprecated client-side Apple validation)
//   // ============================================================

//   /// Verify purchase receipt via backend POST /api/parent/subscriptions/verify.
//   /// Backend handles both iOS receipt and Android token validation internally.
//   /// Replaces the old inAppPurchaseApi() that called Apple's verifyReceipt
//   /// directly from client with a hardcoded shared secret.
//   Future<bool> verifyPurchaseWithBackend({
//     required String platform,
//     required String productId,
//     required String purchaseToken,
//     String? orderId,
//     String? transactionId,
//     String? purchaseTime,
//     List<String>? childIds,
//   }) async {
//     try {
//       // Unified robust parsing of purchaseTime (milliseconds, seconds, or ISO / formatted string)
//       DateTime? parsedDate;
//       if (purchaseTime != null && purchaseTime.trim().isNotEmpty) {
//         final raw = purchaseTime.trim();
//         final numeric = RegExp(r'^\d+$').hasMatch(raw);
//         try {
//           if (numeric) {
//             if (raw.length >= 13) {
//               parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(raw),
//                   isUtc: true);
//             } else if (raw.length == 10) {
//               parsedDate = DateTime.fromMillisecondsSinceEpoch(
//                   int.parse(raw) * 1000,
//                   isUtc: true);
//             } else {
//               parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(raw),
//                   isUtc: true);
//             }
//           } else {
//             final isoCandidate =
//                 raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
//             parsedDate = DateTime.tryParse(isoCandidate)?.toUtc();
//           }
//         } catch (e) {
//           print('⚠️ purchaseTime parse error: $e');
//         }
//       }
//       parsedDate ??= DateTime.now().toUtc();
//       final normalizedPurchaseIso = parsedDate.toIso8601String();

//       final body = <String, dynamic>{
//         'platform': platform,
//         'productId': productId,
//         'purchaseToken': purchaseToken,
//         if (orderId != null) 'orderId': orderId,
//         if (transactionId != null) 'transactionId': transactionId,
//         'purchaseTime': normalizedPurchaseIso,
//       };

//       if (childIds != null && childIds.isNotEmpty) {
//         if (childIds.length == 1) {
//           body['childId'] = childIds.first;
//         } else {
//           body['childrenIds'] = childIds;
//         }
//       }
//       debugPrint("body verification =>$body");
//       print(
//           '📡 Calling backend verification for $productId on $platform and platform $platform...');
//       final response = await AppApi.verifySubscriptionApi(body);
//       if (response.status == Status.success) {
//         print('✅ Backend verification success for $productId');
//         selectedChildStatuses.clear(); // Force refresh on next load
//         return true;
//       } else {
//         print('❌ Backend verification failed: ${response.message}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Backend verification error: $e');
//       return false;
//     }
//   }

//   // ============================================================
//   // PRE-PURCHASE CONFLICT CHECK
//   // ============================================================

//   /// Check if a child already has an active subscription.
//   /// Calls GET /api/parent/subscriptions/status?childId=X
//   Future<ChildSubscriptionStatusData?> checkChildStatus(String childId) async {
//     try {
//       final result = await AppApi.childSubscriptionStatusApi(childId);
//       if (result.apiStatus == Status.success) {
//         return result.data;
//       }
//       return null;
//     } catch (e) {
//       print('❌ Child status check failed for $childId: $e');
//       return null;
//     }
//   }

//   /// Track the current plan's sort order for upgrade/downgrade detection
//   int? _currentPlanSortOrder;
//   String? _currentProductId;

//   /// Determine what purchase action is needed for the selected children + plan (Synchronous version).
//   PurchaseAction getPurchaseActionForPlan(GetSubscriptionData newPlan) {
//     final currentPlatform = Platform.isIOS ? 'ios' : 'android';

//     bool hasSelectedActive = false;
//     print('selectedChildIds $selectedChildIds');
//     for (final childId in selectedChildIds) {
//       final status = selectedChildStatuses[childId];
//       if (status == null || status.isActive != true) continue;

//       hasSelectedActive = true;
//       print(
//           'selectedChildIds ${status.platform} and current ${currentPlatform}');
//       // Child has active subscription
//       if (status.platform != currentPlatform && status.platform != null) {
//         return PurchaseAction.crossPlatformConflict;
//       }

//       // Check for a pending subscription change (ACTIVE_WITH_PENDING_CHANGE)
//       if (status.subscriptionStatus == "ACTIVE_WITH_PENDING_CHANGE" ||
//           status.pendingPlanId != null) {
//         final newProductId = Platform.isIOS
//             ? (newPlan.subscriptionAppleId ?? '')
//             : (newPlan.subscriptionAndroidId ?? '');

//         // The currently ACTIVE (running) plan ID – NOT the pending future plan
//         final activeProductId = status.productId ?? '';

//         // Already on the active plan itself
//         if (activeProductId == newProductId) {
//           return PurchaseAction.alreadyOnSamePlan;
//         }

//         // User selected the exact plan that is already scheduled as pending
//         if (status.pendingPlanId == newProductId) {
//           return PurchaseAction.alreadyOnSamePlan;
//         }

//         // Compare sortOrder of new plan vs the ACTIVE (running) plan
//         final activePlan = getSubscriptionDataList.firstWhereOrNull(
//           (p) =>
//               (Platform.isIOS
//                   ? p.subscriptionAppleId
//                   : p.subscriptionAndroidId) ==
//               activeProductId,
//         );

//         // Set current plan context to the ACTIVE plan so purchaseWithUpgradeDowngrade
//         // sends the correct (active) purchase token to Google Play
//         _currentPlanSortOrder = activePlan?.sortOrder;
//         _currentProductId = activeProductId;

//         if ((newPlan.sortOrder ?? 0) > (activePlan?.sortOrder ?? 0)) {
//           // Upgrade over the active plan — Google Play can cancel the
//           // pending downgrade and apply the new upgrade immediately.
//           return PurchaseAction.upgradeReplacingPendingDowngrade;
//         }

//         // Downgrade or same tier while a change is pending — block
//         return PurchaseAction.pendingChangeScheduled;
//       }

//       // Same platform — compare plans
//       final currentProductId = status.productId ?? '';
//       final newProductId = Platform.isIOS
//           ? (newPlan.subscriptionAppleId ?? '')
//           : (newPlan.subscriptionAndroidId ?? '');

//       if (currentProductId == newProductId) {
//         return PurchaseAction.alreadyOnSamePlan;
//       }

//       // Compare sortOrder to determine upgrade vs downgrade
//       final currentPlan = getSubscriptionDataList.firstWhereOrNull(
//         (p) =>
//             (Platform.isIOS
//                 ? p.subscriptionAppleId
//                 : p.subscriptionAndroidId) ==
//             currentProductId,
//       );

//       _currentPlanSortOrder = currentPlan?.sortOrder;
//       _currentProductId = currentProductId;

//       if ((newPlan.sortOrder ?? 0) > (currentPlan?.sortOrder ?? 0)) {
//         return PurchaseAction.upgrade;
//       } else {
//         return PurchaseAction.downgrade;
//       }
//     }

//     if (!hasSelectedActive) {
//       bool hasAnyActiveSubscription = false;
//       for (final child in childrenAllListData) {
//         if (child.id != null) {
//           final status = selectedChildStatuses[child.id!];
//           if (status != null && status.isActive == true) {
//             hasAnyActiveSubscription = true;
//             break;
//           }
//         }
//       }

//       if (hasAnyActiveSubscription) {
//         return PurchaseAction.multiChildRequired;
//       }
//     }

//     return PurchaseAction.freshPurchase;
//   }

//   /// Determine what purchase action is needed for the selected children + plan (Asynchronous version).
//   Future<PurchaseAction> determinePurchaseAction(
//       GetSubscriptionData newPlan) async {
//     await _fetchSelectedChildStatuses();
//     return getPurchaseActionForPlan(newPlan);
//   }

//   /// Returns true if [newPlan] has the same maxChildren as the currently active plan.
//   /// Used to choose between withoutProration (same category) vs chargeFullPrice
//   /// (cross-category) for Android upgrade replacement mode.
//   bool isSameChildCategoryForPlan(GetSubscriptionData newPlan) {
//     if (_currentProductId == null) return false;
//     final currentPlan = getSubscriptionDataList.firstWhereOrNull(
//       (p) =>
//           (Platform.isIOS ? p.subscriptionAppleId : p.subscriptionAndroidId) ==
//           _currentProductId,
//     );
//     return currentPlan != null &&
//         newPlan.maxChildren == currentPlan.maxChildren;
//   }

//   // ============================================================
//   // DIAGNOSTIC METHOD - Check all purchase states
//   // ============================================================

//   /// Debug method to check all purchase states
//   Future<void> debugCheckPurchaseStates() async {
//     if (!Platform.isAndroid) {
//       print('⚠️ debugCheckPurchaseStates only runs on Android');
//       return;
//     }

//     try {
//       final InAppPurchaseAndroidPlatformAddition androidAddition =
//           _inAppPurchase.getPlatformAddition<
//               InAppPurchaseAndroidPlatformAddition>();
//       final pastPurchases = await androidAddition.queryPastPurchases();

//       print('═══════════════════════════════════════════════════');
//       print('            📊 PURCHASE STATE DEBUG REPORT          ');
//       print('═══════════════════════════════════════════════════');
//       print('Total Purchases: ${pastPurchases.pastPurchases.length}');
//       print('─────────────────────────────────────────────────────');

//       if (pastPurchases.pastPurchases.isEmpty) {
//         print('⚠️ NO PURCHASES FOUND');
//       } else {
//         for (int i = 0; i < pastPurchases.pastPurchases.length; i++) {
//           final p = pastPurchases.pastPurchases[i] as GooglePlayPurchaseDetails;
//           final token = p.verificationData.serverVerificationData;
//           final tokenPreview =
//               token.length > 20 ? '${token.substring(0, 20)}…' : token;

//           print('\n[$i] Purchase Details:');
//           print('  📦 Product ID: ${p.productID}');
//           print('  🏷️  Purchase ID: ${p.purchaseID}');
//           print('  ⏱️  Status: ${p.status}');
//           print('  ⏳ Pending Completion: ${p.pendingCompletePurchase}');
//           print('  🔑 Token (preview): $tokenPreview');
//           print('─────────────────────────────────────────────────────');
//         }
//       }

//       print('\n🔍 Looking for Current Product: $_currentProductId');
//       print('═══════════════════════════════════════════════════\n');
//     } catch (e) {
//       print('❌ Debug error: $e');
//     }
//   }

//   // ============================================================
//   // UPGRADE / DOWNGRADE PURCHASE (FIXED VERSION)
//   // ============================================================

//   /// Purchase with Android proration for upgrade/downgrade.
//   /// iOS handles upgrade/downgrade automatically within subscription group.
//   ///
//   /// [replacingPendingDowngrade] — when true the user is upgrading over an active
//   /// subscription that already has a deferred downgrade queued. Google Play will
//   /// cancel the pending deferred change and apply the upgrade immediately.
//   Future<void> purchaseWithUpgradeDowngrade(
//     ProductDetails newPlan,
//     GetSubscriptionData planData, {
//     GooglePlayPurchaseDetails? existingAndroidPurchase,
//     bool replacingPendingDowngrade = false,
//   }) async {
//     _userInitiatedPurchase = true;
//     _acceptEvents = true;
//     _intendedPurchaseProductId = newPlan.id;

//     // Safety timeout in case OS silently drops the transaction (common in iOS Sandbox)
//     Future.delayed(const Duration(seconds: 15), () {
//       if (_acceptEvents) {
//         print('⏳ Purchase timeout reached. Resetting state.');
//         _resetPurchaseState();
//         try {
//           navigatorKey.currentContext?.loaderOverlay.hide();
//         } catch (e) {}
//       }
//     });

//     try {
//       if (Platform.isAndroid) {
//         print('\n🔄 UPGRADE/DOWNGRADE FLOW INITIATED');
//         print('═══════════════════════════════════════════════════');

//         // ✅ STEP 1: Query past purchases if not provided
//         if (existingAndroidPurchase == null) {
//           try {
//             final InAppPurchaseAndroidPlatformAddition androidAddition =
//                 _inAppPurchase.getPlatformAddition<
//                     InAppPurchaseAndroidPlatformAddition>();
//             final pastPurchasesResponse =
//                 await androidAddition.queryPastPurchases();

//             print('\n📋 Query Past Purchases Result:');
//             print(
//                 '🔍 Found ${pastPurchasesResponse.pastPurchases.length} purchase(s)');

//             for (int i = 0;
//                 i < pastPurchasesResponse.pastPurchases.length;
//                 i++) {
//               final p = pastPurchasesResponse.pastPurchases[i];
//               final gp = p as GooglePlayPurchaseDetails;
//               final token = gp.verificationData.serverVerificationData;
//               final tokenPreview =
//                   token.length > 20 ? '${token.substring(0, 20)}…' : token;
//               print('  [$i] Product: ${gp.productID}');
//               print('      Status: ${gp.status}');
//               print('      Pending: ${gp.pendingCompletePurchase}');
//               print('      Token: $tokenPreview');
//             }

//             print('\n🔍 Looking for Current Product ID: $_currentProductId');

//             for (final p in pastPurchasesResponse.pastPurchases) {
//               if (p.productID == _currentProductId) {
//                 existingAndroidPurchase = p as GooglePlayPurchaseDetails;
//                 print('✅ FOUND matching purchase!');
//                 break;
//               }
//             }

//             if (existingAndroidPurchase == null) {
//               print('❌ NO matching purchase found for $_currentProductId');
//             }
//           } catch (e) {
//             print('⚠️ Failed to query past purchases: $e');
//           }
//         }

//         if (existingAndroidPurchase == null) {
//           print(
//               '\n❌ FATAL: No existing purchase found for upgrade/downgrade');
//           print('User must have an active subscription to upgrade/downgrade');
//           _userInitiatedPurchase = false;
//           _acceptEvents = false;
//           if (navigatorKey.currentContext != null) {
//             showToast(
//                 message:
//                     'Could not find your current subscription on this Google account. Please ensure you are logged into the correct Play Store account.');
//           }
//           print('═══════════════════════════════════════════════════\n');
//           return;
//         }

//         // ✅ STEP 2: Acknowledge old purchase if pending (THIS WAS THE MISSING PART)
//         print('\n🔑 Checking Purchase Acknowledgment Status:');
//         print(
//             'Pending Completion: ${existingAndroidPurchase!.pendingCompletePurchase}');

//         if (existingAndroidPurchase!.pendingCompletePurchase) {
//           print('⏳ Old purchase is PENDING - Acknowledging...');
//           try {
//             await _inAppPurchase.completePurchase(existingAndroidPurchase!);
//             print('✅ Old purchase ACKNOWLEDGED successfully');

//             // Add delay to let Google Play process the acknowledgment
//             print('⏱️ Waiting 500ms for acknowledgment to propagate...');
//             await Future.delayed(const Duration(milliseconds: 500));
//             print('✅ Delay complete');
//           } catch (e) {
//             print('⚠️ Error acknowledging old purchase: $e');
//             print('ℹ️ Continuing with upgrade attempt anyway...');
//           }
//         } else {
//           print('✅ Old purchase already acknowledged');
//         }

//         // ✅ STEP 3: Check for change-order token
//         print('\n🔐 Checking for Change-Order Token:');
//         if (replacingPendingDowngrade && _originalPurchaseToken != null) {
//           final currentToken =
//               existingAndroidPurchase!.verificationData.serverVerificationData;
//           if (currentToken != _originalPurchaseToken) {
//             final origPreview = _originalPurchaseToken!.length > 20
//                 ? '${_originalPurchaseToken!.substring(0, 20)}…'
//                 : _originalPurchaseToken!;
//             final curPreview = currentToken.length > 20
//                 ? '${currentToken.substring(0, 20)}…'
//                 : currentToken;
//             print('⚠️ Change-order token DETECTED');
//             print('   Current: $curPreview');
//             print('   Original: $origPreview');
//           } else {
//             print('✅ Original token still active (no change-order)');
//           }
//         }

//         // ✅ STEP 4: Determine upgrade/downgrade mode
//         print('\n📊 Determining Replacement Mode:');
//         final isUpgrade =
//             (planData.sortOrder ?? 0) > (_currentPlanSortOrder ?? 0);
//         print('Is Upgrade: $isUpgrade');

//         final currentPlanInList = getSubscriptionDataList.firstWhereOrNull(
//           (p) =>
//               (Platform.isIOS
//                   ? p.subscriptionAppleId
//                   : p.subscriptionAndroidId) ==
//               _currentProductId,
//         );

//         final sameChildCategory = currentPlanInList != null &&
//             planData.maxChildren == currentPlanInList.maxChildren;
//         print('Same Child Category: $sameChildCategory');

//         final ReplacementMode replacementMode;
//         if (replacingPendingDowngrade) {
//           replacementMode = ReplacementMode.chargeFullPrice;
//           print('Mode: chargeFullPrice (replacing pending downgrade)');
//         } else if (isUpgrade && sameChildCategory) {
//           replacementMode = ReplacementMode.withoutProration;
//           print('Mode: withoutProration (same category upgrade)');
//         } else if (isUpgrade) {
//           replacementMode = ReplacementMode.chargeFullPrice;
//           print('Mode: chargeFullPrice (cross-category upgrade)');
//         } else {
//           replacementMode = ReplacementMode.deferred;
//           print('Mode: deferred (downgrade)');
//         }

//         // ✅ STEP 5: Prepare and send purchase request
//         print('\n📤 Initiating Purchase Request:');
//         final selectedToken =
//             existingAndroidPurchase!.verificationData.serverVerificationData;
//         final selectedTokenPreview = selectedToken.length > 20
//             ? '${selectedToken.substring(0, 20)}…'
//             : selectedToken;

//         print('From Plan: $_currentProductId');
//         print('To Plan: ${planData.subscriptionAndroidId}');
//         print('Old Purchase ID: ${existingAndroidPurchase!.purchaseID}');
//         print('Old Token: $selectedTokenPreview');

//         final param = GooglePlayPurchaseParam(
//           productDetails: newPlan,
//           changeSubscriptionParam: ChangeSubscriptionParam(
//             oldPurchaseDetails: existingAndroidPurchase!,
//             replacementMode: replacementMode,
//           ),
//         );

//         try {
//           print('🚀 Calling buyNonConsumable...');
//           await _iapConnection.buyNonConsumable(purchaseParam: param);
//           print('✅ Purchase request sent successfully');
//         } catch (e) {
//           print('❌ Purchase request failed: $e');
//           _userInitiatedPurchase = false;
//           _acceptEvents = false;
//           rethrow;
//         }

//         print('═══════════════════════════════════════════════════\n');
//       } else {
//         // iOS: Apple handles upgrade/downgrade within subscription group
//         print('📱 iOS Platform - Using standard purchase flow');
//         await purchaseSubscription(newPlan);
//       }
//     } catch (e) {
//       _userInitiatedPurchase = false;
//       _acceptEvents = false;
//       print('❌ purchaseWithUpgradeDowngrade error: $e');
//       rethrow;
//     }
//   }

//   // ============================================================
//   // PENDING PURCHASE RECOVERY (crash/network-failure safety)
//   // ============================================================

//   static const String _pendingPurchaseKey = 'bolbani_pending_purchase';

//   /// Cache purchase data locally BEFORE attempting backend verification.
//   /// This survives app kills, crashes, and network failures.
//   Future<void> _cachePendingPurchase(PurchaseDetails details,
//       {String? overrideProductId}) async {
//     try {
//       final String productId = overrideProductId ?? details.productID;
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(
//           _pendingPurchaseKey,
//           jsonEncode({
//             'productId': productId,
//             'purchaseId': details.purchaseID,
//             'transactionDate': details.transactionDate,
//             'serverVerificationData':
//                 details.verificationData.serverVerificationData,
//             'platform': Platform.isIOS ? 'ios' : 'android',
//             'childIds': selectedChildIds,
//             'timestamp': DateTime.now().toIso8601String(),
//           }));
//       print('💾 Pending purchase cached for $productId');
//     } catch (e) {
//       print('⚠️ Failed to cache pending purchase: $e');
//     }
//   }

//   /// Clear pending purchase cache after successful verification + save.
//   Future<void> _clearPendingPurchase() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_pendingPurchaseKey);
//       print('🗑️ Pending purchase cache cleared');
//     } catch (e) {
//       print('⚠️ Failed to clear pending purchase cache: $e');
//     }
//   }

//   /// Called on app open (home screen) to recover unverified purchases.
//   /// If user paid but app crashed before backend verification, this retries.
//   Future<void> checkAndRecoverPendingPurchases(BuildContext context) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Restore the cached original purchase token (used for upgrade while
//       // a deferred downgrade is pending).
//       _originalPurchaseToken ??= prefs.getString(_originalPurchaseTokenKey);

//       final pendingJson = prefs.getString(_pendingPurchaseKey);
//       if (pendingJson == null) return;

//       print('🔄 Found pending purchase — attempting recovery...');
//       final data = jsonDecode(pendingJson) as Map<String, dynamic>;
//       final platform = data['platform'] as String;
//       final productId = data['productId'] as String;
//       final purchaseToken = data['serverVerificationData'] as String;
//       final childIds = List<String>.from(data['childIds'] ?? []);

//       if (childIds.isEmpty) {
//         print('⚠️ Pending purchase has no childIds — clearing');
//         await _clearPendingPurchase();
//         return;
//       }

//       // Restore child selection for save
//       selectedChildIds = childIds;

//       // Retry: verify → save → clear
//       final verified = await verifyPurchaseWithBackend(
//         platform: platform,
//         productId: productId,
//         purchaseToken: purchaseToken,
//         orderId: data['purchaseId'],
//       );

//       if (verified) {
//         await _clearPendingPurchase();
//         showToast(message: 'Pending subscription activated!');
//       } else {
//         print('⚠️ Pending purchase verification failed — will retry next open');
//       }
//     } catch (e) {
//       print('❌ Pending purchase recovery error: $e');
//     }
//   }

//   bool isLoading = false;

//   void setLoading(bool loading) {
//     isLoading = loading;
//     notifyListeners();
//   }

//   int? lastSubscriptionApiFetchTime;
//   String? cachedSubscriptionChildId;

//   getSubscriptionListApi(BuildContext context, String childId) async {
//     final currentTime = DateTime.now().millisecondsSinceEpoch;
//     if (lastSubscriptionApiFetchTime != null &&
//         cachedSubscriptionChildId == childId &&
//         (currentTime - lastSubscriptionApiFetchTime!) <
//             AppConst.reAppHitApiCall &&
//         getSubscriptionDataList.isNotEmpty) {
//       return;
//     }

//     lastSubscriptionApiFetchTime = currentTime;
//     cachedSubscriptionChildId = childId;

//     _kProductIds.clear();
//     try {
//       context.loaderOverlay.show();
//       final GetSubscriptionModel response =
//           await AppApi.getSubscriptionListApi();
//       if (response.apiStatus == Status.success) {
//         getSubscriptionDataList = response.getSubscriptionData ?? [];
//         subscriptionsLoaded = true;
//       }
//       for (int i = 0; i < getSubscriptionDataList.length; i++) {
//         // Use platform-specific product ID for store queries
//         final storeId = Platform.isIOS
//             ? getSubscriptionDataList[i].subscriptionAppleId
//             : getSubscriptionDataList[i].subscriptionAndroidId;
//         print("store id ---> $storeId (${Platform.isIOS ? 'iOS' : 'Android'})");
//         if (storeId != null && storeId.isNotEmpty) {
//           _kProductIds.add(storeId);
//         }
//       }
//       notifyListeners();
//     } catch (e) {
//       print('getSubscriptionList Api api error---> ${e}');
//       throw e;
//     } finally {
//       if (context.mounted) {
//         context.loaderOverlay.hide();
//       }
//     }
//   }

//   int? lastChildrensListApiFetchTime;

//   Future<void> childrensListApi(
//     BuildContext context,
//   ) async {
//     final currentTime = DateTime.now().millisecondsSinceEpoch;
//     if (lastChildrensListApiFetchTime != null &&
//         (currentTime - lastChildrensListApiFetchTime!) <
//             AppConst.reAppHitApiCall &&
//         childrenAllListData.isNotEmpty) {
//       return;
//     }

//     lastChildrensListApiFetchTime = currentTime;

//     childrenAllListData.clear();
//     try {
//       context.loaderOverlay.show();
//       final ChildrenListModel response = await AppApi.childrensListApi();
//       if (response.apiStatus == Status.success) {
//         childrenAllListData = response.childrenListData?.children ?? [];
//         subscriptionsLoaded = true;
//       }
//       notifyListeners();
//     } catch (e) {
//       print('childrensListApi error---> ${e}');
//       throw e;
//     } finally {
//       if (context.mounted) {
//         context.loaderOverlay.hide();
//       }
//     }
//   }

//   /// Selection state
//   String? selectedSubscriptionId;
//   void selectSubscription(String? id) {
//     if (selectedSubscriptionId == id) {
//       // toggle off if same selected again (optional). Remove this line if persistent selection desired
//       selectedSubscriptionId = id; // keep selection (no toggle off)
//     } else {
//       selectedSubscriptionId = id;
//     }
//     notifyListeners();
//   }

//   ProductDetails? get selectedProductDetails => selectedSubscriptionId == null
//       ? null
//       : getApiSubscription(selectedSubscriptionId!);

//   ProductDetails? getApiSubscription(String id) {
//     return productDetailsGloble
//         ?.firstWhereOrNull((element) => element.id.contains(id));
//   }
// }

// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }

//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }

// /// Purchase action determined by pre-purchase conflict check.
// /// Used by [SubscriptionProvider.determinePurchaseAction] to decide
// /// the appropriate UI and purchase path.
// enum PurchaseAction {
//   /// No existing subscription — standard purchase flow
//   freshPurchase,

//   /// Existing subscription with lower sortOrder — upgrade flow
//   upgrade,

//   /// Existing subscription with higher sortOrder — downgrade flow
//   downgrade,

//   /// Already on the exact same plan — disable button
//   alreadyOnSamePlan,

//   /// Active subscription on a different platform (iOS vs Android)
//   /// Cannot purchase — must cancel on other platform first
//   crossPlatformConflict,

//   /// Another child in the account already has an active subscription.
//   /// Parent must select both/all children to upgrade to a multi-child plan.
//   multiChildRequired,

//   /// A subscription change (upgrade/downgrade) is already scheduled.
//   /// Further changes are blocked until the next renewal to avoid store errors.
//   pendingChangeScheduled,

//   /// User is upgrading to a higher-tier plan while a deferred downgrade is
//   /// already pending. Google Play will cancel the pending downgrade and apply
//   /// the upgrade immediately against the currently-active purchase token.
//   upgradeReplacingPendingDowngrade,
// }
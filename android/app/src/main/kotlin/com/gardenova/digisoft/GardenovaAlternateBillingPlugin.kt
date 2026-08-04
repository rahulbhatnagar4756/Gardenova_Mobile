package com.gardenova.digisoft

import android.app.Activity
import android.util.Log
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.PendingPurchasesParams
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Google Play alternate billing bridge for Razorpay subscriptions.
 *
 * Required when distributing on Play Store while using an external billing
 * provider such as Razorpay instead of Google Play Billing.
 */
class GardenovaAlternateBillingPlugin(
    private val activity: Activity,
) : MethodChannel.MethodCallHandler {

    private var billingClient: BillingClient? = null
    private var isPrepared = false

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "prepareAlternateBilling" -> prepareAlternateBilling(result)
            "getExternalTransactionToken" -> getExternalTransactionToken(result)
            "dispose" -> {
                billingClient?.endConnection()
                billingClient = null
                isPrepared = false
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun withBillingClient(
        onReady: (BillingClient) -> Unit,
        onError: (String, String?, Int) -> Unit,
    ) {
        val existingClient = billingClient
        if (existingClient != null && existingClient.isReady) {
            onReady(existingClient)
            return
        }

        existingClient?.endConnection()
        val client = BillingClient.newBuilder(activity.applicationContext)
            .enablePendingPurchases(
                PendingPurchasesParams.newBuilder()
                    .enableOneTimeProducts()
                    .build(),
            )
            .enableAlternativeBillingOnly()
            .build()

        billingClient = client
        client.startConnection(
            object : BillingClientStateListener {
                override fun onBillingSetupFinished(billingResult: BillingResult) {
                    if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                        onReady(client)
                    } else {
                        onError(
                            "BILLING_SETUP_FAILED",
                            billingResult.debugMessage,
                            billingResult.responseCode,
                        )
                    }
                }

                override fun onBillingServiceDisconnected() {
                    Log.w(TAG, "Billing service disconnected")
                }
            },
        )
    }

    private fun prepareAlternateBilling(result: MethodChannel.Result) {
        if (isPrepared) {
            result.success(
                mapOf(
                    "prepared" to true,
                    "available" to true,
                    "skipped" to true,
                ),
            )
            return
        }

        withBillingClient(
            onReady = { client ->
                client.isAlternativeBillingOnlyAvailableAsync { availabilityResult ->
                    if (availabilityResult.responseCode != BillingClient.BillingResponseCode.OK) {
                        result.success(
                            mapOf(
                                "prepared" to false,
                                "available" to false,
                                "responseCode" to availabilityResult.responseCode,
                            ),
                        )
                        return@isAlternativeBillingOnlyAvailableAsync
                    }

                    activity.runOnUiThread {
                        client.showAlternativeBillingOnlyInformationDialog(activity) { dialogResult ->
                            if (dialogResult.responseCode == BillingClient.BillingResponseCode.OK) {
                                isPrepared = true
                                result.success(
                                    mapOf(
                                        "prepared" to true,
                                        "available" to true,
                                    ),
                                )
                            } else {
                                result.success(
                                    mapOf(
                                        "prepared" to false,
                                        "available" to true,
                                        "responseCode" to dialogResult.responseCode,
                                    ),
                                )
                            }
                        }
                    }
                }
            },
            onError = { code, message, responseCode ->
                result.error(code, message, responseCode)
            },
        )
    }

    private fun getExternalTransactionToken(result: MethodChannel.Result) {
        withBillingClient(
            onReady = { client ->
                client.createAlternativeBillingOnlyReportingDetailsAsync { billingResult, details ->
                    if (billingResult.responseCode == BillingClient.BillingResponseCode.OK &&
                        details != null
                    ) {
                        result.success(
                            mapOf(
                                "token" to details.externalTransactionToken,
                                "responseCode" to billingResult.responseCode,
                            ),
                        )
                    } else {
                        result.success(
                            mapOf(
                                "token" to "",
                                "responseCode" to billingResult.responseCode,
                            ),
                        )
                    }
                }
            },
            onError = { code, message, responseCode ->
                result.error(code, message, responseCode)
            },
        )
    }

    companion object {
        private const val TAG = "AlternateBilling"
        private const val CHANNEL = "com.gardenova.digisoft/alternate_billing"

        fun register(messenger: BinaryMessenger, activity: Activity) {
            MethodChannel(messenger, CHANNEL).setMethodCallHandler(
                GardenovaAlternateBillingPlugin(activity),
            )
        }
    }
}

#########################################
# Razorpay
#########################################

-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }


-keep class com.dexterous.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }

#########################################
# Google Mobile Ads
#########################################

-keep class com.google.android.gms.ads.** { *; }
-keep public class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

#########################################
# Flutter
#########################################

-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

#########################################
# Firebase
#########################################

-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

#########################################
# Facebook SDK
#########################################

-keep class com.facebook.** { *; }
-dontwarn com.facebook.**

#########################################
# Google Play Billing (alternate billing)
#########################################

-keep class com.android.billingclient.** { *; }
-dontwarn com.android.billingclient.**


-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

#########################################
# Jumio
#########################################

-keep class io.flutter.embedding.android.FlutterActivity
-keep class io.flutter.embedding.android.FlutterEngineProvider

-keep class com.jumio.** { *; }
-keep class jumio.** { *; }

# ConstraintLayout MotionLayout
-keep class androidx.constraintlayout.motion.widget.** { *; }

#########################################
# Microblink
#########################################

-keep class com.microblink.** { *; }
-keep class com.microblink.**$* { *; }

-dontwarn com.microblink.**

#########################################
# JMRTD / NFC / Passport
#########################################

-keep class org.jmrtd.** { *; }
-keep class net.sf.scuba.** { *; }
-keep class org.bouncycastle.** { *; }
-keep class org.ejbca.** { *; }

-dontwarn org.ejbca.**
-dontwarn org.bouncycastle.**
-dontwarn org.codehaus.**

#########################################
# Java / Nullable
#########################################

-dontwarn java.nio.**
-dontwarn javax.annotation.Nullable
-dontwarn module-info



# Gardenova push notification bridge
-keep class com.gardenova.digisoft.** { *; }

## Gson rules
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
#-keep class com.google.gson.stream.** { *; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**
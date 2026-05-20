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
# Google Play / Feature Delivery
#########################################

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
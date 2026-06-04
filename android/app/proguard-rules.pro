# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Cliceat
-keep class cm.cliceat.app.** { *; }

# Drift
-keep class androidx.room.db.** { *; }

# Retrofit / Chopper / Dio
-keep class retrofit2.** { *; }
-keep class chopper.** { *; }
-keepattributes Signature
-keepattributes Exceptions
-keepattributes *Annotation*

# Serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
    @freezed <fields>;
    @JsonKey <fields>;
}

# Ignore warnings
-dontwarn javax.annotation.**
-dontwarn retrofit2.Platform$Java8

# Play Core (Deferred components / SplitCompat)
-dontwarn com.google.android.play.core.**

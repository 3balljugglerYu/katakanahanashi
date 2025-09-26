# Flutter用のProGuardルール

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Dart/Flutter関連
-dontwarn io.flutter.**
-dontwarn androidx.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Riverpod
-keep class * extends com.riverpod.** { *; }

# JSON関連（json_annotationを使用している場合）
-keepattributes *Annotation*
-keepclassmembers,allowobfuscation class * {
  @com.fasterxml.jackson.annotation.JsonProperty <fields>;
}

# Kotlinリフレクション
-keep class kotlin.reflect.jvm.internal.** { *; }
-keep class kotlin.Metadata { *; }

# アプリ固有のモデルクラス（必要に応じて追加）
-keep class com.katakana.hanashi.katakanahanashi.** { *; }

# 一般的な最適化ルール
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose

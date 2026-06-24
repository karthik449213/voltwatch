# Keep WorkManager internal implementations intact
-keep class androidx.work.impl.WorkDatabase_impl { *; }
-dontwarn androidx.work.impl.WorkDatabase_impl

# Protect the workmanager flutter plugin background structures
-keep  class pruthvi.gireesh.workmanager.** { *; }

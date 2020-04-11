# Partido Client
Client App for Partido written in Flutter/Dart.

## Developer information

Recompile generated code (API, Domain model) with following command:

```flutter pub run build_runner build```

Or use this command to continuously regenerate the code if files are changed:

```flutter pub run build_runner watch```

### Release

To prepare a release, adjust the marked entries in the file `<partido-project>/android/app/build.gradle`:

```
    compileSdkVersion 29                                # <-- set to latest SDK

    ...

    defaultConfig {
        applicationId "net.fosforito.partido"
        minSdkVersion 24                                # <-- (optional, if needed)
        targetSdkVersion 29                             # <-- set to latest SDK
        versionCode 4                                   # <-- increment every release by 1 
        versionName "2.0.0"                             # <-- increment every release pendinng on changes
        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
    }
```

To create a release, you need to specify the upload key's credentials and the keystore location details in a file named `key.properties` inside the `<partido-project>/android/` folder with the following contents:

```
storePassword=xyz                   # password of keystore
keyPassword=xyz                     # password of key
keyAlias=key0                       # alias of key
storeFile=../../../keystore.jks     # location of keystore (relative to <partido-project>/android/app/build.gradle)
```

This file (and the upload key / keystore) should not be uploaded to the git repository! .git-ignore contains an entry for `android/key.properties`.

### Icons

Icons are generated with the flutter_launcher_icons plugin.
See [[https://pub.dev/packages/flutter_launcher_icons]] for detailed usage information.

The configuration of the plugin can be found in the `pubspec.yaml` file and the media file to be used for generation should be put in the `<partido-project>/assets/images` folder.

The command to re-generate all icons, using the image files specified in the previous configuration, is:

```flutter pub run flutter_launcher_icons:main```

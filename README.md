# Android Hello World App

This repository contains a simple Android "Hello World" application built using the Codespaces Android SDK CE (Community Edition) environment.

## App Description

This is a minimal Android application that displays "Hello World!" text centered on the screen. The app demonstrates:
- Basic Android application structure
- Simple UI layout with ConstraintLayout
- Standard Android project organization with Gradle

## Engineering Decisions

Several key engineering decisions were made in creating this app:

1. **Build System**: Gradle was chosen as the build system (version 8.0) because it's the standard for Android development and provides powerful dependency management.

2. **SDK Versions**:
   - Target SDK: 33 (Android 13) - Using the latest stable Android version for optimal features
   - Minimum SDK: 21 (Android 5.0 Lollipop) - Providing compatibility with approximately 98% of devices in use

3. **UI Framework**: 
   - AndroidX libraries are used instead of the older support libraries
   - ConstraintLayout for flexible, responsive UI design
   - Material Design components for modern UI elements

4. **Project Structure**:
   - Standard Android project structure with clear separation of resources and code
   - Conventional package naming (com.example.helloworld)

5. **Dependencies**:
   - androidx.appcompat:appcompat:1.6.1 - For backward compatibility
   - androidx.constraintlayout:constraintlayout:2.1.4 - For modern layouts
   - com.google.android.material:material:1.9.0 - For Material Design components

## Building the App

To build the application:

1. Ensure you have the Android SDK installed (provided by the Codespace)
2. Initialize the Gradle wrapper if it doesn't exist:
   ```bash
   gradle wrapper
   ```
3. Make the Gradle wrapper executable:
   ```bash
   chmod +x gradlew
   ```
4. Build the debug APK:
   ```bash
   ./gradlew assembleDebug
   ```
5. The APK will be generated at:
   ```
   app/build/outputs/apk/debug/app-debug.apk
   ```

## Testing the App

To test the application:

1. **On a physical device**:
   - Enable USB debugging on your Android device
   - Connect it to your development machine
   - Install the app:
     ```bash
     adb install app/build/outputs/apk/debug/app-debug.apk
     ```

2. **On an emulator**:
   - Create and start an Android Virtual Device (AVD)
   - Install the app:
     ```bash
     adb install app/build/outputs/apk/debug/app-debug.apk
     ```

3. **Automated testing** (not implemented in this basic app):
   - Unit tests would go in `app/src/test/`
   - Instrumentation tests would go in `app/src/androidTest/`

## Development Environment

This project uses a GitHub Codespace configured with Android development tools.

### Installed Software

* Ubuntu
* Bazelisk
* Gradle
* Maven
* Ant
* Meson
* Java 23 (Oracle)
* Android SDK

### Usage

This repository can be used to create a codespace,
by using it as a template for new projects, or
including it as a submodule in an existing project.

To import as a submodule use 'git submodule add'

```bash
git submodule add https://github.com/raymond-chetty/codespaces-AndroidSDK-CE .devcontainer
```

In theory it is possible to add access to additional
repositories within a codespace using 'customizations'

* https://containers.dev/supporting#github-codespaces
* https://docs.github.com/en/codespaces/managing-your-codespaces/managing-repository-access-for-your-codespaces

## Extending the App

This basic app can be extended by:
1. Adding more UI components in `app/src/main/res/layout/activity_main.xml`
2. Adding functionality in `app/src/main/java/com/example/helloworld/MainActivity.java`
3. Adding more activities or fragments as needed
4. Implementing data persistence with Room database
5. Adding network capabilities with Retrofit or Volley

## Project Structure

```
app/
├── build.gradle           # App-level build configuration
├── src/
    ├── main/
        ├── AndroidManifest.xml  # App declaration and components
        ├── java/
        │   └── com/example/helloworld/
        │       └── MainActivity.java  # Main activity code
        └── res/
            ├── layout/
            │   └── activity_main.xml  # UI layout
            └── values/
                ├── colors.xml    # Color definitions
                ├── strings.xml   # String resources
                └── themes.xml    # App theme
```

## Known Issues and Limitations

- The app lacks launcher icons (uses Android default)
- No dark mode theme implementation
- No localization for languages other than English

## devcontainer.json

The original devcontainer.json file was created using the
VS Code [codespaces configuration wizard][1].

Press "F1" or "Ctr + Shift + P" in [VS Code Codespaces][2]
and select "Codespaces: Add Dev Container Configuration Files...".

## Additional information

Additional information about [VS Code][3], the [UI][4],
[Dev Containers][5] and [VS Code Dev Containers][6] ([Extension][7])
is available online. Devcontainers are available on the most
common operating systems and the web ([1][8] & [2][9])!

For Android development resources:
- [Android Developer Documentation](https://developer.android.com/docs)
- [Android Studio User Guide](https://developer.android.com/studio/intro)
- [Android API Reference](https://developer.android.com/reference)

[1]: https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers#using-a-predefined-dev-container-configuration
[2]: https://code.visualstudio.com/docs/remote/codespaces
[3]: https://code.visualstudio.com/
[4]: https://code.visualstudio.com/docs/getstarted/userinterface
[5]: https://containers.dev/
[6]: https://code.visualstudio.com/docs/devcontainers/containers
[7]: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
[8]: https://github.com/features/codespaces
[9]: https://docs.github.com/en/codespaces/



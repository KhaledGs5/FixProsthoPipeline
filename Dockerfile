# Start from a base image with Flutter
FROM cirrusci/flutter:latest

# Set environment variables for Android and Windows SDKs
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools"
ENV FLUTTER_HOME=/flutter
ENV PATH="$PATH:${FLUTTER_HOME}/bin"

# Install additional dependencies for Android and Windows builds
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip curl git zip lib32stdc++6 libglu1-mesa xz-utils \
    clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" \
    "build-tools;33.0.0" "ndk;21.1.6352462" "cmdline-tools;latest" && \
    flutter doctor --android-licenses

# Install Windows support (for Linux and Windows host environments)
RUN flutter config --enable-windows-desktop

# Install iOS dependencies (if running on macOS)
# Comment this section out if you are not on a macOS environment
RUN flutter config --enable-ios && \
    brew install --cask xcodegen && \
    xcodegen && \
    flutter doctor

# Copy project files into the Docker container
WORKDIR /app
COPY . .

# Install Flutter dependencies
RUN flutter pub get

# Pre-download any Flutter artifacts for the current environment
RUN flutter precache --android --ios --windows

# Run `flutter doctor` to verify setup
RUN flutter doctor

# Expose any necessary ports (for web or local development)
EXPOSE 8080

# Default command to keep the container running, use 'docker exec' to enter and run commands
CMD ["sleep", "infinity"]

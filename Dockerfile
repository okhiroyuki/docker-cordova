FROM mcr.microsoft.com/devcontainers/javascript-node:1-18 AS java

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get -y install openjdk-17-jdk-headless --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    java -version

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

FROM java AS android

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" \
    ANDROID_BUILD_TOOLS_VERSION="33.0.2" \
    ANDROID_PLATFORM="android-33" \
    NDK_VERSION="24.0.8215888" \
    CMAKE_VERSION="3.22.1" \
    GRADLE_VERSION="7.3.3" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_SDK_ROOT="/opt/android" \
    ANDROID_HOME="/opt/android"

ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$GRADLE_HOME/bin

WORKDIR /opt

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl gradle && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR $ANDROID_SDK_ROOT
RUN wget -qO tools.zip $ANDROID_SDK_URL && \
    unzip tools.zip && rm tools.zip

WORKDIR $ANDROID_SDK_ROOT/cmdline-tools
# hadolint ignore=SC2010,DL4006
RUN mkdir latest && \
    ls | grep -v latest | xargs mv -t latest

# hadolint ignore=DL4006
RUN mkdir /root/.android && touch /root/.android/repositories.cfg && \
    while true; do echo 'y'; sleep 2; done | sdkmanager \
    "platform-tools" \
    "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
    "ndk-bundle" \
    "platforms;$ANDROID_PLATFORM" \
    "ndk;$NDK_VERSION" \
    "cmake;$CMAKE_VERSION"

RUN chmod a+x -R $ANDROID_SDK_ROOT && \
    chown -R root:root $ANDROID_SDK_ROOT && \
    rm -rf /opt/android/licenses && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean && \
    gradle -v && java -version

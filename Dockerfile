FROM debian:13 AS setup

ARG TARGETARCH
ARG CHANNEL=latest
ENV IBC_VERSION=3.22.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates git libxtst6 libgtk-3-0 openbox procps python3 socat tigervnc-standalone-server unzip wget2 xterm \
    libasound2 \
    libnss3 \
    libgbm1 \
    libnspr4

# Setup noVNC for browser VNC access
RUN git clone --depth 1 https://github.com/novnc/noVNC.git && \
    chmod +x ./noVNC/utils/novnc_proxy && \
    git clone --depth 1 https://github.com/novnc/websockify.git /noVNC/utils/websockify

# Override default noVNC file listing
COPY image-files/index.html /noVNC

# Download and setup IBC
RUN wget2 https://github.com/IbcAlpha/IBC/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip -O ibc.zip \
    && unzip ibc.zip -d /opt/ibc \
    && rm ibc.zip

# Download and install IB Gateway (arch-aware)
RUN case "$TARGETARCH" in \
      amd64)  ARCH_SUFFIX="x64" ;; \
      arm64)  ARCH_SUFFIX="arm" ;; \
      *)      echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    INSTALL_FILENAME="ibgateway-${CHANNEL}-standalone-linux-${ARCH_SUFFIX}.sh" && \
    wget2 "https://download2.interactivebrokers.com/installers/ibgateway/${CHANNEL}-standalone/${INSTALL_FILENAME}" \
        -O "$INSTALL_FILENAME" && \
    chmod +x "$INSTALL_FILENAME" && \
    yes '' | "./$INSTALL_FILENAME" && \
    rm "$INSTALL_FILENAME"

# Copy scripts
COPY image-files/start.sh image-files/replace.sh /

RUN mkdir -p ~/ibc && mv /opt/ibc/config.ini ~/ibc/config.ini

RUN chmod a+x ./*.sh /opt/ibc/*.sh /opt/ibc/scripts/*.sh

CMD [ "/start.sh" ]
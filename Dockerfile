# Usa una imagen base de Debian o Ubuntu
FROM debian:latest

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instala Docker dentro del contenedor para gestionar BTCPay Server
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io

# Clona el repositorio de BTCPay Server
RUN git clone https://github.com/btcpayserver/btcpayserver-docker.git /btcpayserver

# Define las variables de entorno
ARG BTCPAY_HOST
ARG NBITCOIN_NETWORK
ARG BTCPAYGEN_CRYPTO1
ARG BTCPAYGEN_REVERSEPROXY
ARG BTCPAYGEN_LIGHTNING
ARG BTCPAY_ENABLE_SSH
ARG LETSENCRYPT_EMAIL
ARG LIGHTNING_ALIAS
ARG BTCPAYGEN_ADDITIONAL_FRAGMENTS
ARG REVERSEPROXY_HTTP_PORT
ARG REVERSEPROXY_HTTPS_PORT

ENV BTCPAY_HOST=${BTCPAY_HOST}
ENV NBITCOIN_NETWORK=${NBITCOIN_NETWORK}
ENV BTCPAYGEN_CRYPTO1=${BTCPAYGEN_CRYPTO1}
ENV BTCPAYGEN_REVERSEPROXY=${BTCPAYGEN_REVERSEPROXY}
ENV BTCPAYGEN_LIGHTNING=${BTCPAYGEN_LIGHTNING}
ENV BTCPAY_ENABLE_SSH=${BTCPAY_ENABLE_SSH}
ENV LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}
ENV LIGHTNING_ALIAS=${LIGHTNING_ALIAS}
ENV BTCPAYGEN_ADDITIONAL_FRAGMENTS=${BTCPAYGEN_ADDITIONAL_FRAGMENTS}
ENV REVERSEPROXY_HTTP_PORT=${REVERSEPROXY_HTTP_PORT}
ENV REVERSEPROXY_HTTPS_PORT=${REVERSEPROXY_HTTPS_PORT}

# Ejecuta el setup de BTCPay Server durante la construcción
RUN /btcpayserver/btcpay-setup.sh

# Define el directorio de trabajo y permisos de ejecución
WORKDIR /btcpayserver
RUN chmod +x ./btcpay-setup.sh

# Comando de inicio
ENTRYPOINT ["./btcpay-setup.sh"]




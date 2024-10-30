# Usa una imagen base de Debian o Ubuntu
FROM debian:latest

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Instala Docker dentro del contenedor para gestionar BTCPay Server
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io

# Clona el repositorio de BTCPay Server
RUN git clone https://github.com/btcpayserver/btcpayserver-docker.git /btcpayserver

# Define las variables de entorno
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

# Ejecuta el setup de BTCPay Server
WORKDIR /btcpayserver
RUN chmod +x btcpay-setup.sh
ENTRYPOINT [ "./btcpay-setup.sh" ]

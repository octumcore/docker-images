FROM  tensorflow/tensorflow:2.6.0

RUN  apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm -f packages-microsoft-prod.deb

RUN apt-get update

RUN apt-get install -y aspnetcore-runtime-5.0 libgdiplus apparmor openssl systemd nettle-bin libglib2.0-0 nghttp2 libldap-common p11-kit curl

# SDK only needed for SSL certificate and should be removed after we or the customer provide a certificate.
RUN apt-get install -y dotnet-sdk-5.0=5.0.401-1 \
    && dotnet dev-certs https

# dependencies for python train script execution
RUN pip install pandas sklearn psutil
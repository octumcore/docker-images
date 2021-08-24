FROM  tensorflow/tensorflow:2.3.0-gpu

RUN  apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm -f packages-microsoft-prod.deb

RUN apt-get update

# Fix vulnerable packages and install aspnetcore
RUN apt-get install -y apparmor openssl systemd nettle-bin libglib2.0-0 nghttp2 libldap-common p11-kit curl \
    && apt-get install -y aspnetcore-runtime-3.1

# SDK only needed for SSL certificate and should be removed after we or the customer provide a certificate.
RUN apt-get install -y dotnet-sdk-3.1=3.1.410-1 \
    && dotnet dev-certs https

# dependencies for python train script execution
RUN pip install pandas sklearn psutil
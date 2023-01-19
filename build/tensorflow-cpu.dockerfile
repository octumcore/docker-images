FROM  tensorflow/tensorflow:2.7.0

RUN  apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm -f packages-microsoft-prod.deb

RUN apt-get update

RUN apt-get install -y aspnetcore-runtime-7.0 libgdiplus apparmor openssl systemd nettle-bin libglib2.0-0 nghttp2 libldap-common p11-kit curl

# SDK only needed for SSL certificate and should be removed after we or the customer provide a certificate.
RUN apt-get install -y dotnet-sdk-7.0=7.0.102 \
    && dotnet dev-certs https

# dependencies for python train script execution
RUN python3 -m pip install pip
RUN pip3 install sklearn scikit-image pandas psutil


######## START - mvIMPACT Acquire
# Set environment variables
ENV MVIMPACT_ACQUIRE_DIR /opt/mvIMPACT_Acquire
ENV MVIMPACT_ACQUIRE_DATA_DIR /opt/mvIMPACT_Acquire/data
ENV GENICAM_GENTL64_PATH /opt/mvIMPACT_Acquire/lib/x86_64
ENV GENICAM_ROOT /opt/mvIMPACT_Acquire/runtime

# update packets and install minimal requirements
# after installation it will clean apt packet cache

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y iproute2
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# move the directory mvIMPACT_Acquire with *.tgz and *.sh files to the container
COPY ./misc/mvIMPACT_Acquire /var/lib/mvIMPACT_Acquire

# execute the setup script in an unattended mode
RUN cd /var/lib/mvIMPACT_Acquire && \
  ./install_mvGenTL_Acquire.sh -u --minimal -gev && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -rf /var/lib/mvIMPACT_Acquire
######## END - mvIMPACT Acquire
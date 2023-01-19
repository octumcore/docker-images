FROM  tensorflow/tensorflow:2.7.0

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN  apt-get update \
    && apt-get install -y wget git curl gnupg\
    && rm -rf /var/lib/apt/lists/*

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs

RUN npm install -g @angular/cli@8.3.26

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt-get update \
    && apt-get install -y apt-transport-https aspnetcore-runtime-7.0 ffmpeg libsm6 libxext6 libgdiplus

RUN python3 -m pip install pip
RUN pip3 install matplotlib Pillow sklearn scikit-image pandas psutil neural-structured-learning==1.1.0 opencv_python

# Install dotnet sdk
RUN apt-get install -y dotnet-sdk-7.0=7.0.102-1 \
    && dotnet dev-certs https

# Install chrome (needed for unit tests)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
RUN rm -f google-chrome-stable_current_amd64.deb

# Create Octum shared folder with user permissions
RUN mkdir -p /usr/share/Octum \
    && chown ${USERNAME} /usr/share/Octum

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


USER $USERNAME
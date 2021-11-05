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
    && apt-get install -y apt-transport-https aspnetcore-runtime-5.0 ffmpeg libsm6 libxext6 libgdiplus

RUN python3 -m pip install pip
RUN pip3 install matplotlib Pillow sklearn scikit-image pandas psutil neural-structured-learning==1.1.0 opencv_python

# Install dotnet sdk
RUN apt-get install -y dotnet-sdk-5.0=5.0.401-1 \
    && dotnet dev-certs https

# Install chrome (needed for unit tests)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable

# Create Octum shared folder with user permissions
RUN mkdir -p /usr/share/Octum \
    && chown ${USERNAME} /usr/share/Octum

USER $USERNAME
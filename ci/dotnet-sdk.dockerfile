FROM  mcr.microsoft.com/dotnet/sdk:6.0.401-focal
# do not use 7.0.102-jammy image from microsoft, because ubuntu 22.04 does only support .NET 6+ runtime/sdks
# for babel obfuscation we need dotnet runtime 3.1

# install the report generator tool
RUN dotnet tool install dotnet-reportgenerator-globaltool --version 5.1.14 --tool-path /tools

# install old runtime for babel
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update \
    && apt-get install -y apt-transport-https aspnetcore-runtime-3.1 

# install dotnet sdk 7.0
RUN apt-get install -y dotnet-sdk-7.0=7.0.102-1 \
    && dotnet dev-certs https

# install nodejs
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_18.x  | bash -
RUN apt-get -y install nodejs

# install chrome (needed for unit tests)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
RUN rm -f google-chrome-stable_current_amd64.deb

RUN apt-get install -y libgdiplus
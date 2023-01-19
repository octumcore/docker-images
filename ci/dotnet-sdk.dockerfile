FROM  mcr.microsoft.com/dotnet/sdk:7.0.102-jammy

# install the report generator tool
RUN dotnet tool install dotnet-reportgenerator-globaltool --version 5.1.14 --tool-path /tools

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
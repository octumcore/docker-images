FROM  mcr.microsoft.com/dotnet/core/sdk:3.1.410-focal

# install the report generator tool
RUN dotnet tool install dotnet-reportgenerator-globaltool --version 4.6.5 --tool-path /tools

# install nodejs
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs

# install chrome (needed for unit tests)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
RUN rm -f google-chrome-stable_current_amd64.deb
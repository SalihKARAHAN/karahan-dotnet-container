FROM debian:jessie

# update os
RUN apt-get update
RUN apt-get upgrade

# install .net core https://www.microsoft.com/net/core#linuxdebian
RUN apt-get --yes install curl libunwind8 gettext
RUN curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?LinkID=835021
RUN mkdir -p /opt/dotnet && tar zxf dotnet.tar.gz -C /opt/dotnet 
RUN ln -s /opt/dotnet/dotnet /usr/local/bin

# fixing 'Failed to initialize CoreCLR, HRESULT: 0x80131500' error
# install wget package
RUN apt-get --yes install wget
RUN mkdir rqpkg
WORKDIR rqpkg
RUN wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu52_52.1-3ubuntu0.4_amd64.deb
RUN dpkg -i libicu52_52.1-3ubuntu0.4_amd64.deb
WORKDIR ..
RUN rm -r rqpkg

# test dotnet helloworld
RUN mkdir _test
WORKDIR _test
RUN dotnet --version
RUN dotnet new
RUN dotnet restore
RUN dotnet run
WORKDIR ..
RUN rm -r _test

# defaul 
CMD bin/bash
FROM ubuntu:16.04

ENV LAST_UPDATED_AT 2018-05-21

RUN apt-get update \
# install dependencies
    && apt-get install --no-install-recommends -y \
	lib32gcc1 \
	lib32stdc++6 \
	ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install SteamCMD
RUN mkdir /steamcmd 
WORKDIR /steamcmd
ADD https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz steamcmd_linux.tar.gz
RUN tar -zxvf steamcmd_linux.tar.gz

# Install TF2
RUN ./steamcmd.sh +login anonymous +force_install_dir /tf2 +app_update 232250 validate +quit

# Contains wrapper scripts and .cfg files
COPY containerfs /

# Fix for missing library
RUN mkdir /root/.steam/sdk32
RUN ln -s /steamcmd/linux32/steamclient.so /root/.steam/sdk32/steamclient.so

WORKDIR /tf2

CMD ["./start.sh"]

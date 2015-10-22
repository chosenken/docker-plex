FROM chosenken/base:latest
MAINTAINER chosenken@gmail.com

ENV REFRESHED_ON 10-21-2015
ENV PLEX_VER=0.9.12.14.1493-b925b67

RUN curl -o /tmp/plex.deb  https://downloads.plex.tv/plex-media-server/${PLEX_VER}/plexmediaserver_${PLEX_VER}_amd64.deb && \
    dpkg -i /tmp/plex.deb && \
    apt-get install -f && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME ["/config","/mnt/Downloads"]

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV RUN_AS_ROOT="true" \
    CHANGE_DIR_RIGHTS="false"

EXPOSE 32400

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

CMD ["/start.sh"]

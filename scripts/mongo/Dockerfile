FROM mongo:3.2.8
RUN mkdir /data/backups && chown -R mongodb:mongodb /data/backups
COPY init-cluster.sh /
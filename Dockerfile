FROM ubuntu:22.04
WORKDIR /setup
COPY script/ ./script/
RUN chmod +x ./script/*.sh
RUN cd script && ./main.sh
RUN rm -rf /var/lib/apt/lists/* && apt-get clean
ENTRYPOINT ["./script/05_start.sh"]

FROM grafana/grafana:latest

COPY monitoring /opt/braiins_monitoring
COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT []
CMD [ "/run.sh" ]

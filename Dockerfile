FROM elixir:1.2.4

MAINTAINER christian.froehlingsdorf <chris@5cf.de>
#RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/app
ADD  ./* /opt/app/

RUN rm -rf /opt/app/deps
RUN rm -f /opt/app/mix.lock
RUN rm -rf /opt/app/_build
RUN rm -rf /opt/app/.vscode
RUN rm -f /opt/app/.gitignore
RUN rm -f /opt/app/README.md

RUN chmod 777 /opt/app/deploy
WORKDIR /opt/app

RUN /opt/app/deploy

ENV MIX_ENV=prod
ENTRYPOINT [ "./run" ]
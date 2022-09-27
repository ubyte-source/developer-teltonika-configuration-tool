FROM amd64/alpine:3.16

ENV STARTUP_COMMAND_RUN_TELTONIKA="teltonika -F 10.20.90.254 -D 1" \
    TOOL="/app/tool" \
    TELTONIKA_FIRMWARE="https://wiki.teltonika-networks.com/wikibase/images/8/8f/RUT9_R_00.07.02.7_WEBUI.bin" \
    CAMELOT_EMAIL="teltonika@energia-europa.com" \
    CAMELOT_PASSWORD="mypassword" \
    FORTINET_USERNAME="root" \
    FORTINET_PASSWORD="root" \
    FORTINET_IP="127.0.0.1" \
    TELTONIKA_USERNAME="root" \
    TELTONIKA_PASSWORD="admin01" \
    MICROSERVICE_SENDGRID_DYNAMIC_TEMPLATE="https://sendgrid.energia-europa.com/api/mail/send/d-a5bdd745cbfe31927289580ac7c6881d" \
    MICROSERVICE_SENDGRID_SENDER="Liza the Teltonika Configurator" \
    MICROSERVICE_SENDGRID_FROM="liza@management.energia-europa.com" \
    MICROSERVICE_SENDGRID_TO="teltonika@energia-europa.com" \
    MICROSERVICE_SENDGRID_RECIVER="Network" \
    MICROSERVICE_SENDGRID_SUBJECT="Configurazione - %s"

ARG TIMEZONE="UTC"

RUN apk update && \
    apk add --no-cache curl ca-certificates bash jq openssh sshpass net-tools && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/* && \
    mkdir /app

COPY ./tool ${TOOL}
COPY ./teltonika /usr/bin/teltonika
COPY ./wrapper.sh /

RUN adduser -D -g router router && \
    chown -R router:router /app && \
    chmod +x -R ${TOOL} /usr/bin/teltonika /wrapper.sh && \
    cp /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "$TIMEZONE" > /etc/timezone && \
    mkdir /home/router/.ssh

USER router

COPY ./config /home/router/.ssh/config

ENTRYPOINT /wrapper.sh

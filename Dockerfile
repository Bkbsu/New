FROM ubuntu:latest

RUN apt update -y > /dev/null 2>&1 \
    && apt upgrade -y > /dev/null 2>&1 \
    && apt install locales ssh wget unzip -y > /dev/null 2>&1 \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
ARG NGROK_TOKEN
ENV NGROK_TOKEN="$NGROK_TOKEN"

RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1 \
    && unzip ngrok.zip \
    && echo "./ngrok config add-authtoken $NGROK_TOKEN && ./ngrok tcp 22 &>/dev/null &" >> /daxx.sh \
    && mkdir /run/sshd \
    && echo '/usr/sbin/sshd -D' >> /daxx.sh \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo root:bala|chpasswd

COPY sshd_config /etc/ssh/sshd_config

EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306 7800 888 20 21

CMD ["/daxx.sh"]

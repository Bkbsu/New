FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache locales openssh wget unzip

# Set locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ARG NGROK_TOKEN
ENV NGROK_TOKEN=${NGROK_TOKEN}

# Download and install Ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok.zip && \
    rm ngrok.zip && \
    echo "./ngrok authtoken ${NGROK_TOKEN}" >> /daxx.sh && \
    echo "./ngrok tcp 22 &>/dev/null &" >> /daxx.sh && \
    mkdir /run/sshd && \
    echo '/usr/sbin/sshd -D' >> /daxx.sh && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo root:bala | chpasswd && \
    service ssh start && \
    chmod 755 /daxx.sh

EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

CMD ["/daxx.sh"]

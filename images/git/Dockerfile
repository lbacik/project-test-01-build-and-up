FROM alpine

ARG HOST
ARG PORT

COPY conf/ssh_key_rsa /root/.ssh/id_rsa

RUN apk add git openssh-client
RUN chmod 400 /root/.ssh/id_rsa

RUN ssh-keyscan -p ${PORT} ${HOST} >> /root/.ssh/known_hosts

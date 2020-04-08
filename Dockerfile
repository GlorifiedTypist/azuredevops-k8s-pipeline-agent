FROM ubuntu:18.04

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.06.3-ce
ENV UBUNTU_VERSION 18.04
ENV VSTS_AGENT_VERSION 2.166.1
ENV DOCKER_COMPOSE_VERSION 1.25.4

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
   && apt-get install -y curl vim git ca-certificates liblttng-ust0 libkrb5-3 zlib1g libcurl4 libssl1.1 libicu60 \
   && rm -rf /var/lib/apt/lists/*

RUN set -ex \
   && curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/`uname -m`/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
   && tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin \
   && rm docker.tgz \
   && docker -v

RUN set -x \
   && curl -fSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`" -o /usr/local/bin/docker-compose \
   && chmod +x /usr/local/bin/docker-compose \
   && docker-compose -v

RUN mkdir -p /opt/vsts

RUN curl "https://vstsagentpackage.azureedge.net/agent/${VSTS_AGENT_VERSION}/vsts-agent-linux-x64-${VSTS_AGENT_VERSION}.tar.gz" > vsts-agent-linux-x64.tar.gz \
   && tar -xzf vsts-agent-linux-x64.tar.gz -C /opt/vsts/ \
   && rm vsts-agent-linux-x64.tar.gz

WORKDIR /opt/vsts

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]

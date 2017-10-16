FROM debian:stretch-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get install -qq --no-install-recommends wget ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

ENV MAINNET_VERSION 1.0.2
ENV QTUM_VERSION 0.14.3
ENV QTUM_URL https://github.com/qtumproject/qtum/releases/download/mainnet-ignition-v${MAINNET_VERSION}/qtum-${QTUM_VERSION}-x86_64-linux-gnu.tar.gz

RUN QTUM_DIST=$(basename $QTUM_URL) \
	&& wget -qO $QTUM_DIST $QTUM_URL \
	&& tar -xzvf $QTUM_DIST -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm qtum*

COPY entrypoint.sh /entrypoint.sh

RUN groupadd -r qtum && useradd -r -m -g qtum qtum
USER qtum

VOLUME /home/qtum

ENTRYPOINT ["/entrypoint.sh"]
CMD ["qtumd", "-upgradewallet"]

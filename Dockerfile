FROM alpine

RUN apk update \
 && apk add python python py2-pip ruby ruby-rugged ruby-bundler git \
 && rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir mkdocs==1.0.2 mkdocs-material==3.2.0

RUN git clone https://github.com/Icinga/icinga-docs-tools.git /opt/icinga-docs-tools \
 && addgroup -g 9999 docs \
 && adduser -D -u 9999 -G docs -s /bin/sh -h /opt/icinga-docs-tools docs \
 && mkdir -p /var/www/docs \
 && chown -R docs.docs /var/www/docs /opt/icinga-docs-tools

COPY config/ /opt/icinga-docs-tools/config/
COPY bin/ /usr/local/bin/

WORKDIR /opt/icinga-docs-tools

VOLUME /var/www/docs

USER docs
EXPOSE 8000

ENTRYPOINT ["build-and-run"]
CMD ["director-snapshot"]

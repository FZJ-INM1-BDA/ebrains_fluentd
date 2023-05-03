FROM fluent/fluentd:v1.16-1

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install fluent-plugin-elasticsearch \
 && sudo gem install fluent-plugin-grafana-loki \
 && sudo gem install fluent-plugin-prometheus \
 && sudo gem install fluent-plugin-genhashvalue \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY ./fluent.conf /etc/fluent/
COPY entrypoint.sh /bin/

USER fluent

# Running plugins
ENTRYPOINT ["fluentd", "-v", "-p", "/fluentd/plugins"]

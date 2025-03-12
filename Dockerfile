FROM opensuse/tumbleweed:latest AS base

ARG PROMETHEUS_VERSION
ARG RELEASE_VERSION
ARG MEND_EMAIL
ARG MEND_URL
ARG MEND_USER_KEY
RUN mkdir -p /tmp/prometheus && \
    curl -L https://github.com/prometheus/prometheus/archive/refs/tags/v$PROMETHEUS_VERSION.tar.gz | tar --directory /tmp/prometheus --strip-components 1 -zxvf - && \
    curl -L https://downloads.mend.io/cli/linux_amd64/mend -o /tmp/mend && chmod +x /tmp/mend && \
    /tmp/mend update && \
    /tmp/mend dep -d "/tmp/prometheus" -e -s "OpenScape UC Portfolio//OSEM third party applications//prometheus-osem-sourcecode - $PROMETHEUS_VERSION-r$RELEASE_VERSION" -u --non-interactive

ARG PROMETHEUS_VERSION
RUN mkdir -p /opt/prometheus && \
    mkdir -p /etc/prometheus && \
    curl -L https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-$(uname -p | sed s/aarch64/arm64/ | sed s/x86_64/amd64/).tar.gz | tar --directory /opt/prometheus --strip-components 1 --wildcards -zxvf - *prometheus && \
    groupadd -g 9090 -r prometheus && useradd -u 9090 -d /tmp -g prometheus prometheus && \
    chown -R prometheus:prometheus /opt/prometheus && \
    chown -R prometheus:prometheus /etc/prometheus && \
    rpm -e --allmatches $(rpm -qa --qf "%{NAME}\n" | grep -v -E "bash|coreutils|filesystem|glibc$|libacl1|libattr1|libcap2|libgcc_s1|libgmp|libncurses|libpcre1|libreadline|libselinux|libstdc\+\+|openSUSE-release|system-user-root|terminfo-base|libpcre2") && \
    rm -Rf /etc/zypp && \
    rm -Rf /usr/lib/zypp* && \
    rm -Rf /var/{cache,log,run}/* && \
    rm -Rf /var/lib/zypp && \
    rm -Rf /usr/lib/rpm && \
    rm -Rf /usr/lib/sysimage/rpm && \
    rm -Rf /usr/share/man && \
    rm -Rf /usr/local && \
    rm -Rf /srv/www

FROM scratch

COPY --from=base / /

USER 9090:9090

EXPOSE 9090

WORKDIR /opt/prometheus

CMD [ "/opt/prometheus/prometheus", "--config.file=/etc/prometheus/prometheus.yml" ]

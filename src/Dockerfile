# check=error=true

# Please build the Dockerfile from the generate.sh script
ARG TERMUX_DOCKER_TAG=please-build-w/t-generate-sh-script
FROM ${TERMUX_DOCKER_TAG}

ADD --chown=1000:1000 https://github.com/termux/termux-packages.git /source

RUN --mount=source=setup.sh,target=/setup.sh \
    --mount=type=cache,target=/data/data/com.termux/cache/apt,uid=1000,gid=1000 \
    ["/entrypoint.sh", "login", "-c", "/setup.sh"]

RUN ["/system/bin/rm", "-r", "-f", "/source"]
    
COPY --chown=1000:1000 motd.sh /data/data/com.termux/files/home/.termux/motd.sh
